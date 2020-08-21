//
//  Global.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/10/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import RxSwift

class Global {
    static let shared = Global()
    var disposeBag = DisposeBag()
    var user: User?
    
    var pinnedMessages: [String: [String]] = [:]

    var token: String? {
        return user?.token
    }

    var isLogined: Bool {
        return user != nil
    }

    init() {
        loadData()
    }

    func saveUser(_ user: User?) {
        self.user = user
        let json = user?.toJSON()
        UserDefaults.standard.set(json, forKey: K.currentUser)
    }

    func loadData() {
        if let json = UserDefaults.standard.value(forKey: K.currentUser) as? [String: Any] {
            self.user = User(JSON: json)
        }
    }

    func updateToken(_ newToken: String) {
        user?.token = newToken
    }

    func logout() {
        self.saveUser(nil)
        AppDelegate.shared.configureRootView()
    }

}
