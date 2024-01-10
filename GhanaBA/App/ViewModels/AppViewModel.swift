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


    enum ViewIdentifier {
        case logoShow, splashScreen, secondOne, getStarted, chooseMethod, pinMethod, mrzScan, camera, success, noFace, notFound
    }
    
    func chooseMethod() {
        self.currentView = .chooseMethod
    }
    
    func showCamera() {
        self.currentView = .camera
    }

}
