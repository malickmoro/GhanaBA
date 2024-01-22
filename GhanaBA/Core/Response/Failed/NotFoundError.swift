//
//  NotFoundError.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct NotFoundError: View {
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var appVM: AppViewModel


    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80
    var title: String
    var message: String
    
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            VStack {
                
                VStack(spacing: 20) {

                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 200, height: 200)
                        .symbolEffect(.bounce, value: 10)




                    
                    Text(title)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.black)
                    
                    Text(message)
                        .font(.title2)
                        .foregroundStyle(.black)
                    
                    
                }
                
                Spacer()
                
                VStack {
                    Button {
                        if appVM.mrzGO {
                            appVM.currentView = .mrzFace
                        } else {
                            appVM.currentView = .pinMethod
                        }
                    } label: {
                        Text("Try Again")
                            .font(.title3)
                            .bold()
                            .frame(width: 120, height: 60)
                            .foregroundStyle(.white)
                            .background(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                    
                    Image("ghana")
                        .resizable()
                        .frame(width: logoWidth, height: logoHeight)
                        .padding(.leading, 20)
                }
            }
            .padding()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    NotFoundError(idVM: idCaptureViewModel(), appVM: AppViewModel(), title: "Error", message: "Yawa dey" )
}
