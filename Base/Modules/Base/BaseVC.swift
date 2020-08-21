//
//  BaseVCViewController.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class BaseVC: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        hideKeyboardWhenTappedAround()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoading() {
        SVProgressHUD.setForegroundColor(.tabSelectedColor)
        SVProgressHUD.setContainerView(view)
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    func showMessage(_ message: String?) {
        UIAlertController.showMessage(message)
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        })
    }

}

extension BaseVC: ViewModelProtocol {
    
    func onShowLoading() {
        showLoading()
    }
    
    func onHideLoading() {
        hideLoading()
    }
    
    func handleError(_ error: Error?) {
        showMessage(error?.localizedDescription)
    }
}
