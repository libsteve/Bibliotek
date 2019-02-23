//
//  BibRecordDataField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.DataField: CustomReflectable {
    public var customMirror: Mirror {
        let children: [Mirror.Child] = [(label: "tag", value: tag),
                                        (label: "indicators", value: indicators.joined()),
                                        (label: "subfields", value: subfields)]
        return Mirror(self, children: children, displayStyle: .dictionary, ancestorRepresentation: .suppressed)
    }
}
