//
//  NetworkRequest.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation
import OSLog

public class NetworkRequestConfiguration {
    public static var urlSession: URLSession?
}

public struct NetworkRequest {
    
    var baseUrl: String
    var path: String
    var method: String
    var body: [String: Any]?
    var bodyRaw: String? = nil
    var encoding: EncodingMethod
    var parameters: [String: String]?
    var headers: [String: String]
    var authenticated: Bool
    var authenticationToken: String?
    
    private let log = Logger(subsystem: "Ory-Integration", category: "Network Layer")
    
    /**
     Executes the network request asynchronously and returns the response.
     
     - Returns: A response of type `ResponseType` wrapped in an asynchronous task.
     - Throws:
     - `invalidURL` if the URL for the network request is invalid or malformed.
     - `invalidBody` if there is an issue with the request body. It wraps an underlying error that provides more specific information about the error.
     - `noData` if the response from the server does not contain any data.
     - `notLoggedIn` if the user is not logged in and the requested operation requires authentication.
     - `unauthenticated` if the server responds with an authentication failure.
     - `decodingError` if there is an issue decoding the response data into the expected response type. It wraps an underlying error that provides more specific information about the decoding error.
     - `serverError` if the server returns an error response. It wraps an underlying error that provides more specific information about the server error.
     - `noConnection`
     */
    public func execute() async throws -> (Data, URLResponse) {
        try await executeNetworkCall()
    }
}

extension NetworkRequest {
    private func executeNetworkCall() async throws -> (Data, URLResponse) {
                guard isInternetAvailable() else {
                    throw NetworkError.noConnection
                }
        if authenticated && authenticationToken == nil {
            log.error("notLoggedIn")
            throw NetworkError.notLoggedIn
        }
        guard let url = createURL() else {
            log.error("invalidURL")
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let body {
            do {
                request.httpBody = try getBodyData(body: body)
            } catch {
                log.error("invalidBody, \(error.localizedDescription)")
                throw NetworkError.invalidBody
            }
        } else if let bodyRaw {
            request.httpBody = bodyRaw.data(using: .utf8)
        }
        if let authenticationToken, authenticated {
            request.setValue("Bearer \(authenticationToken)", forHTTPHeaderField: "Authorization")
        }
        request.setValue(encoding.rawValue, forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        
        let urlSession = NetworkRequestConfiguration.urlSession ?? URLSession.shared
        let (data, response) = try await urlSession.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            log.error("unauthenticated")
            throw NetworkError.unauthenticated
        }
        return (data, response)
    }
}

// MARK: - Private functions
extension NetworkRequest {
    private func createURL() -> URL? {
        guard var components = URLComponents(string: baseUrl + path) else {
            return nil
        }
        if let queryParams = parameters, !queryParams.isEmpty {
            components.queryItems = queryParams.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        return components.url
    }
    private func isInternetAvailable() -> Bool {
        NetworkReachability.isConnectedToNetwork()
    }
    
    private func getBodyData(body: [String: Any]) throws -> Data {
        switch encoding {
        case .json:
                return try JSONSerialization.data(withJSONObject: body, options: [])
        case .form:
            let formString = body.map { (key, value) in
                return "\(key)=\(value)"
            }.joined(separator: "&")
            if let data = formString.data(using: .utf8) {
                return data
            } else {
                throw NetworkError.invalidBody
            }
        }
    }
}


