//
//  AppViewModel.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI

class AppViewModel: ObservableObject {

    @Published var currentView: ViewIdentifier = .logoShow
    @Published var showLoad: Bool = false
    @Published var mrzGO: Bool = false
    @Published var  imageToShow: UIImage?
    @Published var documentID: String = ""


    enum ViewIdentifier {
        case logoShow, splashScreen, secondOne, getStarted, chooseMethod, pinMethod, mrzScan, camera, success, noFace, notFound, mrzFace
    }
    
    func showCamera() {
        self.currentView = .camera
    }

    func reset() {
        mrzGO = false
        showLoad = false
        imageToShow = nil
        documentID = ""
    }
}
