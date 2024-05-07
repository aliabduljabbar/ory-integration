//
//  OnboardingView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "ladybug.fill")
                .imageScale(.large)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 80))
                .padding()
                .background {
                    Circle()
                        .foregroundColor(.white)
                }
            Spacer()
            VStack {
                NavigationLink {
                    LoginView()
                        .toolbarRole(.editor)
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    Text("Login")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.tertiarySystemBackground))
                        .frame(height: 56)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .foregroundColor(.primary)
                        }
                }
                .buttonStyle(.plain)
                NavigationLink {
                    SignupView()
                        .toolbarRole(.editor)
                        .navigationBarTitleDisplayMode(.large)
                } label: {
                    Text("Sign up")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.tertiarySystemBackground))
                        .frame(height: 56)
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .background {
                            Capsule()
                                .foregroundColor(.primary)
                        }
                }
                .buttonStyle(.plain)
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView()
    }
}
