//
//  Dictionary.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/12/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

extension Dictionary {

    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
