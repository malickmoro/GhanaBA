//
//  GhanaBAApp.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/9/24.
//

import SwiftUI
@available(iOS 16.0, *)

@main
struct GhanaBAApp: App {
    var appVM = AppViewModel()  // Instance of your navigation controller

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVM)
        }
    }
}