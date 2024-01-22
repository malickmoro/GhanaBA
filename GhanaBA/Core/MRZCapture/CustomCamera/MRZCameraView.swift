//
//  MRZCameraView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/12/24.
//

import SwiftUI

@available(iOS 16.0, *)

struct MRZCameraView: View {
    @ObservedObject var model: MRZCameraModel
    @ObservedObject var appVM: AppViewModel
    @ObservedObject var cmVM: CameraModel

    
    @Environment(\.colorScheme) var colorScheme  // Access the current color scheme
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    var captureButton: some View {
        Button(action: {
            
        }, label: {
            Circle()
                .foregroundColor(model.patternFound ? .green : .red)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Button(action: {
                            model.switchFlash()
                        }, label: {
                            Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                .font(.system(size: 25, weight: .medium, design: .default))
                        })
                        .accentColor(model.isFlashOn ? .yellow : .white)
                        
                        Spacer()
                        
                        Button{
                            appVM.currentView = .chooseMethod
                            model.stopcamera()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .medium, design: .default))
                                .foregroundColor(.white)
                            
                        }
                    }
                    .padding(.horizontal, 30)
 
                    MRZCameraPreview(session: model.session!)
                        .onAppear {
                            model.configure()
                            model.startCam()
                        }
                        .onTapGesture(count: 1, perform: handleTap)
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .overlay {
                            VStack (alignment: .center, spacing: 10) {
                                Text("Please align card in frame to scan")
                                    .background(.white)
                                    .foregroundColor(.gray)
                                    .frame(width: UIScreen.main.bounds.width, height: 30, alignment: .center)
                                
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width, height: 80) // Adjust frame size
                                    .foregroundColor(.clear) // Clear frame
                                    .border(Color.white, width: 1.3) // Frame border
                            }
                            .compositingGroup()
                            .animation(.easeInOut, value: 1.2)
                          
                        }
                    
                    HStack {
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                        
                    }
                    .padding(.horizontal, 20)
                }
                .onChange(of: model.patternFound) { newValue in
                    if newValue {
                        appVM.currentView = .mrzFace
                        appVM.mrzGO = true
                    }
                }

            }
           
            
        }
    }
    private func handleTap(location: CGPoint) {
        // Convert the tap location to the camera's coordinate system
        // This might involve translating the CGPoint to the camera's coordinate system
        // Then, call the focus function on your camera model
        model.focus(at: CGPoint(x: 0.5, y: 0.5))
    }
}


#Preview {
    CameraView(model: CameraModel(appVM: AppViewModel()), appVM: AppViewModel(), mrz: MRZCameraModel())
}
