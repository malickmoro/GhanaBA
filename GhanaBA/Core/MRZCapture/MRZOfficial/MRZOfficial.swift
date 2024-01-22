//
//  MRZOfficial.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/15/24.
//

import SwiftUI

struct MRZOfficial: UIViewControllerRepresentable {
    @Binding var shouldNavigate: Bool
    @ObservedObject var appVM: AppViewModel
    
    
    class Coordinator: NSObject, MRZViewControllerDelegate {
        var parent: MRZOfficial
        
        init(_ parent: MRZOfficial) {
            self.parent = parent
        }
        
        func didExtractDocumentNumber(_ documentNumber: String, _ isFound: Bool) {
            self.parent.appVM.documentID = documentNumber
            self.parent.appVM.mrzGO = isFound

            // Handle the document number
        }
    }
        
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MRZViewController {
        let MRZScanner = MRZViewController()
        MRZScanner.delegate = context.coordinator
        MRZScanner.modalPresentationStyle = .none
        
        MRZScanner.onNavigationRequested = {
            shouldNavigate = true
        }
        
        return MRZScanner
    }
    
    func updateUIViewController(_ uiViewController: MRZViewController, context: Context) {
        // Update the view controller when your SwiftUI state changes, if necessary
    }
}

#Preview {
    MRZOfficial(shouldNavigate: .constant(true), appVM: AppViewModel())
}
