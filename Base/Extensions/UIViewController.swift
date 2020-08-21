//
//  UIViewController.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/10/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
       return topViewController?.preferredStatusBarStyle ?? .default
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func add(_ vc: UIViewController, toView: UIView) {
        addChild(vc)
        vc.view.frame = toView.bounds
        toView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
}
