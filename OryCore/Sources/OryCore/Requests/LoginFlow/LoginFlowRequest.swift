//
//  LoginRequest.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation

public struct LoginFlowRequest: NetworkRequestable {
    public typealias ResponseType = FlowResponse
    
    public var path: String = "self-service/login/api"
    public var parameters: [String : String]?
    public var body: [String : Any]?
    public var headers: [String : String] = [:]
    
    public var authenticated: Bool = false
    public var method: HttpMethod = .get
    
    public init() { }
}
