//
//  VideoPlayerView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    var videoName: String // The name of the video file without the file extension
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.view.isUserInteractionEnabled = false // Disable user interactions
        return controller
    }
    

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if let path = Bundle.main.path(forResource: videoName, ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            let player = AVPlayer(url: url)
            uiViewController.player = player
            player.play()
        }
    }
}
