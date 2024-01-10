//
//  SwiftUIView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//
import SwiftUI

struct SwiftUIView: View {
    @State private var offset = CGSize.zero
    @State private var currentPage = 0
    let totalPages = 3

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        PageView(index: index) // Replace with your page content
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(x: -CGFloat(currentPage) * geometry.size.width + offset.width)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { gesture in
                            let swipeThreshold: CGFloat = 50.0
                            if abs(gesture.translation.width) > swipeThreshold {
                                let swipeLeft = gesture.translation.width < 0
                                self.updatePage(swipeLeft: swipeLeft, width: geometry.size.width)
                            }
                            self.offset = .zero
                        }
                )
                Spacer()
                PageIndicator(currentPage: $currentPage, pageCount: totalPages)
            }
        }
    }
    
    private func updatePage(swipeLeft: Bool, width: CGFloat) {
        if swipeLeft {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        } else {
            if currentPage > 0 {
                currentPage -= 1
            }
        }
    }
}

struct PageView: View {
    let index: Int

    var body: some View {
        // Your page content here
        Text("Page \(index)")
    }
}

struct PageIndicator: View {
    @Binding var currentPage: Int
    let pageCount: Int

    var body: some View {
        HStack {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue : Color.gray)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
