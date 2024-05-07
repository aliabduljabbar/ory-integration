//
//  BottomErrorView.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import SwiftUI

struct BottomErrorView: View {
    
    var errorMessage: String
    
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.circle.fill")
                .symbolRenderingMode(.multicolor)
                .imageScale(.large)
            Text(errorMessage)
                .font(.system(size: 15, weight: .regular))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(minHeight: 50)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.red.opacity(0.1))
        }
    }
}

#Preview {
    BottomErrorView(errorMessage: "You are awesome awesome awesome awesome awesome awesome awesome awesome awesome awesome awesome")
}
