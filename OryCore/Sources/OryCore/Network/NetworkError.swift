//
//  NetworkError.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidBody
    case noData
    case notLoggedIn
    case unauthenticated
    case decodingError(_ error: Error?)
    case apiError(_ message: String?)
    case serverError
    case noConnection
}
