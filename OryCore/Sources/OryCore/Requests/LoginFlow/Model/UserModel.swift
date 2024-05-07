//
//  UserModel.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 06/05/2024.
//

import Foundation

public struct SessionResponse: Decodable {
    public let sessionToken: String
    public let session: Session
    public let continueWith: [ContinueWith]
    
    enum CodingKeys: String, CodingKey {
        case sessionToken = "session_token"
        case session
        case identity
        case continueWith = "continue_with"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionToken = try container.decode(String.self, forKey: .sessionToken)
        session = try container.decode(Session.self, forKey: .session)
        continueWith = (try? container.decodeIfPresent([ContinueWith].self, forKey: .continueWith)) ?? []
    }
}

public struct Session: Decodable {
    public let id: String
    public let active: Bool
    public let expires_at: String
    public let authenticated_at: String
    public let authenticator_assurance_level: String
    public let authentication_methods: [AuthenticationMethod]
    public let issued_at: String
    public let identity: Identity
    public let devices: [Device]
}

public struct AuthenticationMethod: Decodable {
    public let method: String
    public let aal: String
    public let completed_at: String
}

public struct Identity: Decodable {
    public let id: String
    public let schema_id: String
    public let schema_url: String
    public let state: String
    public let state_changed_at: String
    public let traits: Traits
    public let verifiable_addresses: [VerifiableAddress]
    public let recovery_addresses: [RecoveryAddress]
    public let metadata_public: String?
    public let created_at: String
    public let updated_at: String
    public let organization_id: String?
}

public struct Traits: Decodable {
    public let email: String
}

public struct VerifiableAddress: Decodable {
    public let id: String
    public let value: String
    public let verified: Bool
    public let via: String
    public let status: String
    public let created_at: String
    public let updated_at: String
}

public struct RecoveryAddress: Decodable {
    public let id: String
    public let value: String
    public let via: String
    public let created_at: String
    public let updated_at: String
}

public struct Device: Decodable {
    public let id: String
    public let ip_address: String
    public let user_agent: String
    public let location: String
}

public struct ContinueWith: Decodable {
    public let action: String
    public let flow: Flow?
    public let ory_session_token: String?
}

public struct Flow: Decodable {
    public let id: String
    public let verifiable_address: String
}
