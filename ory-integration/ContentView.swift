//
//  ContentView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import SwiftUI
import OryCore

struct ContentView: View {
    
    @StateObject var appState: AppStateManager
    
    private let splashTransition: AnyTransition = .asymmetric(insertion: .opacity, removal: .identity)
    private let mainTransition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .opacity)
    
    var body: some View {
        Group {
            switch appState.scene {
            case .splash:
                SplashView()
                    .transition(splashTransition)
            case .auth:
                AuthNavigationView()
            case .main:
                MainNavigationView()
                    .transition(mainTransition)
            }
        }
        .animation(.default, value: appState.scene)
        .environmentObject(appState)
    }
}

#Preview {
    ContentView(appState: AppStateManager())
}
