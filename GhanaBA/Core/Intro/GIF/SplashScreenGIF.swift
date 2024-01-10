//
//  SplashScreenGIF.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct SplashScreenGIF: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> SplashScreenViewController {

        return SplashScreenViewController()
    }
    
    func updateUIViewController(_ uiViewController: SplashScreenViewController, context: Context) {
    }
}

#Preview {
    SplashScreenGIF()
}
