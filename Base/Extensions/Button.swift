//
//  Button.swift
//  Knafeh
//
//  Created by Tinh Vu on 7/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import UIKit

extension UIButton {
  func imageToRight() {
      transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
      imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
  }
}
