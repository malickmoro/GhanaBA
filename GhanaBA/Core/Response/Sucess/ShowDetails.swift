//
//  Show Details.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

struct ShowDetails: View {
    @ObservedObject var pVM: PersonViewModel
    @ObservedObject var appVM: AppViewModel
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var cmVM: CameraModel
    @ObservedObject var face: FaceCaptureModel




    
    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80

    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Text("VERIFICATION RESULT")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(blue)
                    
                Spacer()
                
                Rectangle()
                    .frame(width: 350,height: 540)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
                    .overlay {
                        VStack (spacing: 20){
                            VStack (spacing: 0){
                                if let faceImage = pVM.faceImage {
                                    Image(uiImage: faceImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200)
                                        .clipShape(Circle())
                                        .shadow(radius: 4)
                                } else {
                                    // Placeholder if there's no image
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .frame(width: 200)
                                        .overlay(Circle().stroke(blue.opacity(0.5), lineWidth: 4))
                                        .foregroundColor(.gray)
                                }
                                
                                
                                Text(pVM.fullName)
                                    .font(.title2)
                                    .foregroundStyle(blue)
                                
                            }

                            
                            Rectangle()
                                .frame(width: 300,height: 100)
                                .foregroundStyle(.gray.opacity(0.4))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay {
                                    VStack (spacing: 0){
                                        Text("AUTHORIZATION CODE")
                                            .font(.system(size: 20, weight: .semibold))
                                            .frame(width: 300, height: 50)
                                            .background(blue.opacity(0.85))
                                            .foregroundStyle(.white)
                                        
                                        Divider()
                                        
                                        Text(pVM.shortGuid ?? "The boy")
                                            .font(.system(size: 20, weight: .medium))
                                            .frame(width: 300, height: 50)
                                            .background(.gray.opacity(0.001))
                                            .foregroundStyle(.black)
                                    }
                                            .clipShape(RoundedRectangle(cornerRadius: 15))

                                }
                            
                            Button {
                                
                                appVM.currentView = .chooseMethod
                                pVM.reset()
                                idVM.reset()
                                cmVM.reset()
                                appVM.reset()
                                face.reset()
                                
                            } label: {
                                Text("Done")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: 120, height: 50)
                                    .foregroundStyle(.white)
                                    .background(blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                            }
                        }
                        .padding(.bottom, 10)
                        .padding()

                    }
                
                Spacer()
                
                Image("ghana")
                    .resizable()
                    .frame(width: logoWidth, height: logoHeight)
                    .padding(.leading, 20)
            }
            .padding()
        }
    }
}

#Preview {
    ShowDetails(pVM: PersonViewModel(), appVM: AppViewModel(), idVM: idCaptureViewModel(), cmVM: CameraModel(appVM: AppViewModel()), face: FaceCaptureModel())
}
