//
//  BibConnectionEndpoint.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibConnectionEndpoint: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension BibConnectionEndpoint: Codable {
    enum CodingKeys: String, CodingKey {
        case host, port, database, name, catalog
    }

    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let host = try container.decode(String.self, forKey: .host)
        let port = try container.decode(Int.self, forKey: .port)
        let database = try container.decode(String.self, forKey: .database)
        let endpoint = BibMutableConnectionEndpoint(host: host, port: port, database: database)
        endpoint.name = try container.decode(String?.self, forKey: .name)
        endpoint.catalog = try container.decode(String?.self, forKey: .catalog)
        self.init(endpoint)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(host, forKey: .host)
        try container.encode(port, forKey: .port)
        try container.encode(database, forKey: .database)
        try container.encode(name, forKey: .name)
        try container.encode(catalog, forKey: .catalog)
    }
}

// MARK: - Swift Native

extension Connection {
    public struct Endpoint {
        private var endpoint: BibMutableConnectionEndpoint

        internal init(endpoint: BibConnectionEndpoint) {
            self.endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
        }

        public init(host: String = "localhost", port: Int = 210, database: String = "Default") {
            endpoint = BibMutableConnectionEndpoint(host: host, port: port, database: database)
        }
    }
}

extension Connection.Endpoint {
    public var host: String {
        get { return endpoint.host }
        set {
            if !isKnownUniquelyReferenced(&endpoint) {
                endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
            }
            endpoint.host = newValue
        }
    }

    public var port: Int {
        get { return endpoint.port }
        set {
            if !isKnownUniquelyReferenced(&endpoint) {
                endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
            }
            endpoint.port = newValue
        }
    }

    public var database: String {
        get { return endpoint.database }
        set {
            if !isKnownUniquelyReferenced(&endpoint) {
                endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
            }
            endpoint.database = newValue
        }
    }

    public var name: String? {
        get { return endpoint.name }
        set {
            if !isKnownUniquelyReferenced(&endpoint) {
                endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
            }
            endpoint.name = newValue
        }
    }

    public var catalog: String? {
        get { return endpoint.catalog }
        set {
            if !isKnownUniquelyReferenced(&endpoint) {
                endpoint = endpoint.mutableCopy() as! BibMutableConnectionEndpoint
            }
            endpoint.catalog = newValue
        }
    }
}

extension Connection.Endpoint: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return endpoint.playgroundDescription
    }
}

extension Connection.Endpoint: CustomStringConvertible {
    public var description: String {
        return endpoint.description
    }
}

extension Connection.Endpoint: Codable {
    public init(from decoder: Decoder) throws {
        endpoint = try BibMutableConnectionEndpoint(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try endpoint.encode(to: encoder)
    }
}

// MARK: - Objective-C Bridging

extension Connection.Endpoint: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> BibConnectionEndpoint {
        return endpoint.copy() as! BibConnectionEndpoint
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibConnectionEndpoint, result: inout Connection.Endpoint?) {
        result = Connection.Endpoint(endpoint: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibConnectionEndpoint, result: inout Connection.Endpoint?) -> Bool {
        result = Connection.Endpoint(endpoint: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibConnectionEndpoint?) -> Connection.Endpoint {
        return source.map(Connection.Endpoint.init(endpoint:)) ?? Connection.Endpoint()
    }
}
