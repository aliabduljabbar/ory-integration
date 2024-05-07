//
//  AuthResponse.swift
//
//
//  Created by Ali Abdul Jabbar on 07/05/2024.
//

import Foundation

public enum AuthResponse: Decodable {
    case success(SessionResponse)
    case failure(FlowResponse)
}
