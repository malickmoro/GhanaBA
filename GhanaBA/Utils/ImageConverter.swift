//
//  ImageConverter.swift
//  VR
//
//  Created by Young Prodigy on 12/31/23.
//

import Foundation
import CoreGraphics
import UIKit


extension Data {
    var pngFromJPEG: Data? {
        guard
            let dataProvider = CGDataProvider(data: self as CFData),
            let cgImage = CGImage(jpegDataProviderSource: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent),
            let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.png" as CFString, 1, nil)
        else { return nil }
        CGImageDestinationAddImage(destination, cgImage,nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
    func jpegFromPNG(compressionQuality: CGFloat = 1) -> Data? {
        guard
            let dataProvider = CGDataProvider(data: self as CFData),
            let cgImage = CGImage(pngDataProviderSource: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent),
            let mutableData = CFDataCreateMutable(nil, 0),
            let destination = CGImageDestinationCreateWithData(mutableData, "public.jpeg" as CFString, 1, nil)
        else { return nil }
        CGImageDestinationAddImage(destination, cgImage,[kCGImageDestinationLossyCompressionQuality: compressionQuality] as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
