//
//  ContentView.swift
//  InkShader
//
//  Created by Minsang Choi on 5/30/26.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var strength : CGFloat = 0.002
    @State private var time : CGFloat = 0
    @State private var dp = CGPoint(x:150, y:150) //touch point that decideds distance
    @State private var numberofdots : CGFloat = 38
    let timer = Timer.publish(every: 1/30, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack{

            Color.primary
                .frame(width:300, height:300) //size of circle
                .cornerRadius(150)
                .layerEffect(ShaderLibrary.ink(.boundingRect, .float2(dp), .float(strength), .float(time), .float(numberofdots)), maxSampleOffset: .zero)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dp = value.location
                        }
                )

            
            VStack{
                Spacer()
                Text("Tar")
                    .font(.system(size:15))
                    .bold()
                    .padding()
                HStack{
                    Text("strength")
                    Slider(value:$strength, in:0...0.003)
                    Text("\(strength, specifier: "%.3f")")
                }
                HStack{
                    Text("dots")
                    Slider(value:$numberofdots, in:0...56)
                    Text("\(numberofdots, specifier: "%.0f")")
                }
            }
            .tint(Color.yellow)
            .font(.system(size: 12, design: .monospaced))
            .padding()
            .onReceive(timer) { _ in
                time += 0.01
            }
            

        }
    }
}

#Preview {
    ContentView()
}
