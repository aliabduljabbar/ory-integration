//
//  SplashView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import SwiftUI
import OryCore

struct SplashView: View {
    
    @EnvironmentObject private var appState: AppStateManager
    
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "ladybug.fill")
                .imageScale(.large)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 100))
                .padding()
                .background {
                    Circle()
                        .foregroundColor(.white)
                }
            Spacer()
        }
        .task {
            if AuthenticationManager.isLoggedIn {
                appState.scene = .main
            } else {
                appState.scene = .auth
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppStateManager())
}
