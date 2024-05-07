//
//  NetworkRequestable.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation
import OSLog

/**
 `HttpMethod` defines the supported HTTP methods for network requests.
 */
public enum HttpMethod: String, Codable {
    case get = "GET"
    case post = "POST"
}

public enum EncodingMethod: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}

/**
 `NetworkRequestable` is a protocol that represents a network request.
 
 Conforming types should provide the necessary information for executing the request and specify the expected response type.
 */
public protocol NetworkRequestable {
    associatedtype ResponseType: Decodable
    var baseUrl: String { get }
    var path: String { get set }
    var method: HttpMethod { get }
    var encoding: EncodingMethod { get }
    var body: [String: Any]? { get set }
    var bodyRaw: String? { get }
    var parameters: [String: String]? { get set }
    var headers: [String: String] { get set }
    var authenticated: Bool { get }
    var authenticationToken: String? { get }

    func execute() async throws -> ResponseType
    func mapResponse(data: Data, response: URLResponse) async throws -> ResponseType
    func handleResponse(model: ResponseType) async throws
}

public extension NetworkRequestable {
    /**
     The base URL for the network request.
     
     - Returns: The base URL as a `String`.
     */
    var baseUrl: String {
        NetworkEnvironmentManager.baseURL
    }
    /**
     The HTTP method for the network request.
     
     - Returns: The HTTP method as a `HttpMethod`.
     */
    var method: HttpMethod {
        .post
    }
    
    var encoding: EncodingMethod {
        .json
    }
    /**
     The request body parameters for the network request.
     
     - Returns: The request body parameters as a dictionary of type `[String: Any]` or `nil` if no body parameters are required.
     */
    var body: [String: Any]? {
        nil
    }
    
    var bodyRaw: String? {
        nil
    }
    /**
     The query parameters for the network request.
     
     - Returns: The query parameters as a dictionary of type `[String: String]`.
     */
    var parameters: [String: String] {
        [:]
    }
    /**
     The headers for the network request.
     
     - Returns: The headers as a dictionary of type `[String: String]`.
     */
    var headers: [String: String] {
        [:]
    }
    /**
     Indicates whether the network request requires authentication.
     
     - Returns: A boolean value indicating whether the request requires authentication.
     */
    var authenticated: Bool {
        true
    }
    
    var authenticationToken: String? {
        nil
    }
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
     */
    func execute() async throws -> ResponseType {
        let request = NetworkRequest(
            baseUrl: baseUrl,
            path: path,
            method: method.rawValue,
            body: body,
            bodyRaw: bodyRaw,
            encoding: encoding,
            parameters: parameters,
            headers: headers,
            authenticated: authenticated,
            authenticationToken: getAuthorizationToken()
        )
        do {
            let (data, response) = try await request.execute()
            let result = try await mapResponse(data: data, response: response)
            try await handleResponse(model: result)
            return result
        } catch {
            throw error
        }
    }
    
    func mapResponse(data: Data, response: URLResponse) async throws -> ResponseType {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ResponseType.self, from: data)
        } catch {
            throw error
        }
    }
    
    func handleResponse(model: ResponseType) async throws {
        
    }
    
    private func logAPIRequest(endpoint: String, path: String, parameters: [String: String]?, body: [String: Any]?, headers: [String: String]?, error: Error? = nil) -> String {
        var logMessage = "API Request\n"
        logMessage += "BaseUrl: \(endpoint)\n"
        logMessage += "Path: \(path)\n"
        if let parameters {
            logMessage += "Parameters: \(parameters)\n"
        }
        if let body {
            logMessage += "Body: \(body)\n"
        }
        if let headers {
            logMessage += "Headers: \(headers)\n"
        }
        if let error {
            logMessage += "Error: \(error)\n"
        }
        return logMessage
    }
}
