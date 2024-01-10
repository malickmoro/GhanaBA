//
//  NoPhotoError.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

struct NoPhotoError: View {
    @ObservedObject var idVM: idCaptureViewModel

    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80
    
    var body: some View {
        VStack {
            
            VStack (spacing: 20){
               Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .overlay {
                        Image (systemName: "camera")
                            .resizable()
                            .frame(width: 100, height: 90)
                            .padding(.trailing, 200)
                            .padding(.bottom, 50)
                    }
                
                
                Text("Sorry!")
                    .font(.largeTitle)
                    .bold()
                
                Text("No image captured.")
                    .font(.title2)
                
            }
            .padding(.top, 60)
            .padding(.leading, 50)
            
            Spacer()
            
            VStack {
                Button {
                    idVM.showAlert = false
                } label: {
                    Text("Try again")
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

#Preview {
    NoPhotoError(idVM: idCaptureViewModel())
}
