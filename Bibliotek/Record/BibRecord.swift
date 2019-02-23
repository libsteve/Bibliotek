//
//  BibRecord.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record: CustomReflectable {
    public var customMirror: Mirror {
        let children: [Mirror.Child] = [(label: "leader", value: leader),
                                        (label: "controlFields", value: controlFields),
                                        (label: "dataFields", value: dataFields)]
        return Mirror(self, children: children, displayStyle: .dictionary, ancestorRepresentation: .suppressed)
    }
}
