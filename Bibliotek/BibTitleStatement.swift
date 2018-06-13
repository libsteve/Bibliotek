//
//  BibTitleStatement.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 6/13/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension TitleStatement: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return [title, subtitles, people]
    }
}
