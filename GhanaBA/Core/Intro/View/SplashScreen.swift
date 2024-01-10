//
//  SplashScreen.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct SplashScreen: View {
    @ObservedObject var appVm: AppViewModel

    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 200) {
                VStack {
                    
                    SplashScreenGIF()
                    
                }
                
                Image("whiteLogo")
                    .resizable()
                    .frame(width: 150, height: 80)
            }
            .padding(.top, 120)
            .frame(width: geometry.size.width, height: geometry.size.height) // Set frame to the size of the screen
            .background(blue.ignoresSafeArea())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5){
                    withAnimation {
                        appVm.currentView = .secondOne
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen(appVm: AppViewModel())
}
