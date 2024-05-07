//
//  RegisterRequest.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import Foundation

public struct RegisterRequest: NetworkRequestable {
    public typealias ResponseType = AuthResponse
    
    public var path: String
    public var parameters: [String : String]?
    public var body: [String : Any]?
    public var headers: [String : String] = [:]
    
    public var authenticated: Bool = false
    public var method: HttpMethod = .post
    
    public init(flow: FlowResponse, data: [FormNode: String]) {
        path = "self-service/registration?flow=\(flow.id)"
        var dictionary: [String: Any] = [
            "method": "password"
        ]
        for item in data {
            dictionary[item.key.attributes.name] = item.value
        }
        body = dictionary
    }
    
    public func mapResponse(data: Data, response: URLResponse) async throws -> AuthResponse {
        let decoder = JSONDecoder()
        if let success = try? decoder.decode(SessionResponse.self, from: data) {
            return .success(success)
        } else if let failure = try? decoder.decode(FlowResponse.self, from: data) {
            return .failure(failure)
        } else {
            throw NetworkError.apiError("Something went wrong")
        }
    }
    
    public func handleResponse(model: AuthResponse) async throws {
        if case .success(let response) = model {
            AuthenticationManager.saveAuthToken(response.sessionToken)
        }
    }
}
