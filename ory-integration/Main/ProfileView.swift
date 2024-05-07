//
//  ProfileView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import SwiftUI
import OryCore

struct ProfileView: View {
    
    @EnvironmentObject private var appState: AppStateManager
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                logoutAction()
            } label: {
                Text("Logout")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .background {
                        Capsule()
                            .foregroundColor(.accentColor)
                    }
            }
            .buttonStyle(.plain)
            .padding()
        }
        .navigationTitle("Profile")
    }
    
    func logoutAction() {
        AuthenticationManager.logout()
        appState.scene = .splash
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AppStateManager())
    }
}
