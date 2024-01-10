import SwiftUI
import Combine
import AVFoundation

final class CameraModel: ObservableObject, CameraServiceDelegate {
    let service = CameraService()
    var appVM: AppViewModel?
    var idVM: idCaptureViewModel?
    private var cancellables = Set<AnyCancellable>()

    var onEditingDone: ((UIImage) -> Void)?
    var onEditingCancelled: (() -> Void)?
    
    @Published var photo: Photo!
    @Published var editedImage: UIImage?
    @Published var showAlertError = false
    @Published var isFlashOn = false
    @Published var willCapturePhoto = false
    @Published var imageToEdit: UIImage?
    @Published var capturedPhoto = false
    @Published var isEditing = false  // Track if the editor is presented
    @Published var shouldRestartSession = false  // Track if the camera session

    
    var alertError: AlertError!
    var session: AVCaptureSession
    private var subscriptions = Set<AnyCancellable>()
    
    init(idVM: idCaptureViewModel? = nil, appVM: AppViewModel? = nil) {
        self.session = service.session
        self.idVM = idVM
        self.appVM = appVM
        service.delegate = self  // Set the delegate Set the delegate
        
        
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
    
    func capturePhoto() {
        service.capturePhoto()

    }
    
    func stopcamera(){
        service.stop()
    }
    
    func startCam(){
        service.start()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
    
    func photoCaptureProcessor(_ processor: PhotoCaptureProcessor, didFinishProcessingPhoto image: UIImage) {

    }

    func photoCaptureProcessorDidCancel(_ processor: PhotoCaptureProcessor) {
        // Handle cancellation
    }
    
    func cameraService(_ service: CameraService, didCapturePhoto photo: UIImage) {
        // Handle the captured photo, perhaps by presenting the editor

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.imageToEdit = photo
            self.isEditing = true  // Set to true to present the editor
        }
    }

    func cameraServiceDidFail(_ service: CameraService, error: Error) {
        // Handle the error, perhaps by showing an alert to the user
    }
    
    func completeEditing(with editedImage: UIImage) {
        self.editedImage = editedImage
        self.isEditing = false  // This will dismiss the image editor
        
        // Add any logic to navigate to ID check view here
        DispatchQueue.main.async { [weak self] in
            self?.appVM?.currentView = .pinMethod  // This will trigger the navigation to ID Check View in ContentView
        }
    }
        
    func cancelEditing() {
        self.isEditing = false  // Dismiss the editor
    }
}

extension CameraModel: Resettable {
    func reset() {
        // Resetting UIImage and Boolean properties to their default states
        editedImage = nil  // UIImage properties are optional, so set to nil
        showAlertError = false
        isFlashOn = false
        willCapturePhoto = false
        imageToEdit = nil  // UIImage properties are optional, so set to nil
        capturedPhoto = false
        isEditing = false
        shouldRestartSession = false

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
