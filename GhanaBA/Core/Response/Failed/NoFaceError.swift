//
//  NoPhotoError.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct NoPhotoError: View {
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var face: FaceCaptureModel


    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80
    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            VStack {
                
                VStack (){
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image (systemName: "camera")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .padding(.trailing, 200)
                                .padding(.bottom, 50)
                                .symbolEffect(.bounce, value: 100)

                                .overlay {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 50, height: 50)
                                        .padding(.trailing, 200)
                                        .padding(.bottom, 50)
                                        .fontWeight(.bold)
                                        .symbolEffect(.bounce, value: 80)

                                }
                        }
                    
                    
                }
                .padding(.top, 60)
                .padding(.leading, 50)
                .foregroundStyle(.black)
                
                Spacer().frame(height: 50 )
                Text("Sorry !")
                    .font(.system(size: 35, weight: .semibold))
                    .foregroundStyle(.black)
                
                Text("No image captured.")
                    .font(.system(size: 25, weight: .medium))
                    .foregroundStyle(.black)

                
                Spacer()
                
                VStack {
                    Button {
                        idVM.showAlert = false
                        face.showAlert = false
                    } label: {
                        Text("Try again")
                            .font(.system(size: 20, weight: .semibold))
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
@available( iOS 17.0, *)
#Preview {
    NoPhotoError(idVM: idCaptureViewModel(), face: FaceCaptureModel())
}
