//
//  LoadindScreen.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

struct LoadingScreen: View {
    var body: some View {
        VStack {
            LottieView(name: "green loading", loopMode: .loop, animationSpeed: 1.2)
                .padding(.leading, 60)
                .padding(.top, 300)
        }
    }
}

#Preview {
    LoadingScreen()
}
