//
//  MRZCameraServiceExtension.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/12/24.
//

import Foundation

//  MARK: CameraService Enums
@available(iOS 16.0, *)
extension MRZCameraService {
    enum LivePhotoMode {
        case on
        case off
    }
    
    enum DepthDataDeliveryMode {
        case on
        case off
    }
    
    enum PortraitEffectsMatteDeliveryMode {
        case on
        case off
    }
    
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    enum CaptureMode: Int {
        case photo = 0
        case movie = 1
    }
}
