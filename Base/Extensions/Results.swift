//
//  Results.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<R: StandaloneCopy>(ofType: R.Type) -> [R.T] {
        typealias RM = R.T
        var array = [RM]()
        for i in 0 ..< count {
            if let result = self[i] as? R {
                array.append(result.toStandalone())
            }
        }

        return array
    }
}
