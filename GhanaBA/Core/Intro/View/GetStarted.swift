//
//  GetStarted.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
@available(iOS 16.0, *)

struct GetStarted: View {
    @ObservedObject var appVM: AppViewModel
    
    var logoWidth: CGFloat = 150
    var logoHeight: CGFloat = 80
    var btnWidth: CGFloat = 130
    var btnHeight: CGFloat = 50
    var fontsizeBtn: Font = .callout
    var fontsizetxt: Font = .title3


    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(alignment: .center) {
                    Spacer()
                    
                    guywithLottie()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 7)
                    
                    Spacer()
                    
                    VStack (spacing: 30){
                        Text("Please login to begin \nverifying Ghana cards.")
                            .foregroundStyle(blue)
                            .font(fontsizetxt)
                            .fontWeight(.semibold)
                        
                        Button {
                            withAnimation(.bouncy){
                                appVM.currentView = .chooseMethod
                            }
                        } label: {
                            Text("Get Started")
                                .font(fontsizeBtn)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .frame(width: btnWidth, height: btnHeight)
                                .background(blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 7)
                        }
                    }
                    Spacer()

                }

                Image("ghana")
                    .resizable()
                    .frame(width: logoWidth, height: logoHeight)
            }
            .padding()

            .ignoresSafeArea()
            .frame(width: geometry.size.width, height: geometry.size.height) // Set frame to the size of the screen
            .background(Color.white)
        }
    }
}

@available(iOS 16.0, *)

#Preview {
    GetStarted(appVM: AppViewModel())
}
