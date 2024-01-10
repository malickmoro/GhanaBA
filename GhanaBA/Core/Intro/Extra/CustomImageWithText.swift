//
//  CustomImageWithText.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct CustomImageWithText: View {
    var body: some View {
        VStack {
            Image("splash")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 30, height: 500)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 7)
                .overlay {
                    Text("A smart way to verify IDENTITY")
                        .bold()
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding(.trailing, 130)
                        .padding(.bottom,400 )
                    
                    CheckmarkAnimationView()
                        .padding(.bottom, 250)
                        
                    Text("Quickly and securely verify \nthe identity of individuals with Ghana cards.")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .font(.title2)
                        .padding(.top, 390)
                }
        }
    }
}

#Preview {
    CustomImageWithText()
}
