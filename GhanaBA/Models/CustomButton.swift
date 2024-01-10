//
//  CustomButton.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import Foundation
import SwiftUI

class customButton: ObservableObject {
    var fontColor: Color
    var buttonColor: Color
    
    init(fontColor: Color, buttonColor: Color) {
        self.fontColor = fontColor
        self.buttonColor = buttonColor
    }
}
