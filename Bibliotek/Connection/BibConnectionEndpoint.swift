//
//  BibConnectionEndpoint.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection.Endpoint: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension Connection.Endpoint: Codable {
    enum CodingKeys: String, CodingKey {
        case host, port, database, name, catalog
    }

    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let host = try container.decode(String.self, forKey: .host)
        let port = try container.decode(Int.self, forKey: .port)
        let database = try container.decode(String.self, forKey: .database)
        let endpoint = Connection.MutableEndpoint(host: host, port: port, database: database)
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
