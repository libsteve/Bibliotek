//
//  BibConnectionOptions.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibConnectionOptions: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return ["user" : user ?? "",
                "group" : group ?? "",
                "password" : password ?? "",
                "authentication" : authentication ?? "",
                "lang" : lang ?? "",
                "charset" : charset ?? "",
                "timeout" : timeout,
                "needsEventPolling" : needsEventPolling]
    }
}

// MARK: - Swift Native

extension Connection {
    public struct Options {
        private var options: BibMutableConnectionOptions

        internal init(options: BibConnectionOptions) {
            self.options = options.mutableCopy() as! BibMutableConnectionOptions
        }

        public init() {
            self.options = BibMutableConnectionOptions()
        }
    }
}

extension Connection.Options {
    public var user: String? {
        get { return options.user }
        set {
            if !isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.user = newValue
        }
    }

    public var password: String? {
        get { return options.password }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.password = newValue
        }
    }

    public var authentication: AuthenticationMode? {
        get { return options.authentication }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.authentication = newValue
        }
    }

    public var lang: String? {
        get { return options.lang }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.lang = newValue
        }
    }

    public var charset: String? {
        get { return options.charset }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.charset = newValue
        }
    }

    public var timeout: UInt {
        get { return options.timeout }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.timeout = newValue
        }
    }

    public var needsEventPolling: Bool {
        get { return options.needsEventPolling }
        set {
            if isKnownUniquelyReferenced(&options) {
                options = options.mutableCopy() as! BibMutableConnectionOptions
            }
            options.needsEventPolling = newValue
        }
    }
}

extension Connection.Options: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return options.playgroundDescription
    }
}

// MARK: - Objective-C Bridging

extension Connection.Options: _ObjectiveCBridgeable {
    public func _bridgeToObjectiveC() -> BibConnectionOptions {
        return options.copy() as! BibConnectionOptions
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibConnectionOptions, result: inout Connection.Options?) {
        result = Connection.Options(options: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibConnectionOptions, result: inout Connection.Options?) -> Bool {
        result = Connection.Options(options: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibConnectionOptions?) -> Connection.Options {
        return source.map(Connection.Options.init(options:)) ?? Connection.Options()
    }
}
