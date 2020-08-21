//
//  Optional.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/12/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

extension Optional {
    var isNone: Bool {
        return self == nil
    }

    var isSome: Bool {
        return self != nil
    }
}
