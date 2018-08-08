//
//  BibConnectionOptions.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/7/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection.Options: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return ["user" : user ?? "",
                "group" : group ?? "",
                "password" : password ?? "",
                "authentication" : authentication ?? "",
                "lang" : lang ?? "",
                "charset" : charset ?? "",
                "needsEventPolling" : needsEventPolling]
    }
}
