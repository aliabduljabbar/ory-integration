//
//  MainNavigationView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import SwiftUI

struct MainNavigationView: View {
    
    @State private var selection: MainTabScreen? = .home
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(MainTabScreen.allCases) { screen in
                NavigationStack {
                    screen.destination
                }
                .tag(screen as MainTabScreen?)
                .tabItem { screen.label }
            }
        }
    }
}

#Preview {
    MainNavigationView()
}
