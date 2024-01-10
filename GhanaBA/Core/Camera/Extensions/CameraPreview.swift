//
//  CameraPreview.swift
//  SwiftCamera
//
//  Created by Rolando Rodriguez on 10/17/20.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.backgroundColor = .black
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.session = session
        if #available(iOS 16.0, *) {
            // Create a rotation transform for 90 degrees (π/2 radians)
            let rotationTransform = CGAffineTransform(rotationAngle: 0)
            view.videoPreviewLayer.setAffineTransform(rotationTransform)
        } else {
            // Fallback on earlier versions
            view.videoPreviewLayer.connection?.videoOrientation = .portrait
        }
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
}

struct CameraPreview_Previews: PreviewProvider {
    static var previews: some View {
        CameraPreview(session: AVCaptureSession())
            .frame(height: 300)
    }
}
