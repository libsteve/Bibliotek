//
//  BibConnection.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/8/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection {
    public func processNextEvent() throws -> Event {
        var error: NSError?
        let event = __processNextEvent(&error)
        guard error == nil else { throw error! }
        return event
    }

    public static func processNextEvent<S>(for connections: S) throws -> (Connection, Event)?
        where S: Sequence, S.Element == Connection {
            guard let event = __processNextEvent(for: Array(connections)) else { return nil; }
            guard event.error == nil else { throw event.error! }
            return (event.connection, event.event)
    }
}
