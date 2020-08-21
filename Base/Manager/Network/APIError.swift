//
//  APIError.swift
//  Base
//
//  Created by tinhvv-ominext on 8/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

enum APIError: Error {
    case notSecureConnection
    case invalidJSONFormat
    case noInternetConnection
    case connectionError(code: Int, message: String?)
}
