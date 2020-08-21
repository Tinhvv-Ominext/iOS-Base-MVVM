//
//  ResponseObject.swift
//  Base
//
//  Created by tinhvv-ominext on 8/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import ObjectMapper

class ResponseObject: NSObject {
    var data: Mappable?
    var dataList: [Mappable]?
    var empty: Empty?
    
    override init() {
        
    }
    
    init(empty: Empty) {
        self.empty = empty
    }
}
