//
//  idCaptureViewModel.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import Foundation
import SwiftUI


class idCaptureViewModel: ObservableObject {
    @Published var pin: String = ""
    @Published var image: UIImage?
    @Published var editedImage: UIImage?
    @Published var isImageSelected: Bool = false
    @Published var isPinValid: Bool = false
    @Published var isInvalid: Bool = false
    @Published var showAlert: Bool = false

    
    func validateID(fullID: String) -> Bool {
        let idPattern = "^[A-Z]{3}-\\d{8}[\\d-]-[\\dA-Z]$"
        let idPredicate = NSPredicate(format:"SELF MATCHES %@", idPattern)
        return idPredicate.evaluate(with: fullID)
    }
}
extension idCaptureViewModel: Resettable {
    func reset() {
        // Resetting boolean and string properties to their default states
    pin = ""
    isPinValid = false
    isImageSelected = false
    image = nil
    editedImage = nil

    }
}
