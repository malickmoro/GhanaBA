//
//  LottieView.swift
//  GhanaBa
//
//  Created by Malick Moro-Samah on 1/5/24.
//
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String
    let loopMode: LottieLoopMode
    let animationSpeed: CGFloat

    init(name: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1) {
        self.name = name
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }

    func makeUIView(context: Context) -> UIView {
        let parentView = UIView(frame: .zero)
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView(frame: .zero)
        container.translatesAutoresizingMaskIntoConstraints = false

        let animationView = LottieAnimationView(name: name)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()

        parentView.addSubview(animationView)


        return parentView
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed.
    }
}


