//
//  ContentViewModel.swift
//  OCR-Demo-SwiftUI
//
//  Created by Tuğcan ÖNBAŞ on 31.03.2023.
//

import SwiftUI

@available(iOS 16.0, *)

class OCRViewModel: ObservableObject {
    @Published private(set) var image: Image?
    @Published private(set) var results: [OCRResult] = []
    
    
    func clearImage() {
        results = []
        image = nil
    }
    
    func selectItem(_ item: UIImage?) {
        Task {
            let data = item?.pngData()
            if let uiImage = UIImage(data: data!) {
                
                let ocrController = OCRManager(image: uiImage)
                
                DispatchQueue.main.async {
                    self.results = ocrController.execute()
                    
                    for result in self.results {
                        print("ID: \(result.id), Text: \(result.text)")
                    }
                    
                    self.extractSpecificText()
                    
                    self.image = Image(uiImage: uiImage)
                    
                }
                return
            }
        }
    }
    
    func extractSpecificText() {
        for result in results {
            // Check if the text contains the pattern
            // The pattern looks for three alphabets, followed by nine alphanumeric characters,
            // and then captures the next character before '<<'
            if let range = result.text.range(of: #"[A-Z]{3}([A-Z0-9]{9}).(?=<{2})"#, options: .regularExpression) {
                // Extract the substring
                let extractedText = String(result.text[range])

                // Extract the specific part (the nine alphanumeric characters and the character before '<<')
                let specificValueStartIndex = result.text.index(range.lowerBound, offsetBy: 3)
                let specificValueEndIndex = result.text.index(range.upperBound, offsetBy: -1)
                let specificValue = String(result.text[specificValueStartIndex..<specificValueEndIndex])

                print("Extracted Text: \(extractedText)")
                print("Specific Value: \(specificValue)")

                // Store and print the desired part
                // ...

                // Break the loop if you only need the first occurrence
                break
            }
        }
    }

}
