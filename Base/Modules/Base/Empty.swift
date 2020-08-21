//
//  Empty.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import ObjectMapper

struct Empty: Mappable {

    init() {
    }

    init?(map: Map) {
        mapping(map: map)
    }

    mutating func mapping(map: Map) {
    }

}
