//
//  FormView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import SwiftUI
import OryCore

struct FormView: View {
    
    var type: FormViewType
    var nodes: [FormNode]
    @Binding var data: [FormNode: String]
    var showErros: Bool
    var isLoading: Bool
    var action: () -> Void
    
    var body: some View {
        ForEach(nodes, id: \.self) { item in
            VStack {
                switch item.attributes.type {
                case .text:
                    TextField(
                        item.title,
                        text: Binding {
                            data[item] ?? ""
                        } set: { newVal in
                            data[item] = newVal
                        }
                    )
                    .keyboardType(.default)
                    .frame(minHeight: 56)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(.systemGray6))
                    }
                case .email:
                    TextField(
                        item.title,
                        text: Binding {
                            data[item] ?? ""
                        } set: { newVal in
                            data[item] = newVal
                        }
                    )
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .frame(minHeight: 56)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(.systemGray6))
                    }
                case .password:
                    SecureField(
                        item.title,
                        text: Binding {
                            data[item] ?? ""
                        } set: { newVal in
                            data[item] = newVal
                        }
                    )
                    .keyboardType(.default)
                    .textContentType(type == .signup ? .newPassword : .password)
                    .frame(minHeight: 56)
                    .padding(.horizontal, 24)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundColor(Color(.systemGray6))
                    }
                case .submit:
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(height: 56)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 28)
                                    .foregroundColor(.accentColor)
                            }
                    } else {
                        Button {
                            action()
                        } label: {
                            Text(item.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .padding(.horizontal, 24)
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 28)
                                        .foregroundColor(.accentColor)
                                }
                        }
                        .buttonStyle(.plain)
                    }
                default:
                    EmptyView()
                }
                if showErros {
                    if let message = item.messages.first, message.isError {
                       HStack {
                           Text(message.text)
                               .font(.system(size: 13, weight: .light))
                               .foregroundColor(.red)
                           Spacer()
                       }
                       .padding(.horizontal)
                       .padding(.bottom, 4)
                   } else if item.attributes.required && (data[item] ?? "").isEmpty {
                        HStack {
                            Spacer()
                            Text("\(item.title) is required")
                                .font(.system(size: 13, weight: .light))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                    }
                }
            }
        }
    }
}

#Preview {
    FormView(type: .login, nodes: [
        FormNode(attributes: NodeAttributes(name: "email", type: .text, required: true, value: "bb@test.com"), meta: NodeMetaData(label: NodeLabel(id: 1, text: "E-mail"))),
        FormNode(attributes: NodeAttributes(name: "password", type: .password, required: true, value: "=fW13r~6IV7P"), meta: NodeMetaData(label: NodeLabel(id: 2, text: "Password"))),
        FormNode(attributes: NodeAttributes(name: "action", type: .submit, required: false), meta: NodeMetaData(label: NodeLabel(id: 2, text: "Login"))),
    ], data: .constant([:]), showErros: false, isLoading: true) {
        
    }
}
