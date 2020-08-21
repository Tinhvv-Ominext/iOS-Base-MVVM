//
//  Error.swift
//  Knafeh
//
//  Created by Tinh Vu on 8/6/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension NSError {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func description(_ description: String, code: Int) -> Error? {

        let domain = Bundle.main.bundleIdentifier ?? ""
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
