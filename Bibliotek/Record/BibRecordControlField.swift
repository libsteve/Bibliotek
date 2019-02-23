//
//  BibRecordControlField.swift
//  Bibliotek
//
//  Created by Steve Brunwasser on 2/22/19.
//  Copyright © 2019 Steve Brunwasser. All rights reserved.
//

import Foundation

extension Record.ControlField: CustomReflectable {
    public var customMirror: Mirror {
        return Mirror(self, children: [(label: "tag", value: content)],
                      displayStyle: .dictionary, ancestorRepresentation: .suppressed)
    }
}
