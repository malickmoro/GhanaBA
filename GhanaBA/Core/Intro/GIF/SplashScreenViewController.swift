//
//  SplashScreenViewController.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//
import UIKit
import ImageIO

class SplashScreenViewController: UIViewController {

    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        playGIF()
    }

    private func setupImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300), // Adjust as needed
            imageView.heightAnchor.constraint(equalToConstant: 300) // Adjust as needed
        ])
    }


    private func playGIF() {
        guard let path = Bundle.main.path(forResource: "ghanabaGIF", ofType: "gif"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Error: Could not load GIF")
            return
        }

        var images = [UIImage]()
        var totalDuration: TimeInterval = 2

        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
                   let gifDict = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
                   let frameDuration = gifDict[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
                    totalDuration += frameDuration.doubleValue
                }
            }
        }

        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.startAnimating()
    }
    
}
