//
//  Shader.metal
//  InkShader
//
//  Created by Minsang Choi on 5/30/26.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

float2 hash(float2 p) {
    p = float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
}

float perlinNoise(float2 p) {
    float2 i = floor(p);
    float2 f = fract(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(dot(hash(i + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
                   dot(hash(i + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
               mix(dot(hash(i + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
                   dot(hash(i + float2(1.0, 1.0)), f - float2(1.1, 1.0)), u.x), u.y);
}


[[ stitchable ]] half4 ink(float2 pos, SwiftUI::Layer l, float4 boundingRect, float2 dragp, float strength, float time, float points) {
    float2 size = float2(boundingRect.zw);
    float2 uv = pos / size;
    float2 dp = dragp / size;
    
    float2 center = dp;
    float radius = 0.4;
    const float PI = 3.14159265359;
    int numPoints = points;
    
    float rotationSpeed = 0.5; // radians per unit time
    
    float2 displacement = float2(0.0);
    for (int i = 0; i < numPoints; i++) {
        float angle = 24.0 * PI * float(i) / float(numPoints) + time * rotationSpeed;
        float2 basePoint = center + radius * float2(sin(angle), cos(angle));
        
        // Noise-driven "dance" offset
        float2 offset = float2(perlinNoise(basePoint * 2.0 + float2(i)), perlinNoise(basePoint * 2.0 + float2(i))) * 0.1;
        float2 attractor = basePoint + offset;
        
        float2 dir = attractor - uv;
        float dist = length(dir);
        if (dist > 0.01) {
            // Twist: rotational field
            float2 twist = float2(-dir.y, dir.x) / (dist * dist);
            displacement += twist * strength / max(dist, 0.1);
        }
    }
    
    half4 color = l.sample((uv + displacement) * size);
    return color;
}


