//
//  RecordKind.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 7/28/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension RecordKind {
    /// Creates a new ``RecordKind`` from the given bibliographic record kind.
    /// - parameter kind: The kind of a bibliographic record.
    public init(_ kind: RecordKind.Bibliographic) {
        self.init(rawValue: kind.rawValue)!
    }

    /// Creates a new ``RecordKind`` from the given community record kind.
    /// - parameter kind: The kind of a community record.
   public init(_ kind: RecordKind.Community) {
        self.init(rawValue: kind.rawValue)!
    }

    /// Creates a new ``RecordKind`` from the given holdings record kind.
    /// - parameter kind: The kind of a holdings record.
    public init(_ kind: RecordKind.Holdings) {
        self.init(rawValue: kind.rawValue)!
    }

    /// Creates a new ``RecordKind`` from the given classification record kind.
    /// - parameter kind: The kind of a classification record.
    public init(_ kind: RecordKind.Classification) {
        self.init(rawValue: kind.rawValue)!
    }

    /// Creates a new ``RecordKind`` from the given authority record kind.
    /// - parameter kind: The kind of a authority record.
    public init(_ kind: RecordKind.Authority) {
        self.init(rawValue: kind.rawValue)!
    }

    /// The MARC 21 format for the record kind.
    public var format: RecordFormat {
        __BibRecordKindFormat(self)
    }

    /// Identifies the record kind as belonging to the bibliographic format.
    public var isBibliographic: Bool {
        format == .bibliographic
    }

    /// Identifies the record kind as belonging to the community format.
    public var isCommunity: Bool {
        format == .community
    }

    /// Identifies the record kind as belonging to the holdings format.
    public var isHoldings: Bool {
        format == .holdings
    }

    /// Identifies the record kind as belonging to the classification format.
    public var isClassification: Bool {
        format == .classification
    }

    /// Identifies the record kind as belonging to the authority format.
    public var isAuthority: Bool {
        format == .authority
    }
}

