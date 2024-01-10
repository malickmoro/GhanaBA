//
//  StartScreen.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct StartScreen: View {
    @ObservedObject var appVm: AppViewModel
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Image("Ghanaba1")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // Set frame to the size of the screen
            .background(Color.white.ignoresSafeArea())
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    withAnimation {
                        appVm.currentView = .splashScreen
                    }
                }
            }
        }
    }
}

#Preview {
    StartScreen(appVm: AppViewModel())
}
