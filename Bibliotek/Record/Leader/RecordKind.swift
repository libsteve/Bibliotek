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
public enum RecordKind: UInt8, RawRepresentable, Hashable, Sendable {
    /// Language Material
    case languageMaterial = 0x61 // 'a'

    /// Notated Music
    case notatedMusic = 0x63 // 'c'

    /// Manuscript Notated Music
    case manuscriptNotatedMusic = 0x64 // 'd'

    /// Cartographic Material
    case cartographicMaterial = 0x65 // 'e'

    /// Manuscript Cartographic Material
    case manuscriptCartographicMaterial = 0x66 // 'f'

    /// Projected Medium
    case projectedMedium = 0x67 // 'g'

    /// NonMusical Sound Recording
    case nonMusicalSoundRecording = 0x69 // 'i'

    /// Musical Sound Recording
    case musicalSoundRecording = 0x6A // 'j'

    /// Two-Dimensional Non-Projectable Graphic
    case twoDimensionalNonProjectableGraphic = 0x6B // 'k'

    /// Computer File
    case computerFile = 0x6D // 'm'

    /// Kit
    case kit = 0x6F // 'o'

    /// Mixed Materials
    case mixedMaterials = 0x70 // 'p'

    /// Community Information
    case communityInformation = 0x71 // 'q'

    /// Three-Dimensional Artifact
    case threeDimensionalArtifact = 0x72 // 'r'

    /// Manuscript LanguageMaterial
    case manuscriptLanguageMaterial = 0x74 // 't'

    /* Unknown Holdings */
    case unknownHoldings = 0x75 // 'u'

    /* Multipart Item Holdings */
    case multipartItemHoldings = 0x76 // 'v'

    /* Classification */
    case classification = 0x77 // 'w'

    /* Single Part Item Holdings */
    case singlePartItemHoldings = 0x78 // 'x'

    /* Serial Item Holdings */
    case serialItemHoldings = 0x79 // 'y'

    /* Authority Data */
    case authorityData = 0x7A // 'z'
}

// MARK: - MARC 21 Categories

extension RecordKind {
    public var format: BibRecord.Format {
        switch self {
        case .languageMaterial,
             .notatedMusic,
             .manuscriptNotatedMusic,
             .cartographicMaterial,
             .manuscriptCartographicMaterial,
             .projectedMedium,
             .nonMusicalSoundRecording,
             .musicalSoundRecording,
             .twoDimensionalNonProjectableGraphic,
             .computerFile,
             .kit,
             .mixedMaterials,
             .threeDimensionalArtifact,
             .manuscriptLanguageMaterial:
            return .bibliographic
        case .communityInformation: 
            return .community
        case .unknownHoldings,
             .multipartItemHoldings,
             .singlePartItemHoldings,
             .serialItemHoldings: 
            return .holdings
        case .classification: 
            return .classification
        case .authorityData: 
            return .authority
        }
    }

    /// Does a record marked with this kind represent classification information?
    public var isClassification: Bool { self.format == .classification }

    /// Does a record marked with this kind represent bibliographic information?
    public var isBibliographic: Bool { self.format == .bibliographic }
}

extension RecordKind: CustomStringConvertible, CustomDebugStringConvertible, CustomPlaygroundDisplayConvertible {
    public var description: String {
        let bundle = Bundle(for: BibRecordKind.self)
        let key = String(format: "%c", self.rawValue)
        return bundle.localizedString(forKey: key, value: nil, table: "RecordKind")
    }

    public var debugDescription: String {
        "RecordKind(rawValue: \(String(format: "'%c'", self.rawValue))"
    }

    public var playgroundDescription: Any { return self.description }
}

// MARK: - Bridging

extension RecordKind: ReferenceConvertible {
    public typealias ReferenceType = BibRecordKind
}

extension RecordKind: _ObjectiveCBridgeable {
    public typealias _ObjectiveCType = BibRecordKind

    public func _bridgeToObjectiveC() -> BibRecordKind {
        return BibRecordKind(rawValue: self.rawValue)!
    }

    public static func _forceBridgeFromObjectiveC(_ source: BibRecordKind, result: inout RecordKind?) {
        result = RecordKind(rawValue: source.rawValue)
    }

    public static func _conditionallyBridgeFromObjectiveC(_ source: BibRecordKind, result: inout RecordKind?) -> Bool {
        result = RecordKind(rawValue: source.rawValue)
        return result != nil
    }

    public static func _unconditionallyBridgeFromObjectiveC(_ source: BibRecordKind?) -> RecordKind {
        return RecordKind(rawValue: source!.rawValue)!
    }
}

extension BibRecordKind: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any { return (self as RecordKind).playgroundDescription }
}
