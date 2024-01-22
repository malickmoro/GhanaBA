//
//  SecondOne.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

struct SecondOne: View {
    @ObservedObject var appVm: AppViewModel

    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    CustomImageWithText()
                        .padding()
                    
                    Spacer()
                    
                    HStack {
                        Image("ghana")
                            .resizable()
                            .frame(width: 160, height: 100)
                            .padding()
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.snappy){
                                appVm.currentView = .getStarted
                            }
                        } label: {
                            Text("Next")
                                .bold()
                                .foregroundStyle(.white)
                                .frame(width: 130, height: 80)
                                .font(.system(size: 20, weight: .semibold))
                                .background(blue)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        
                    }
                }
                .background(Color.white)            }
        }
    }
}

#Preview {
    SecondOne(appVm: AppViewModel())
}

