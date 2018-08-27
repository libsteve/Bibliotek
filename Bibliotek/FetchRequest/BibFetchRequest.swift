//
//  BibFetchRequest.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/26/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

public struct FetchRequest {
    public typealias Scope = BibFetchRequest.Scope
    public typealias Structure = BibFetchRequest.Structure
    public typealias SearchStrategy = BibFetchRequest.SearchStrategy

    private var request: BibMutableFetchRequest

    internal init(request: BibFetchRequest) {
        self.request = request.mutableCopy() as! BibMutableFetchRequest
    }

    public init(keywords: [String] = [], scope: Scope = .any, structure: Structure = .phrase, strategy: SearchStrategy = .strict) {
        request = BibMutableFetchRequest(keywords: keywords, scope: scope, structure: structure, strategy: strategy)
    }
}

extension FetchRequest {
    public var keywords: [String] {
        get { return request.keywords }
        set {
            if !isKnownUniquelyReferenced(&request) {
                request = request.mutableCopy() as! BibMutableFetchRequest
            }
            request.keywords = newValue
        }
    }

    public var scope: Scope {
        get { return request.scope }
        set {
            if !isKnownUniquelyReferenced(&request) {
                request = request.mutableCopy() as! BibMutableFetchRequest
            }
            request.scope = newValue
        }
    }

    public var strategy: SearchStrategy {
        get { return request.strategy }
        set {
            if !isKnownUniquelyReferenced(&request) {
                request = request.mutableCopy() as! BibMutableFetchRequest
            }
            request.strategy = newValue
        }
    }

    public var structure: Structure {
        get { return request.structure }
        set {
            if !isKnownUniquelyReferenced(&request) {
                request = request.mutableCopy() as! BibMutableFetchRequest
            }
            request.structure = newValue
        }
    }
}

// MARK: - Objective-C Bridging

extension FetchRequest: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> BibFetchRequest {
        return request.copy() as! BibFetchRequest
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFetchRequest, result: inout FetchRequest?) {
        result = FetchRequest(request: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFetchRequest, result: inout FetchRequest?) -> Bool {
        result = FetchRequest(request: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFetchRequest?) -> FetchRequest {
        return source.map(FetchRequest.init(request:)) ?? FetchRequest()
    }
}
