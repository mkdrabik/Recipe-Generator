//
//  LoadingView.swift
//  Foody
//
//  Created by Mason Drabik on 4/17/24.
//

import SwiftUI
import UIKit

struct LoadingView: View {
    @State private var isLoading: Bool = true
    @State private var rotation = 0

    var body: some View {
        ZStack{
            if isLoading {
                Color(Color.cb)
                    .ignoresSafeArea()
                VStack{
                    Image("logo")
                        .resizable()
                        .frame(width: 450, height: 470)
                        .padding(.horizontal, 40)
                        .padding(.top, 40)
                    withAnimation {
                        Image(systemName: "fork.knife.circle")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(Color.white)
                            .frame(width: 80, height: 80)
                            .animation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                $0.rotationEffect(.degrees(Double(rotation)))
                            }.padding(.top, -90)

                    }
                    
                    Spacer()
                }
            }
            else {
                ContentView()
            }
        }.onAppear {
            rotation = 360
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isLoading = false
            }
            
        }
    }
}


#Preview {
    LoadingView()
}
