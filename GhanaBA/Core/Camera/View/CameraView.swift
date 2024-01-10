import SwiftUI

struct CameraView: View {
    @ObservedObject var model:CameraModel
    @ObservedObject var appVM: AppViewModel
    
    @Environment(\.colorScheme) var colorScheme  // Access the current color scheme
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    var capturedPhotoThumbnail: some View {
        Group {
            if model.photo != nil {
               Rectangle()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .animation(.spring, value: 1.3)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 60, alignment: .center)
                    .foregroundColor(colorScheme == .dark ? .black : .black)  // Dynamic color change

            }
        }
    }
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
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
                            appVM.currentView = .pinMethod
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 30, weight: .medium, design: .default))
                                .foregroundColor(.white)

                        }
                    }
                    .padding(.horizontal, 30)
                    
                    CameraPreview(session: model.session)
                        .gesture(
                            DragGesture().onChanged({ (val) in
                                //  Only accept vertical drag
                                if abs(val.translation.height) > abs(val.translation.width) {
                                    //  Get the percentage of vertical screen space covered by drag
                                    let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                    //  Calculate new zoom factor
                                    let calc = currentZoomFactor + percentage
                                    //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                    let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                    //  Store the newly calculated zoom factor
                                    currentZoomFactor = zoomFactor
                                    //  Sets the zoom factor to the capture device session
                                    model.zoom(with: zoomFactor)
                                }
                            })
                        )
                        .onAppear {
                            model.startCam()
                            model.configure()
                        }
                        .alert(isPresented: $model.showAlertError, content: {
                            Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                model.alertError.primaryAction?()
                            }))
                        })
                        .overlay(
                            Group {
                                if model.willCapturePhoto {
                                    Color.black
                                }
                            }
                        )
                        .animation(.easeInOut, value: 1.2)
                    
                    HStack {
                        capturedPhotoThumbnail
                        
                        Spacer()
                        
                        captureButton
                        
                        Spacer()
                        
                        flipCameraButton
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
            .fullScreenCover(isPresented: $model.isEditing) {
                ImageEditorViewController(image: model.imageToEdit!) {
                    model.completeEditing(with: $0!)
                    appVM.currentView = .pinMethod
                } onEditingCancelled: {
                    model.cancelEditing()
                }
            }
        }
    }
}

#Preview {
   CameraView(model: CameraModel(), appVM: AppViewModel())
}
