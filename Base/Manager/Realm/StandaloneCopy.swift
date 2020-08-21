//
//  StandaloneCopy.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

protocol StandaloneCopy {
    associatedtype T

    func toStandalone() -> T

}
