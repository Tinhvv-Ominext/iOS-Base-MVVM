//
//  Encodeable.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/12/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

extension Encodable {
    var values: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
