//
//  MRZCameraService.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/12/24.
//

import Foundation
import AVFoundation
import UIKit
import Vision


public struct Photos {
    public var id: String
    public var originalData: Data
    
    public init(id: String = UUID().uuidString, originalData: Data) {
        self.id = id
        self.originalData = originalData
    }
}

@available(iOS 16.0, *)
public class MRZCameraService: NSObject {
    typealias PhotoCaptureSessionID = String
    
    // MARK: Session Management Properties
    public let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var isConfigured = false
    private let sessionQueue = DispatchQueue(label: "OCR session queue")
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private let photoOutput = AVCapturePhotoOutput()
    var isSessionRunning = false
    var setupResult: SessionSetupResult = .success
    weak var delegate: MRZCameraServiceDelegate?
    private var lastFrameProcessTime: Date?
    var viewModel: MRZCameraModel // Ensure that this view model is properly initialized
    
    init(viewModel: MRZCameraModel) {
        self.viewModel = viewModel
        super.init()
        // Initialize your camera here
    }
    
    
    
    
    //    MARK: Observed Properties UI must react to
    
    //    1.
    @Published public var flashMode: AVCaptureDevice.FlashMode = .off
    //    2.
    @Published public var shouldShowAlertView = false
    //    3.
    @Published public var shouldShowSpinner = false
    //    4.
    @Published public var willCapturePhoto = false
    //    5.
    @Published public var isCameraButtonDisabled = true
    //    6.
    @Published public var isCameraUnavailable = true
    //    8.
    @Published public var photo: Photo?
    
    
    //    MARK: Alert properties
    public var alertError: AlertError = AlertError()
    
    
    // MARK: Initialization and Configuration
    public func configure() {
        /*
         Setup the capture session.
         In general, it's not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.
         
         Don't perform these tasks on the main queue because
         AVCaptureSession.startRunning() is a blocking call, which can
         take a long time. Dispatch session setup to the sessionQueue, so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        sessionQueue.async {
            self.configureSession()
        }
    }
    
    private func configureSession() {
        if isConfigured {
            return
        }
        
        session.beginConfiguration()
        
        // Setting up for photo capture
        session.sessionPreset = .photo
        
        // Add video input
        // Add video input.
        
        // Choose the back wide angle camera, if available, otherwise default to any camera.
        guard let videoDevice = selectRearCamera() else {
            print("Could not find the rear camera.")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        do{
            if videoDevice.isFocusModeSupported(.continuousAutoFocus) {
                try videoDevice.lockForConfiguration()
                videoDevice.focusMode = .continuousAutoFocus
                // You can also set focusPointOfInterest if you want to focus on a specific point
                videoDevice.unlockForConfiguration()
            }
            if session.canAddOutput(videoDataOutput) {
                session.addOutput(videoDataOutput)
                videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDataOutputQueue"))
            } else {
                print("Could not add video data output to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
            
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                print("Couldn't add video device input to the session.")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Couldn't create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // Add the photo output
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            photoOutput.isHighResolutionCaptureEnabled = true
        } else {
            print("Could not add photo output to the session")
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
        isConfigured = true
        start()
        print("I have configured")
    }
    
    // MARK: Session Start and Stop
    public func start() {
        sessionQueue.async {
            if !self.session.isRunning && self.isConfigured {
                self.session.startRunning()
                print("I am running")
            }
        }
    }
    
    public func stop() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    // MARK: Capture Photo
    public func capturePhoto(completion: @escaping (Photo?) -> Void) {
        print("I am here to capture")
        if !isConfigured {
            completion(nil)
            return
        }
        
        sessionQueue.async {
            // Ensure the correct orientation
            if let photoOutputConnection = self.photoOutput.connection(with: .video) {
                photoOutputConnection.videoOrientation = .portrait
            }
            
            let photoSettings = AVCapturePhotoSettings()
            // Configure your photo settings as needed
            
            let photoCaptureProcessor = PhotosCaptureProcessor(with: photoSettings) { [weak self] processor in
                print("I DEY HERE SOME")
                if let data = processor.photoData, let image = UIImage(data: data) {
                    self?.delegate?.cameraService(self!, didCapturePhoto: image)
                    print("I got the image")
                }
                completion(processor.photo)
            }
            
            self.photoOutput.capturePhoto(with: photoSettings, delegate: photoCaptureProcessor)
        }
    }
    
    private func selectRearCamera() -> AVCaptureDevice? {
        // Use the DiscoverySession to find the camera device you want.
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInTripleCamera, .builtInDualCamera, .builtInWideAngleCamera]
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .back)
        
        // Use the first available device among the device types.
        return discoverySession.devices.first
    }
    
    
    //        MARK: Checks for user's permisions
    public func checkForPermissions() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. Suspend the session queue to delay session
             setup until the access request has completed.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard let self = self else { return }
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
            
            DispatchQueue.main.async {
                self.alertError = AlertError(title: "Camera Access", message: "SwiftCamera doesn't have access to use your camera, please update your privacy settings.", primaryButtonTitle: "Settings", secondaryButtonTitle: nil, primaryAction: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                              options: [:], completionHandler: nil)
                    
                }, secondaryAction: nil)
                self.shouldShowAlertView = true
                self.isCameraUnavailable = true
                self.isCameraButtonDisabled = true
            }
        }
    }
    
    // MARK: Focus at Point
    public func focus(at focusPoint: CGPoint) {
        sessionQueue.async {
            let device = self.videoDeviceInput.device
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = .continuousAutoExposure
                    device.focusMode = .continuousAutoFocus
                    device.unlockForConfiguration()
                    print("focus is ready")
                }
            } catch {
                print("Focus configuration error: \(error.localizedDescription)")
            }
        }
    }
    
    private func processFrame(_ sampleBuffer: CMSampleBuffer) {
        guard !viewModel.patternFound else {
            return // Stop processing if the pattern has already been found
        }
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        let textRequest = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text recognized")
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }
            print("Recognized Strings: \(recognizedStrings)")
            
            DispatchQueue.main.async {
                let (patternFound, extractedText) = self?.extractSpecificText(from: recognizedStrings) ?? (false, nil)
                if patternFound {
                    self?.viewModel.patternFound = true
                    if let fullString = extractedText {
                        // Ensure index calculation is safe
                        let safeStartIndex = min(fullString.count, 3)
                        let safeEndIndex = max(0, fullString.count - 1)
                        if safeStartIndex < safeEndIndex {
                            let startIndex = fullString.index(fullString.startIndex, offsetBy: safeStartIndex)
                            let endIndex = fullString.index(fullString.startIndex, offsetBy: safeEndIndex)
                            self?.viewModel.extractedText = String(fullString[startIndex..<endIndex])
                            print(self?.viewModel.extractedText ?? "Nothing")
                        }
                        // Trigger haptic feedback
                        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                        impactFeedbackGenerator.prepare()
                        impactFeedbackGenerator.impactOccurred()
                    }
                } else {
                    print("Pattern not found")
                }
            }
        }
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        
        do {
            try imageRequestHandler.perform([textRequest])
        } catch {
            print("Failed to perform text request: \(error.localizedDescription)")
        }
    }
    
    func extractSpecificText(from recognizedStrings: [String]) -> (found: Bool, extractedText: String?) {
        let mrzPattern = "[A-Z0-9<]{30}"  // Adjust this regex for the ID card MRZ format
        var mrzLines = [String]()
        
        for result in recognizedStrings {
            if result.range(of: mrzPattern, options: .regularExpression) != nil {
                mrzLines.append(result)
                if mrzLines.count == 3 {  // Assuming TD1 format with 3 lines
                    let extractedMRZ = mrzLines.joined()
                    return (true, extractedMRZ)
                }
            }
        }
        return (false, nil)
    }
    
    
}



@available(iOS 16.0, *)
extension MRZCameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Process each frame
         processFrame(sampleBuffer)
    }
}

@available(iOS 16.0, *)
protocol MRZCameraServiceDelegate: AnyObject {
    func cameraService(_ service: MRZCameraService, didCapturePhoto photo: UIImage)
    func cameraServiceDidFail(_ service: MRZCameraService, error: Error)
    func cameraService(_ service: MRZCameraService, didRecognizeText text: [String])
}

import AVFoundation
import UIKit

class PhotosCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    private let completionHandler: (PhotosCaptureProcessor) -> Void
    private let photoSettings: AVCapturePhotoSettings
    var photoData: Data?
    var photo: Photo?

    init(with photoSettings: AVCapturePhotoSettings, completionHandler: @escaping (PhotosCaptureProcessor) -> Void) {
        self.photoSettings = photoSettings
        self.completionHandler = completionHandler
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }

        guard let photoData = photo.fileDataRepresentation() else {
            print("No photo data to process.")
            return
        }
        print("Ayekoo")
        self.photoData = photoData
        completionHandler(self)
    }

    // Handle other delegate methods as needed
}
