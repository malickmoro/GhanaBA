//
//  Checkmark2.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/19/24.
//
import SwiftUI

struct Checkmark2: View {
    @State private var rotation: Double = 0
    @State private var startTrim: CGFloat = 0
    @State private var endTrim: CGFloat = 0
    @State private var showCheckmark = false
    @State private var fillCircle = false
    @State private var scale: CGFloat = 1
    @Binding var stop: Bool
    @State private var countzone = 10

    let circleSize: CGFloat = 80 // Reduced from 100 to 50
    let lineWidth: CGFloat = 8 // Reduced from 5 to 2.5
    let checkmarkScale: CGFloat = 0.5 // Scaling factor for the checkmark

    var body: some View {
        ZStack {
            Color .clear.ignoresSafeArea()
            // Circle drawing and rotating animation
            Circle()
                .trim(from: startTrim, to: endTrim)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: rotation))

            // Filling circle animation
            Circle()
                .frame(width: circleSize, height: circleSize)
                .foregroundColor(fillCircle ? .green : .clear)
                .scaleEffect(fillCircle ? 1 : 0)

            // Checkmark drawing animation
            Path { path in
                // Adjust the path points to match the new size
                path.move(to: CGPoint(x: 35 * checkmarkScale, y: 60 * checkmarkScale))
                path.addLine(to: CGPoint(x: 50 * checkmarkScale, y: 72 * checkmarkScale))
                path.addLine(to: CGPoint(x: 80 * checkmarkScale, y: 40 * checkmarkScale))
            }
            .trim(from: 0, to: showCheckmark ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: lineWidth - 5, lineCap: .round, lineJoin: .round))
            .frame(width: circleSize, height: circleSize)
            .foregroundColor(.white)
            .scaleEffect(2)
            .rotationEffect(Angle(degrees: 0))

            // Animations
            .onAppear {
                // Start the circle rotation and trimming animation
                withAnimation(Animation.linear(duration: 1).repeatCount( stop ? 0: 200, autoreverses: false)) {
                    rotation = 360
                    endTrim = 1
                }
                // Simulate a delay before filling the circle and showing the checkmark
                if stop {
                   countzone = 0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(Animation.linear(duration: 1)) {
                            fillCircle = true
                            startTrim = 0
                            endTrim = 1
                        }
                        withAnimation(Animation.easeOut(duration: 0.5).delay(1)) {
                            // Trigger the checkmark animation and stop the rotation
                            showCheckmark = true
                        }
                        withAnimation(Animation.easeInOut(duration: 0.3).delay(1.5).repeatCount(2, autoreverses: true)) {
                            // Bounce effect
                            scale = 1.2
                        }
                    }
                }
            }
                    .padding(.leading, 38)
                    .padding(.top, 50)
            
        }
    }
}

struct Checkmark2_Previews: PreviewProvider {
    static var previews: some View {
        Checkmark2(stop: .constant(false))
    }
}