extension RecordKind: CustomStringConvertible, CustomDebugStringConvertible,
                      CustomPlaygroundDisplayConvertible {
    public var description: String {
        __BibRecordKindDescription(self)
    }

    public var debugDescription: String {
        switch self {
        case .languageMaterial: 
            return "\(Self.self).languageMaterial"
        case .archivalAndManuscriptsControl:
            return "\(Self.self).archivalAndManuscriptsControl"
        case .notatedMusic:
            return "\(Self.self).notatedMusic"
        case .manuscriptNotatedMusic:
            return "\(Self.self).manuscriptNotatedMusic"
        case .cartographicMaterial:
            return "\(Self.self).cartographicMaterial"
        case .manuscriptCartographicMaterial:
            return "\(Self.self).manuscriptCartographicMaterial"
        case .projectedMedium:
            return "\(Self.self).projectedMedium"
        case .microformPublications:
            return "\(Self.self).microformPublications"
        case .nonMusicalSoundRecording:
            return "\(Self.self).nonMusicalSoundRecording"
        case .musicalSoundRecording:
            return "\(Self.self).musicalSoundRecording"
        case .twoDimensionalNonProjectableGraphic:
            return "\(Self.self).twoDimensionalNonProjectableGraphic"
        case .computerFile:
            return "\(Self.self).computerFile"
        case .specialInstructionalMaterial:
            return "\(Self.self).specialInstructionalMaterial"
        case .kit:
            return "\(Self.self).kit"
        case .mixedMaterials:
            return "\(Self.self).mixedMaterials"
        case .communityInformation:
            return "\(Self.self).communityInformation"
        case .threeDimensionalArtifact:
            return "\(Self.self).threeDimensionalArtifact"
        case .manuscriptLanguageMaterial:
            return "\(Self.self).manuscriptLanguageMaterial"
        case .unknownHoldings:
            return "\(Self.self).unknownHoldings"
        case .multipartItemHoldings:
            return "\(Self.self).multipartItemHoldings"
        case .classification:
            return "\(Self.self).classification"
        case .singlePartItemHoldings:
            return "\(Self.self).singlePartItemHoldings"
        case .serialItemHoldings:
            return "\(Self.self).serialItemHoldings"
        case .authorityData:
            return "\(Self.self).authorityData"
        case _ where 0x20...0x7E ~= rawValue: 
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}

// MARK: - Bibliographic Record Kind

extension RecordKind.Bibliographic {
    public init?(_ kind: RecordKind) {
        guard kind.format == .bibliographic else { return nil }
        self.init(rawValue: kind.rawValue)
    }
}

extension RecordKind.Bibliographic: CustomStringConvertible,
                                    CustomDebugStringConvertible,
                                    CustomPlaygroundDisplayConvertible {
    public var description: String {
        RecordKind(self).description
    }

    public var debugDescription: String {
        switch self {
        case .languageMaterial:
            return "\(Self.self).languageMaterial"
        case .archivalAndManuscriptsControl:
            return "\(Self.self).archivalAndManuscriptsControl"
        case .notatedMusic:
            return "\(Self.self).notatedMusic"
        case .manuscriptNotatedMusic:
            return "\(Self.self).manuscriptNotatedMusic"
        case .cartographicMaterial:
            return "\(Self.self).cartographicMaterial"
        case .manuscriptCartographicMaterial:
            return "\(Self.self).manuscriptCartographicMaterial"
        case .projectedMedium:
            return "\(Self.self).projectedMedium"
        case .microformPublications:
            return "\(Self.self).microformPublications"
        case .nonMusicalSoundRecording:
            return "\(Self.self).nonMusicalSoundRecording"
        case .musicalSoundRecording:
            return "\(Self.self).musicalSoundRecording"
        case .twoDimensionalNonProjectableGraphic:
            return "\(Self.self).twoDimensionalNonProjectableGraphic"
        case .computerFile:
            return "\(Self.self).computerFile"
        case .specialInstructionalMaterial:
            return "\(Self.self).specialInstructionalMaterial"
        case .kit:
            return "\(Self.self).kit"
        case .mixedMaterials:
            return "\(Self.self).mixedMaterials"
        case .threeDimensionalArtifact:
            return "\(Self.self).threeDimensionalArtifact"
        case .manuscriptLanguageMaterial:
            return "\(Self.self).manuscriptLanguageMaterial"
        case _ where 0x20...0x7E ~= rawValue:
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}

// MARK: - Community Record Kind

extension RecordKind.Community {
    public init?(_ kind: RecordKind) {
        guard kind.format == .community else { return nil }
        self.init(rawValue: kind.rawValue)
    }
}

extension RecordKind.Community: CustomStringConvertible,
                                CustomDebugStringConvertible,
                                CustomPlaygroundDisplayConvertible {
    public var description: String {
        RecordKind(self).description
    }

    public var debugDescription: String {
        switch self {
        case .communityInformation:
            return "\(Self.self).communityInformation"
        case _ where 0x20...0x7E ~= rawValue:
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}

// MARK: - Holdings Record Kind

extension RecordKind.Holdings {
    public init?(_ kind: RecordKind) {
        guard kind.format == .holdings else { return nil }
        self.init(rawValue: kind.rawValue)
    }
}

extension RecordKind.Holdings: CustomStringConvertible,
                               CustomDebugStringConvertible,
                               CustomPlaygroundDisplayConvertible {
    public var description: String {
        RecordKind(self).description
    }

    public var debugDescription: String {
        switch self {
        case .unknown: 
            return "\(Self.self).unknown"
        case .multipartItem:
            return "\(Self.self).multipartItem"
        case .singlePartItem:
            return "\(Self.self).singlePartItem"
        case .serialItem:
            return "\(Self.self).serialItem"
        case _ where 0x20...0x7E ~= rawValue:
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}

// MARK: - Classification Record Kind

extension RecordKind.Classification {
    public init?(_ kind: RecordKind) {
        guard kind.format == .classification else { return nil }
        self.init(rawValue: kind.rawValue)
    }
}

extension RecordKind.Classification: CustomStringConvertible,
                                     CustomDebugStringConvertible,
                                     CustomPlaygroundDisplayConvertible {
    public var description: String {
        RecordKind(self).description
    }
    
    public var debugDescription: String {
        switch self {
        case .classification:
            return "\(Self.self).classification"
        case _ where 0x20...0x7E ~= rawValue:
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}

// MARK: - Authority Record Kind

extension RecordKind.Authority {
    public init?(_ kind: RecordKind) {
        guard kind.format == .authority else { return nil }
        self.init(rawValue: kind.rawValue)
    }
}

extension RecordKind.Authority: CustomStringConvertible,
                                CustomDebugStringConvertible,
                                CustomPlaygroundDisplayConvertible {
    public var description: String {
        RecordKind(self).description
    }
    
    public var debugDescription: String {
        switch self {
        case .authorityData:
            return "\(Self.self).authorityData"
        case _ where 0x20...0x7E ~= rawValue:
            return "\(Self.self)(rawValue: '\(UnicodeScalar(UInt8(rawValue)))')"
        default:
            let description = String(rawValue, radix: 16, uppercase: true)
            return "\(Self.self)(rawValue: 0x\(description)"
        }
    }

    public var playgroundDescription: Any {
        description
    }
}
