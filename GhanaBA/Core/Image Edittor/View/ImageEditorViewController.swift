//
//  ImagrEdit.swift
//  VR
//
//  Created by Young Prodigy on 1/2/24.
//

import SwiftUI

struct ImageEditorViewController: UIViewControllerRepresentable {
    var image: UIImage
    var onEditingDone: ((UIImage?) -> Void)?  // Changed to UIImage?
    var onEditingCancelled: (() -> Void)?

    func makeUIViewController(context: Context) -> ImageEditorView {
        let editorVC = ImageEditorView()
        editorVC.imageToEdit = image
        editorVC.onEditingDone = onEditingDone
        editorVC.onEditingCancelled = onEditingCancelled
        return editorVC
    }

    func updateUIViewController(_ uiViewController: ImageEditorView, context: Context) {
        // Update the UI if necessary
    }
}

class EditableImage: ObservableObject {

    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }

}

#Preview {
    ImageEditorViewController(image: UIImage(systemName: "star")!)
}
