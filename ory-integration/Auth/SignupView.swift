//
//  SignupView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import SwiftUI
import OryCore

struct SignupView: View {
    
    @EnvironmentObject private var appState: AppStateManager
    
    @State var errorMessage: String?
    @State var isDataLoading: Bool = false
    @State var isActionLoading: Bool = false
    
    @State var flowResponse: FlowResponse?
    var nodes: [FormNode] {
        flowResponse?.uiComponenets.nodes ?? []
    }
    @State var data: [FormNode: String] = [:]
    @State var showErros: Bool = false
    
    var body: some View {
        ScrollView {
            if isDataLoading {
                ProgressView()
            }
            LazyVStack(spacing: 12) {
                FormView(type: .signup, nodes: nodes, data: $data, showErros: showErros, isLoading: isActionLoading) {
                    signupAction()
                }
                .animation(.default, value: data)
                .animation(.default, value: showErros)
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            if let errorMessage, !errorMessage.isEmpty {
                BottomErrorView(errorMessage: errorMessage)
                    .padding()
            }
        }
//        .onChange(of: data) { newVal in
//            if showErros {
//                showErros = false
//            }
//        }
        .navigationTitle("Signup")
        .task {
            await MainActor.run {
                isDataLoading = true
            }
            await loadData()
            await MainActor.run {
                isDataLoading = false
            }
        }
        .refreshable {
            await loadData()
        }
    }
    
    func populateData(response: FlowResponse) {
        flowResponse = response
        response.uiComponenets.nodes.forEach { item in
            if item.attributes.type == .text || item.attributes.type == .password || item.attributes.type == .email {
                if data[item] == nil {
                    data[item] = item.attributes.value ?? ""
                }
            }
        }
        errorMessage = response.uiComponenets.messages.map { $0.text }.joined(separator: "\n")
        showErros = !response.uiComponenets.nodes.flatMap { node in
            node.messages.map { $0.text }
        }.isEmpty
    }
    
    func loadData() async {
        do {
            let response = try await RegisterFlowRequest().execute()
            await MainActor.run {
                populateData(response: response)
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func signupAction() {
        errorMessage = nil
        guard let flowResponse else {
            return
        }
        let isValid = data.reduce(true) { partialResult, item in
            if item.key.attributes.required {
                return partialResult && !item.value.isEmpty
            }
            return partialResult
        }
        showErros = !isValid
        guard isValid else {
            return
        }
        Task {
            await MainActor.run {
                isActionLoading = true
            }
            do {
                let result = try await RegisterRequest(flow: flowResponse, data: data).execute()
                await MainActor.run {
                    isActionLoading = false
                }
                switch result {
                case .success(_):
                    await MainActor.run {
                        appState.scene = .main
                    }
                case .failure(let response):
                    await MainActor.run {
                        populateData(response: response)
                    }
                }
            } catch {
                print("signup request error", error)
                await MainActor.run {
                    isActionLoading = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignupView()
    }
    .environmentObject(AppStateManager())
}
