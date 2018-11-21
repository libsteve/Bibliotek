//
//  BibCallNumber.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/10/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension CallNumber {
    public static func == (lhs: CallNumber, rhs: CallNumber) -> Bool {
        return lhs.isEqual(rhs)
    }

    /// Determine whether or not the given call numbers have the same classification.
    /// - parameter lhs: The call number with which similarity should be determined.
    /// - parameter rhs: The call number with which similarity should be determined.
    public static func ~= (lhs: CallNumber, rhs: CallNumber) -> Bool {
        return lhs.isSimilar(to: rhs)
    }
}

extension LibraryOfCongressCallNumber: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return description
    }
}

extension DeweyDecimalCallNumber: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return debugDescription
    }
}
