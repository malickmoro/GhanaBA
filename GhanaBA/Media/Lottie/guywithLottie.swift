//
//  guywithLottie.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct guywithLottie: View {
    var body: some View {
        ZStack {
            Image("guy")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 50, height: 460)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .shadow(radius: 7)
                .overlay {
                        LottieView(name: "card load", width: 120, height: 130, loopMode: .loop, animationSpeed: 1)
                        .padding(.leading, UIScreen.main.bounds.width / 2)
                }
            
           
        }
    }
}

#Preview {
    guywithLottie()
}
