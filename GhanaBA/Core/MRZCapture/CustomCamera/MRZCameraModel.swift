//
//  MRZCameraModel.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/12/24.
//

import SwiftUI
import Combine
import AVFoundation

@available(iOS 16.0, *)

final class MRZCameraModel: ObservableObject, MRZCameraServiceDelegate {
    
    lazy var service: MRZCameraService = {
           let service = MRZCameraService(viewModel: self)
           return service
       }()
    var appVM: AppViewModel?
    var idVM: idCaptureViewModel?
    var ocr: OCRViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    var onEditingDone: ((UIImage) -> Void)?
    var onEditingCancelled: (() -> Void)?
    
    @Published var photo: Photo!
    @Published var ocrViewModel = OCRViewModel()
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    @Published var imageToEdit: UIImage?
    @Published var capturedPhoto = false
    @Published var shouldRestartSession = false  // Track if the camera session
    @Published var patternFound = false
    @Published var extractedText = ""


    
    var alertError: AlertError!
    var session: AVCaptureSession?
    private var subscriptions = Set<AnyCancellable>()
    
    init(idVM: idCaptureViewModel? = nil, appVM: AppViewModel? = nil) {
        self.idVM = idVM
        self.appVM = appVM
        self.session = service.session
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func cameraService(_ service: MRZCameraService, didCapturePhoto photo: UIImage) {
        // Handle the captured photo, e.g., update the UI or process the photo
        DispatchQueue.main.async {
            self.imageToEdit = photo
            // Any other UI updates or processing
        }
    }
    
    
    func stopcamera(){
        service.stop()
    }
    
    func startCam(){
        service.start()
    }
    
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
    
    func photoCaptureProcessor(_ processor: PhotosCaptureProcessor, didFinishProcessingPhoto image: UIImage) {
        
    }
    
    func cameraService(_ service: MRZCameraService, didRecognizeText text: [String]) {
        DispatchQueue.main.async {
            let (patternFound, extractedMRZ) = service.extractSpecificText(from: text)
            if patternFound, let mrz = extractedMRZ {
                self.patternFound = true
                print("MRZ Found: \(mrz)")
             } else {
                print("No MRZ found.")
            }
        }
    }
    
    
    func focus(at point: CGPoint) {
        // Assuming you have an instance of MRZCameraService
        service.focus(at: point)
    }
    
    func photoCaptureProcessorDidCancel(_ processor: PhotosCaptureProcessor) {
        // Handle cancellation
    }
    
    func cameraService(_ service: CameraService, didCapturePhoto photo: UIImage) {
        // Handle the captured photo, perhaps by presenting the editor
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageToEdit = photo
        }
    }
    
    func cameraServiceDidFail(_ service: MRZCameraService, error: Error) {
        
    }
    
    func capturePhoto() {
        service.capturePhoto { [weak self] photo in
            
            if let self = self, let photoData = photo?.originalData, let image = UIImage(data: photoData) {
                // Pass the UIImage to OCRViewModel for processing
                DispatchQueue.main.async {
                    self.ocrViewModel.selectItem(image)
                }
            } else {
                print("No photo data captured.")
            }
        }
    }
}
@available(iOS 16.0, *)

extension MRZCameraModel: Resettable {
    func reset() {
        // Resetting UIImage and Boolean properties to their default states
        showAlertError = false
        isFlashOn = false
        willCapturePhoto = false
        imageToEdit = nil  // UIImage properties are optional, so set to nil
        capturedPhoto = false
        shouldRestartSession = false
        patternFound = false
        extractedText = ""

        // Reset or clear any complex properties if needed
        alertError = nil  // Assuming nil is the initial state
        photo = nil  // Assuming nil is the initial state

        // Consider stopping or restarting the camera session as appropriate
        service.stop()  // This is hypothetical, adjust based on your actual camera service

        // Clear any active subscriptions if necessary
        cancellables.removeAll()
        subscriptions.removeAll()
    }
}

