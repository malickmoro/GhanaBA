//
//  MRZCaptureView.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/10/24.
//

import SwiftUI

struct MRZCaptureView: View {
    @ObservedObject var appVM: AppViewModel

    var body: some View {
        Text("Hello, World!")
        
        Button {
            appVM.currentView = .chooseMethod
        } label: {
            Text("Cancel")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 150, height: 50, alignment: .center)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius:5)
            
        }
    }
}

#Preview {
    MRZCaptureView(appVM: AppViewModel())
}
