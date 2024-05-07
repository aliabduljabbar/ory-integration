//
//  LoginModel.swift
//  ory-integration
//
//  Created by Ali Abdul Jabbar on 05/05/2024.
//

import Foundation

public struct FlowResponse: Decodable, Identifiable {
    public let id: String
    public let type: String
    public let expiresAt: String?
    public let issuedAt: String
    public let requestUrl: String
    public let organizationId: String?
    public let state: String
    public let uiComponenets: UI
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case expiresAt = "expires_at"
        case issuedAt = "issued_at"
        case requestUrl = "request_url"
        case organizationId = "organization_id"
        case state
        case uiComponenets = "ui"
    }
}

public struct UI: Decodable {
    public let action: String
    public let method: String
    public let nodes: [FormNode]
    public let messages: [NodeMessage]
    
    enum CodingKeys: CodingKey {
        case action
        case method
        case nodes
        case messages
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        action = try container.decode(String.self, forKey: .action)
        method = try container.decode(String.self, forKey: .method)
        nodes = (try container.decode([FormNode].self, forKey: .nodes)).filter { $0.attributes.type != .hidden  }
        messages = (try? container.decode([NodeMessage].self, forKey: .messages)) ?? []
    }
}

public enum AttributeType: String, Codable, Hashable, Equatable {
    case hidden
    case text
    case email
    case password
    case submit
}

public struct FormNode: Decodable, Hashable, Equatable {
    public var title: String {
        (meta?.label.text ?? attributes.name).capitalized
    }
//    public let type: String
//    public let group: String
    public let attributes: NodeAttributes
    public let messages: [NodeMessage]
    public let meta: NodeMetaData?
    
    enum CodingKeys: CodingKey {
        case attributes
        case messages
        case meta
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        attributes = try container.decode(NodeAttributes.self, forKey: .attributes)
        messages = (try? container.decode([NodeMessage].self, forKey: .messages)) ?? []
        meta = try? container.decodeIfPresent(NodeMetaData.self, forKey: .meta)
    }
    
    public init(attributes: NodeAttributes, meta: NodeMetaData, messages: [NodeMessage] = []) {
        self.attributes = attributes
        self.meta = meta
        self.messages = messages
    }
}

public struct NodeMessage: Decodable, Identifiable, Hashable, Equatable {
    public let id: Int
    public let text: String
    public let type: String
    
    public var isError: Bool {
        type == "error"
    }
//    public let context: Context?
    
    public init(id: Int, text: String, type: String) {
        self.id = id
        self.text = text
        self.type = type
    }
}

public struct NodeAttributes: Decodable, Hashable, Equatable {
    public let name: String
    public let type: AttributeType
    public let value: String?
    public let required: Bool
//    public let disabled: Bool?
//    public let node_type: String?
//    public let autocomplete: String?
    
    enum CodingKeys: CodingKey {
        case name
        case type
        case required
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(AttributeType.self, forKey: .type)
        required = (try? container.decodeIfPresent(Bool.self, forKey: .required)) ?? false
        value = try? container.decodeIfPresent(String.self, forKey: .value)
    }
    
    public init(name: String, type: AttributeType, required: Bool, value: String? = nil) {
        self.name = name
        self.type = type
        self.required = required
        self.value = value
    }
}

public struct NodeMetaData: Decodable, Hashable, Equatable {
    public let label: NodeLabel
    
    public init(label: NodeLabel) {
        self.label = label
    }
}

public struct NodeLabel: Decodable, Identifiable, Hashable, Equatable {
    public let id: Int
    public let text: String
//    public let type: String
//    public let context: Context?
    
    public init(id: Int, text: String) {
        self.id = id
        self.text = text
    }
}

//public struct Context: Decodable {
//    public let title: String
//}
