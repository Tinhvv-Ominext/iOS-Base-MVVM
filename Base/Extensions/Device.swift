//
//  Device.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/10/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {

    static var isIpad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }

}
