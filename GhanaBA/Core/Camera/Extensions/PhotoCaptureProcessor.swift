import Foundation
import Photos
import UIKit
import AVFoundation

protocol PhotoCaptureProcessorDelegate: AnyObject {
    func photoCaptureProcessor(_ processor: PhotoCaptureProcessor, didFinishProcessingPhoto image: UIImage)
    func photoCaptureProcessorDidCancel(_ processor: PhotoCaptureProcessor, error: Error?)
}

class PhotoCaptureProcessor: NSObject {
    
    lazy var context = CIContext()
    
    private weak var service: CameraService?
    
    private(set) var requestedPhotoSettings: AVCapturePhotoSettings
    
    private let willCapturePhotoAnimation: () -> Void
    
    private let completionHandler: (PhotoCaptureProcessor) -> Void
    
    private let photoProcessingHandler: (Bool) -> Void
    
    weak var delegate: PhotoCaptureProcessorDelegate?

    var photoData: Data?
    private var maxPhotoProcessingTime: CMTime?
        
    init(service: CameraService, with requestedPhotoSettings: AVCapturePhotoSettings, willCapturePhotoAnimation: @escaping () -> Void, photoProcessingHandler: @escaping (Bool) -> Void, completionHandler: @escaping (PhotoCaptureProcessor) -> Void) {
        self.service = service
        self.requestedPhotoSettings = requestedPhotoSettings
        self.willCapturePhotoAnimation = willCapturePhotoAnimation
        self.completionHandler = completionHandler
        self.photoProcessingHandler = photoProcessingHandler
    }
}

extension PhotoCaptureProcessor: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        maxPhotoProcessingTime = resolvedSettings.photoProcessingTimeRange.start + resolvedSettings.photoProcessingTimeRange.duration
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        DispatchQueue.main.async {
            self.willCapturePhotoAnimation()
            
            guard let maxPhotoProcessingTime = self.maxPhotoProcessingTime else { return }
            let oneSecond = CMTime(seconds: 1, preferredTimescale: 1)
            if maxPhotoProcessingTime > oneSecond {
                self.photoProcessingHandler(true)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async {
            self.photoProcessingHandler(false)
            
            if let error = error {
                print("Error capturing photo: \(error)")
                self.delegate?.photoCaptureProcessorDidCancel(self, error: error)
                return
            }
            
            guard let data = photo.fileDataRepresentation() else {
                self.delegate?.photoCaptureProcessorDidCancel(self, error: NSError(domain: "PhotoCaptureProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "No photo data representation"]))
                return
            }
            
            self.photoData = data
            self.handleCapturedImageData(data)
        }
    }
    
    private func handleCapturedImageData(_ data: Data) {
        if let image = UIImage(data: data) {
            delegate?.photoCaptureProcessor(self, didFinishProcessingPhoto: image)
        } else {
            let error = NSError(domain: "PhotoCaptureProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert photo data to UIImage"])
            delegate?.photoCaptureProcessorDidCancel(self, error: error)
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Error capturing photo: \(error)")
                self.delegate?.photoCaptureProcessorDidCancel(self, error: error)
            } else {
                // Ensure completionHandler is called in all code paths
                self.completionHandler(self)
            }
        }
    }
}
