//
//  SuccessView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

struct SuccessView: View {
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var appVM: AppViewModel
    @ObservedObject var pVM: PersonViewModel
    @ObservedObject var cmVM: CameraModel
    @ObservedObject var face: FaceCaptureModel



    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80
    let green = Color(red: 7/255, green: 175/255, blue: 124/255)
    @State var showDetails: Bool = false

    
    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            VStack {
                
                VStack(spacing: 20) {
                    LottieView(name: "check mark", loopMode: .playOnce, animationSpeed: 1)
                        .padding(.leading, 50)
                        .frame(height: 200).frame(width: 300)
                    Text("Found")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundStyle(.black)
                    
                    Text("Tap Done To View ")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundStyle(.black)

                    
                }
                
                Spacer()
                
                VStack {
                    Button {
                        showDetails.toggle()
                    } label: {
                        Text("Done")
                            .font(.system(size: 25, weight: .semibold))
                            .frame(width: 120, height: 60)
                            .foregroundStyle(.white)
                            .background(green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                        
                    }
                    
                    Image("ghana")
                        .resizable()
                        .frame(width: logoWidth, height: logoHeight)
                        .padding(.leading, 20)
                }
            }
            .padding()
            .sheet(isPresented: $showDetails, content: {
                ShowDetails(pVM: pVM, appVM: appVM, idVM: idVM, cmVM: cmVM, face: face)
            })
        }
    }
}

#Preview {
    SuccessView(idVM: idCaptureViewModel(), appVM: AppViewModel(), pVM: PersonViewModel(), cmVM: CameraModel(appVM: AppViewModel()), face: FaceCaptureModel())
}
