//
//  BibBibliographicContents.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 3/16/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension BibliographicContents: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return (note as NSString).components(separatedBy: " -- ")
    }
}
