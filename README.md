# InkShader

An interactive SwiftUI + Metal demo that applies a custom **stitchable shader** to a view with `.layerEffect`. A circular shape is warped in real time by a swirling, ink-like distortion field, and you can play with it directly.

## What it does

The `ink` shader builds a ring of points around your touch location and treats each one as a small rotational vortex. Summing the twist contributions of all the points produces a smooth, ink-in-water displacement that samples the underlying layer. [Perlin noise](https://en.wikipedia.org/wiki/Perlin_noise) offsets each point so the motion gently "dances," and a timer advances the animation over time.

## Controls

- **Drag** anywhere on the circle to move the center of the swirl.
- **strength** slider — how strongly the field distorts the layer.
- **dots** slider — the number of points making up the vortex ring.

## How it works

| File | Role |
| --- | --- |
| `InkShader/Shader.metal` | The `[[ stitchable ]] ink(...)` fragment shader plus Perlin-noise helpers. |
| `InkShader/ContentView.swift` | Hosts the shape, wires sliders/drag to shader parameters, and drives `time` with a 30 fps `Timer`. |
| `InkShader/InkShaderApp.swift` | App entry point. |

The shader is invoked from SwiftUI like this:

```swift
.layerEffect(
    ShaderLibrary.ink(.boundingRect, .float2(dp), .float(strength), .float(time), .float(numberofdots)),
    maxSampleOffset: .zero
)
```

## Requirements

- Xcode 15+
- A platform that supports SwiftUI shader effects (iOS 17+ / macOS 14+)

## Running

Open `InkShader.xcodeproj` in Xcode and run.
