//
//  VideoCarouselView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
import AVKit

struct VideoCarouselView: View {
    let videos: [String] // Array of video URLs
    var currentIndex: Int

    var body: some View {
        withAnimation(.smooth) {
            VideoPlayerView(videoName: videos[currentIndex])
                .frame(width: 280, height: 204) // Set your desired frame size
        }
            
    }
}


struct j_Previews: PreviewProvider {
    static var previews: some View {
        VideoCarouselView(videos: ["cardFront","cardBack"], currentIndex: 0)
    }
}
