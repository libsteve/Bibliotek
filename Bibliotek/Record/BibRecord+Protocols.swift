//
//  BibRecord+Protocols.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/26/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

public protocol RecordProtocol {
    /// The name of the database from which this record originates.
    var database: String { get set }

    /// The ISBN-10 value for the item represented by this record.
    var isbn10: String? { get set }

    /// The ISBN-13 value for the item represented by this record.
    var isbn13: String? { get set }

    /// A list of classifications applicable to the item represented by this record.
    var callNumbers: [CallNumber] { get set }

    /// The title of the item represented by this record.
    var title: String { get set }

    /// A list of subtitles applicable to the item represented by this record.
    var subtitles: [String] { get set }

    /// The authors of the represented item.
    var authors: [String] { get set }

    /// A list the people involved in creating the represented item, along with their respective roles.
    var contributors: [String] { get set }

    /// Edition descriptions applicable to the represented item.
    var editions: [String] { get set }

    /// A list of subjects to which the represented item belongs.
    var subjects: [String] { get set }

    /// A list of statements describing the represented item.
    var summaries: [String] { get set }
}
