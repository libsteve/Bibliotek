//
//  BibConnection.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 8/8/18.
//  Copyright © 2018 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Connection {
    public typealias Error = ConnectionError

    public func processNextEvent() throws -> Event {
        var error: NSError?
        let event = __processNextEvent(&error)
        guard error == nil else { throw error! }
        return event
    }

    public static func processNextEvent<S>(for connections: S) throws -> (Connection, Event)?
        where S: Sequence, S.Element == Connection {
            guard let result = __processNextEvent(for: Array(connections)) else { return nil; }
            guard let connection = result as? Connection else { throw (result as! Error) }
            return (connection, connection.__lastProcessedEvent)
    }
}
