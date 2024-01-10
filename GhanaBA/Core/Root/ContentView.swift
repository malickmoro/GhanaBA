//
//  ContentView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
import AVKit

@available(iOS 16.0, *)

struct ContentView: View {
    @StateObject var viewModel = AppViewModel()
    @StateObject var idVM = idCaptureViewModel()
    @StateObject var cmVM = CameraModel()
    @StateObject var pVM = PersonViewModel()


    
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
                IdCaptureView(idVM: idVM, appVM: viewModel, cmVM: cmVM, pVM: pVM)
            case .mrzScan:
                MRZCaptureView(appVM: viewModel)
            case .camera:
                CameraView(model: cmVM, appVM: viewModel)
            case .success:
                SuccessView()
            case .noFace:
                NoPhotoError(idVM: idVM)
            case .notFound:
                NotFoundError()
            }
            
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.currentView)
    }
}
@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
