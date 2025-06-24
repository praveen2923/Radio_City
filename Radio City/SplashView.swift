//
//  SplashView.swift
//  Radio City
//
//  Created by praveen hiremath on 16/06/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity = 0.0

    var body: some View {
        if isActive {
            MainTabbedView()
                
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: "sparkles") // Replace with your logo
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.0)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }

                            // Delay before transitioning
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }

                    Text("Welcome")
                        .font(.headline)
                        .opacity(logoOpacity)
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
