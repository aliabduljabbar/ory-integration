//
//  NetworkEnvironmentManager.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation

public enum NetworkEnvironmentError: Error {
    case baseURLNotFound
    case apiKeyNotFound
}

public enum NetworkEnvironmentKey: String {
    case baseURL = "BaseURL"
    case apiKey = "Api Key"
}

public struct NetworkEnvironmentManager {
    static var baseURL: String {
        guard let value = Bundle.main.infoDictionary?[NetworkEnvironmentKey.baseURL.rawValue] as? String else {
            let error = NetworkEnvironmentError.baseURLNotFound
            fatalError(error.localizedDescription)
        }
        return value
    }
    
    static var apiKey: String {
        guard let value = Bundle.main.infoDictionary?[NetworkEnvironmentKey.apiKey.rawValue] as? String else {
            let error = NetworkEnvironmentError.apiKeyNotFound
            fatalError(error.localizedDescription)
        }
        return value
    }
}
