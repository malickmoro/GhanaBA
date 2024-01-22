//
//  FaceCaptureModel.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/15/24.
//
import Foundation
import SwiftUI


class FaceCaptureModel: ObservableObject {
    @Published var image: UIImage?
    @Published var editedImage: UIImage?
    @Published var isImageSelected: Bool = false
    @Published var showAlert: Bool = false
    @Published var document: String?
    

}
extension FaceCaptureModel: Resettable {
    func reset() {
        // Resetting boolean and string properties to their default states
    isImageSelected = false
    image = nil
    editedImage = nil

    }
}
