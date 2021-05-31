//
//  RecordKind.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

/// The type of data represented by a MARC 21 record.
///
/// MARC 21 records can represent multiple kinds of information—bibliographic, classification, etc.—which each use
/// different schemas to present their information.
///
/// Use this value to determine how tags and subfield codes should be used to interpret a record's content.
public struct RecordKind: RawRepresentable {
    private var _storage: BibRecordKind

    public var rawValue: UInt8 { return self._storage.rawValue }

    public init?(rawValue: UInt8) {
        guard let storage = BibRecordKind(rawValue: rawValue) else { return nil }
        self._storage = storage
    }

    private init(storage: BibRecordKind) {
        self._storage = storage
    }
}

// MARK: - MARC 21 Categories

extension RecordKind {
    /// Does a record marked with this kind represent classification information?
    public var isClassification: Bool { return self._storage.isClassificationKind }

    /// Does a record marked with this kind represent bibliographic information?
    public var isBibliographic: Bool { return self._storage.isBibliographicKind }
}

// MARK: - MARC 21 Record Kinds

extension RecordKind {
    /// Classification
    public static let classification = BibRecordKind.classification

    /// Language Material
    public static let languageMaterial = BibRecordKind.languageMaterial

    /// Notated Music
    public static let notatedMusic = BibRecordKind.notatedMusic

    /// Manuscript Notated Music
    public static let manuscriptNotatedMusic = BibRecordKind.manuscriptNotatedMusic

    /// Cartographic Material
    public static let cartographicMaterial = BibRecordKind.cartographicMaterial

    /// Manuscript Cartographic Material
    public static let manuscriptCartographicMaterial = BibRecordKind.manuscriptCartographicMaterial

    /// Projected Medium
    public static let projectedMedium = BibRecordKind.projectedMedium

    /// NonMusical Sound Recording
    public static let nonMusicalSoundRecording = BibRecordKind.nonMusicalSoundRecording

    /// Musical Sound Recording
    public static let musicalSoundRecording = BibRecordKind.musicalSoundRecording

    /// Two-Dimensional Non-Projectable Graphic
    public static let twoDimensionalNonProjectableGraphic = BibRecordKind.twoDimensionalNonProjectableGraphic

    /// Computer File
    public static let computerFile = BibRecordKind.computerFile

    /// Kit
    public static let kit = BibRecordKind.kit

    /// Mixed Materials
    public static let mixedMaterials = BibRecordKind.mixedMaterials

    /// Three-Dimensional Artifact
    public static let threeDimensionalArtifact = BibRecordKind.threeDimensionalArtifact

    /// Manuscript Language Material
    public static let manuscriptLanguageMaterial = BibRecordKind.manuscriptLanguageMaterial

}

// MARK: -

extension RecordKind: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self._storage)
    }

    public static func == (lhs: RecordKind, rhs: RecordKind) -> Bool {
        return lhs._storage.isEqual(to: rhs._storage)
    }
}

extension RecordKind: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String { return self._storage.description }

    public var debugDescription: String { return self._storage.debugDescription }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension RecordKind: ReferenceConvertible {
    public typealias ReferenceType = BibRecordKind
}

extension RecordKind: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecordKind

    public func _bridgeToObjectiveC() -> BibRecordKind {
        return self._storage
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecordKind, result: inout RecordKind?) {
        result = RecordKind(storage: source)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecordKind, result: inout RecordKind?) -> Bool {
        result = RecordKind(storage: source)
        return true
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecordKind?) -> RecordKind {
        return RecordKind(storage: source!)
    }
}

extension BibRecordKind: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as RecordKind).playgroundDescription }
}
