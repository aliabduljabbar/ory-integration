//
//  AppStateManager.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import Foundation

class AppStateManager: ObservableObject {
    
    @Published var scene: AppSceneState = .splash
    
}
