//
//  MainTabScreen.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import Foundation
import SwiftUI

enum MainTabScreen: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case profile
    
    var id: MainTabScreen { self }
}

extension MainTabScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house")
        case .profile:
            Label("Profile", systemImage: "person.crop.circle")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeView()
        case .profile:
            ProfileView()
        }
    }
}
