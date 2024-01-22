//
//  ChooseMethod.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI


@available(iOS 16.0, *)

struct ChooseMethod: View {
    @ObservedObject var appVM: AppViewModel
    @ObservedObject var b1 = customButton(fontColor: Color.white, buttonColor: Color(red: 7/255, green: 175/255, blue: 124/255))
    @ObservedObject var b2 = customButton(fontColor: Color(red: 0/255, green: 51/255, blue: 171/255), buttonColor: Color(red: 0/255, green: 51/255, blue: 171/255).opacity(0.1))

    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    let videoNames: [String] = ["PIN", "MRZ"] // Names of videos without the file extension
    @State private var currentIndex: Int = 0

    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Verification Method")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundStyle(blue)
                
                Text("Select preferred verification method \n to begin process")
                    .font(.system(size: 20, weight: .regular))
                
                    .foregroundStyle(blue)
                
                Spacer()
                
                VStack {
                    Button {
                        currentIndex =  0
                    } label: {
                        Text("PIN")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(currentIndex == 0 ? b1.fontColor : b2.fontColor)
                            .frame(width: 140, height: 50)
                            .background(currentIndex == 0 ? b1.buttonColor : b2.buttonColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 7)
                    }
                    Button {
                        currentIndex =  1
                    } label: {
                        Text("MRZ")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(currentIndex == 1 ? b1.fontColor : b2.fontColor)
                            .frame(width: 140, height: 50)
                            .background(currentIndex == 1 ? b1.buttonColor : b2.buttonColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 7)
                    }
                }
                
                HStack (spacing: 5){
                    Button {
                        withAnimation(.smooth) {
                            currentIndex = 0
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(currentIndex == 0 ? Color.gray.opacity(0.2) : .gray)
                        
                    }
                    
                    VideoCarouselView(videos: videoNames, currentIndex: currentIndex)
                    
                    Button {
                        withAnimation(.smooth) {
                            currentIndex = 1
                        }
                    } label: {
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(currentIndex == 1 ? Color.gray.opacity(0.2) : .gray)
                    }
                }
                .padding()
                
                Button {
                    if currentIndex == 0 {
                        appVM.currentView = .pinMethod
                    }else{
                        appVM.currentView = .mrzScan
                    }
                } label: {
                    Text("Tap to confirm")
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(width: 160, height: 50)
                        .background(blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 7)
                }
                
                Spacer()
                
                HStack {
                    Image("ghana")
                        .resizable()
                        .frame(width: 160, height: 100)
                    
                    Spacer()
                    
                    Button {
                        appVM.currentView = .getStarted
                    } label: {
                        VStack {
                            Image(systemName: "power")
                            
                            Text("Logout")
                                .font(.system(size: 18))
                            
                        }
                        .bold()
                        .foregroundStyle(blue)
                    }
                    
                    
                }
                
                
                
            }
            .padding(30)
            .padding(.top, 30)

            .ignoresSafeArea()
            .frame(width: geometry.size.width, height: geometry.size.height) // Set frame to the size of the screen
            .background(Color.white)
        }
        
    }
}
@available(iOS 16.0, *)
#Preview {
    ChooseMethod(appVM: AppViewModel())
}
