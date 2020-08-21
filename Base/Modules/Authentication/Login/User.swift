//
//  User.swift
//  Base
//
//  Created by tinhvv-ominext on 8/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    
    var name: String?
    var token: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        token <- map["token"]
    }
}
