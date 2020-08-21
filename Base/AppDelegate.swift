//
//  AppDelegate.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private static var sharedInstance: AppDelegate?

    static var shared: AppDelegate {
        return sharedInstance!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        AppDelegate.sharedInstance = self
        
        // Init root view for application
        initRootView()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.isIpad {
            return .landscape
        }
        return .portrait
    }

}

extension AppDelegate {

    private func initRootView() {
        configureRootView()
    }

    func configureRootView() {
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        var rootVC: UIViewController!
        let vc = LoginVC(LoginViewModel())
        rootVC = UINavigationController(rootViewController: vc)

        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()


    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController? {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension AppDelegate {
    func topMostViewController() -> UIViewController? {
        return self.window?.rootViewController?.topMostViewController()
    }
}


