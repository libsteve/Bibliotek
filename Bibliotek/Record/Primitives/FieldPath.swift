//
//  FieldPath.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 5/10/20.
//  Copyright © 2020 Steve Brunwasser. All rights reserved.
//

import Foundation

public enum FieldPath: Hashable, Equatable {
    case fieldPath(tag: FieldTag)
    case subfieldPath(tag: FieldTag, code: SubfieldCode)

    public init(tag: FieldTag) {
        self = .fieldPath(tag: tag)
    }

    public init(tag: FieldTag, code: SubfieldCode) {
        precondition(!tag.isControlFieldTag)
        self = .subfieldPath(tag: tag, code: code)
    }
}

extension FieldPath {
    public var tag: FieldTag {
        switch self {
        case let .fieldPath(tag: tag): return tag
        case let .subfieldPath(tag: tag, code: _):  return tag
        }
    }

    public var code: SubfieldCode? {
        switch self {
        case .fieldPath(tag: _): return nil
        case let .subfieldPath(tag: _, code: code):  return code
        }
    }

    public var isControlFieldPath: Bool {
        switch self {
        case let .fieldPath(tag: tag): return tag.isControlFieldTag
        case .subfieldPath(tag: _, code: _): return false
        }
    }

    public var isContentFieldPath: Bool {
        switch self {
        case let .fieldPath(tag: tag): return !tag.isControlFieldTag
        case .subfieldPath(tag: _, code: _): return false
        }
    }

    public var isSubfieldPath: Bool {
        switch self {
        case .fieldPath(tag: _): return false
        case .subfieldPath(tag: _, code: _): return true
        }
    }
}

extension FieldPath: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return (self as BibFieldPath).description }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension FieldPath: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibFieldPath

    public func _bridgeToObjectiveC() -> BibFieldPath {
        switch self {
        case let .fieldPath(tag: fieldTag):
            return BibFieldPath(fieldTag: fieldTag as BibFieldTag)
        case let .subfieldPath(tag: fieldTag, code: subfieldCode):
            return BibFieldPath(fieldTag: fieldTag as BibFieldTag, subfieldCode: subfieldCode)
        }
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibFieldPath, result: inout FieldPath?) -> Bool {
        result = (source.isSubfieldPath)
               ? .subfieldPath(tag: source.fieldTag as FieldTag, code: source.subfieldCode!)
               : .fieldPath(tag: source.fieldTag as FieldTag)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibFieldPath?) -> FieldPath {
        return (source!.isSubfieldPath)
             ? .subfieldPath(tag: source!.fieldTag as FieldTag, code: source!.subfieldCode!)
             : .fieldPath(tag: source!.fieldTag as FieldTag)
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibFieldPath, result: inout FieldPath?) {
        result = (source.isSubfieldPath)
               ? .subfieldPath(tag: source.fieldTag as FieldTag, code: source.subfieldCode!)
               : .fieldPath(tag: source.fieldTag as FieldTag)
    }
}

extension BibFieldPath: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as FieldPath).playgroundDescription }
}
