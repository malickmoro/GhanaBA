//
//  IdCaptureView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

@available(iOS 17.0, *)
struct IdCaptureView: View {
    @ObservedObject var idVM: idCaptureViewModel
    @ObservedObject var appVM: AppViewModel
    @ObservedObject var cmVM: CameraModel
    @ObservedObject var pVM: PersonViewModel
    @ObservedObject var face: FaceCaptureModel

   
    @State var showAlert: Bool = false
    @State var stop: Bool = false
    
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
                .padding(.top, 750)
                .padding(.leading, 20)
            
            
            
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack (spacing: 20){
                        Text("Ghana Card \nVerification")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundStyle(blue)
                        
                        if let editedImage = appVM.imageToShow {
                            Image(uiImage: editedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height/3)
                                .clipShape(Circle())
                                .shadow(radius:2)
                                .onAppear {
                                    idVM.isImageSelected = appVM.imageToShow != nil
                                }
                                .onTapGesture(count: 2, perform: capturePhotoPressed)
                        } else {
                            Circle()
                                .frame(width: 250)
                                .foregroundColor(.white)
                                .shadow(radius:3)
                                .overlay {
                                    Button {
                                        appVM.currentView = .camera
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
                            .foregroundColor(.white)
                            .shadow(radius:3)
                            .overlay {
                                VStack (alignment: .leading, spacing: 5){
                                    Text ("Enter Ghana Card Number")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(blue)
                                    
                                    TextField("", text: Binding(
                                        get: { self.idVM.pin.uppercased() },
                                        set: { newValue in
                                            self.idVM.pin = newValue
                                            self.idVM.isInvalid = false
                                        }
                                    ))
                                        .padding(.horizontal, 10) // Add horizontal padding inside the TextField
                                        .frame(width: 300, height: 45)
                                        .background(blue.opacity(0.1))
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay {
                                            HStack {
                                                if idVM.isInvalid {
                                                    Spacer() // Push the icon to the right
                                                    Image(systemName: "exclamationmark.circle.fill")
                                                        .resizable()
                                                        .frame(width: 22, height: 22)
                                                        .foregroundColor(.red)
                                                        .padding(.trailing, 12) // Padding to the right edge
                                                }
                                            }
                                        }
                                    if idVM.isInvalid {
                                        Text("PIN Number is invalid.")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .padding(.leading, 10)
                                    }
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
                                    appVM.currentView = .chooseMethod
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                    idVM.reset()
                                    cmVM.reset()
                                    appVM.reset()
                                    pVM.reset()
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
            .sheet(isPresented: $idVM.showAlert, content: {
                NoPhotoError(idVM: idVM, face: face)
            })
            
            if  pVM.isLoading {
                VStack {
                    Checkmark2(stop: $stop).ignoresSafeArea().background(.gray.opacity(0.4))
                    
                }
            }
        }
    }
    
    func checkReadiness() {
        checkPin()
        checkImage()
        
        if idVM.isPinValid && idVM.isImageSelected {
            pVM.editedImage = appVM.imageToShow
            pVM.generatedID = idVM.pin
            pVM.verifyIDAndImage { transactionFound in
                DispatchQueue.main.async {
                    if transactionFound && stop == true {
                        // If the 'found' boolean is true, change the view
                        appVM.currentView = .success
                    } else {
                        // If the 'found' boolean is false, show an alert
                        appVM.currentView = .notFound
                    }
                }
            }
        }
    }
    
    func checkPin(){
        if idVM.pin.count == 15 {
            idVM.isPinValid = idVM.validateID(fullID: idVM.pin)
        } else {
            idVM.isPinValid = false
            idVM.isInvalid = true
        }
    }
    
    func checkImage() {
        if !idVM.isImageSelected {
            idVM.showAlert = true
            showAlert.toggle()
        }
    }

    func capturePhotoPressed() {
        appVM.showCamera()
    }
}


@available(iOS 17.0, *)
#Preview {
    IdCaptureView(idVM: idCaptureViewModel(), appVM: AppViewModel(), cmVM: CameraModel(appVM: AppViewModel()), pVM: PersonViewModel(), face: FaceCaptureModel())
}
