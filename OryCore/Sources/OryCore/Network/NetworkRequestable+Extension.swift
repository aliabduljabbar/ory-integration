//
//  NetworkRequestable+Extension.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation

public extension NetworkRequestable {
    
    func saveAuthorizationToken(_ token: String) {
        AuthenticationManager.saveAuthToken(token)
    }
    func getAuthorizationToken() -> String? {
        authenticationToken ?? AuthenticationManager.getAuthToken()
    }
}
