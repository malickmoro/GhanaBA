//
//  MainMRZ.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/15/24.
//

import SwiftUI

struct MainMRZ: View {
    @ObservedObject var appVM: AppViewModel


    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Your content
                HStack {
                    
                    Spacer()
                    
                    Button{
   
                        appVM.currentView = .chooseMethod
                        
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 30, weight: .medium, design: .default))
                            .foregroundColor(.red)

                    }
                }
                .padding(.horizontal, 30)
                MRZOfficial(shouldNavigate: $shouldNavigate, appVM: appVM)
                
                // Navigate based on shouldNavigate state
                Color.clear
                    .frame(width: 0, height: 0)
                    .hidden()
                    .onChange(of: shouldNavigate) { _ in
                        if shouldNavigate {
                            appVM.currentView = .mrzFace
                            print(appVM.documentID)
                        }
                    }
            }
        }
    }
}

#Preview {
    MainMRZ(appVM: AppViewModel())
}
