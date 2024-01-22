//
//  IdCaptureView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct FaceCapture: View {
    @ObservedObject var cmVM: CameraModel
    @ObservedObject var pVM: PersonViewModel
    @ObservedObject var model: MRZCameraModel
    @ObservedObject var face: FaceCaptureModel
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var appViewModel: AppViewModel

    
    @State var showAlert: Bool = false
    
    var logoWidth: CGFloat = 160
    var logoHeight: CGFloat = 80
    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)
    let green = Color(red: 7/255, green: 175/255, blue: 124/255)
    
    
    
    var body: some View {
            ZStack {
                Color.white.ignoresSafeArea()
                Image("ghana")
                    .resizable()
                    .frame(width: logoWidth, height: logoHeight)
                    .padding(.top, 700)
                    .padding(.leading, 20)
                
            
                ScrollView(showsIndicators: false) {
                    VStack {
                        VStack (spacing: 20){
                            Text("Ghana Card \nVerification (MRZ)")
                                .font(.system(size: 35, weight: .bold))
                                .foregroundStyle(blue)
                            
                            if let editedImage = appViewModel.imageToShow {
                                Image(uiImage: editedImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height/3)
                                    .clipShape(Circle())
                                    .shadow(radius:2)
                                    .onAppear {
                                        face.isImageSelected = appViewModel.imageToShow != nil
                                    }
                                    .onTapGesture(count: 2, perform: capturePhotoPressed)
                            } else {
                                Circle()
                                    .frame(width: 250)
                                    .foregroundColor(.white)
                                    .shadow(radius:3)
                                    .overlay {
                                        Button {
                                            appViewModel.currentView = .camera
                                        } label: {
                                            VStack(spacing: 10) {
                                                Image (systemName: "camera")
                                                    .resizable()
                                                    .frame(width: 50,height: 40)
                                                
                                                Text ("Tap here to \ncapture image")
                                                    .font(.system(size: 18, weight: .medium))
                                                    .foregroundStyle(blue)
                                            }
                                        }
                                    }
                            }
                            
                            Rectangle()
                                .frame(width: 350, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius:3)
                                .foregroundColor(.white)
                                .overlay {
                                    VStack (alignment: .leading, spacing: 5){
                                        Text ("Document Number")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(blue)
                                        
                                        TextField("", text: $appViewModel.documentID)
                                            .padding(.horizontal, 10) // Add horizontal padding inside the TextField
                                            .frame(width: 300, height: 45)
                                            .background(blue.opacity(0.1))
                                            .foregroundColor(.black)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .disabled(true)
                                    }
                                }
                            
                            VStack {
                                Button {
                                    checkReadiness()
                                    
                                } label: {
                                    Text("Submit")
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(width: 150, height: 50, alignment: .center)
                                        .background(green)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius:5)
                                    
                                }
                                
                                Button {
                                    withAnimation(.easeOut) {
                                        appViewModel.currentView = .chooseMethod
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        face.reset()
                                        cmVM.reset()
                                        pVM.reset()
                                        model.reset()
                                        appViewModel.reset()
                                    }
                                } label: {
                                    Text("Cancel")
                                        .font(.system(size: 20, weight: .semibold))
                                        .frame(width: 150, height: 50, alignment: .center)
                                        .background(.red)
                                        .foregroundStyle(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .shadow(radius:5)
                                    
                                }
                            }
                        }
                        .padding(35)
                    }
                    
                }
                
                .sheet(isPresented: $face.showAlert, content: {
                    NoPhotoError(idVM: idVM, face: face)
                })
                
                if pVM.isLoading {
                    VStack {
                        LoadingScreen().ignoresSafeArea().background(.gray.opacity(0.4))
                    }
                }
                
            }
        
    }
    
        func checkReadiness() {
            checkImage()
            
            if face.isImageSelected {
                pVM.editedImage = appViewModel.imageToShow
                pVM.mrzNumber = appViewModel.documentID
                pVM.verifyMRZandImage() { transactionFound in
                    DispatchQueue.main.async {
                        if transactionFound {
                            // If the 'found' boolean is true, change the view
                            appViewModel.currentView = .success
                        } else {
                            // If the 'found' boolean is false, show an alert
                            appViewModel.currentView = .notFound
                        }
                    }
                }
                print("Done")
            }
        }
        
        func checkImage() {
            if !face.isImageSelected {
                face.showAlert = true
                showAlert.toggle()
            }
        }
        
        func capturePhotoPressed() {
            appViewModel.showCamera()
        }
    
}

@available(iOS 17.0, *)
#Preview {
    FaceCapture(cmVM: CameraModel(appVM: AppViewModel()), pVM: PersonViewModel(), model: MRZCameraModel(), face: FaceCaptureModel(), idVM: idCaptureViewModel(), appViewModel: AppViewModel())
}
