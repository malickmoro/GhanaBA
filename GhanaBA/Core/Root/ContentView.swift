//
//  ContentView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
import AVKit

@available(iOS 16.0, *)
@available(iOS 17.0, *)

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
        @StateObject var idVM = idCaptureViewModel()
        @StateObject var pVM = PersonViewModel()
        @StateObject var mrz = MRZCameraModel()
        @StateObject var face = FaceCaptureModel()


        // Computed property for lazy initialization of CameraModel
    private var cmVM: CameraModel {
        CameraModel(appVM: viewModel)
    }


    var body: some View {
        VStack {
            switch viewModel.currentView {
            case .logoShow:
                StartScreen(appVm: viewModel)
            case .splashScreen:
                SplashScreen(appVm: viewModel)
            case .secondOne:
                SecondOne(appVm: viewModel)
            case .getStarted:
                GetStarted(appVM: viewModel)
            case .chooseMethod:
                ChooseMethod(appVM: viewModel)
            case .pinMethod:
                IdCaptureView(idVM: idVM, appVM: viewModel, cmVM: cmVM, pVM: pVM, face: face)
            case .mrzScan:
                MainMRZ(appVM: viewModel)
            case .camera:
                CameraView(model: cmVM, appVM: viewModel, mrz: MRZCameraModel())
            case .success:
                SuccessView(idVM: idVM, appVM: viewModel, pVM: pVM, cmVM: cmVM, face: face)
            case .noFace:
                NoPhotoError(idVM: idVM, face: face)
            case .notFound:
                NotFoundError(idVM: idVM, appVM: viewModel, title: pVM.alertTitle, message: pVM.alertMessage)
            case .mrzFace:
                FaceCapture(cmVM: cmVM, pVM: pVM, model: mrz, face: face, idVM: idVM, appViewModel: viewModel)
            }
            
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentView)
    }
}
@available(iOS 16.0, *)
@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
