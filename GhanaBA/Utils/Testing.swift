//
//  Testing.swift
//  GhanaBA
//
//  Created by Malick Moro-Samah on 1/12/24.
//

import SwiftUI

struct Testing: View {
    let blue = Color(red: 0/255, green: 51/255, blue: 171/255)

    var body: some View {
        Rectangle()
            .frame(width: 350,height: 500)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
            .overlay{
                VStack (spacing: 20){
                    
                    VStack {
                        Image("guy")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                        
                        
                        Text("The boy")
                            .font(.title2)
                            .foregroundStyle(blue)
                        
                    }
                    
                    
                    Rectangle()
                        .frame(width: 300,height: 100)
                        .foregroundStyle(.gray.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay {
                            VStack (spacing: 0){
                                Text("AUTHORIZATION CODE")
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: 300, height: 50)
                                    .background(blue.opacity(0.75))
                                    .foregroundStyle(.white)
                                
                                Divider()
                                
                                Text("The boy")
                                    .font(.system(size: 20, weight: .medium))
                                    .frame(width: 300, height: 50)
                                    .background(.gray.opacity(0.001))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                        }
                    
                    Button {
                        
                        
                        
                    } label: {
                        Text("Done")
                            .font(.system(size: 20, weight: .semibold))
                            .frame(width: 120, height: 60)
                            .foregroundStyle(.white)
                            .background(blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    }
                }
                .padding()
            }
    }
}

#Preview {
    Testing()
}
