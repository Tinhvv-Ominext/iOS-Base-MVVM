//
//  UserDefault.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let messagesKey = "mockMessages"

    // MARK: - Mock Messages

    func setMockMessages(count: Int) {
        set(count, forKey: "mockMessages")
        synchronize()
    }

    func mockMessagesCount() -> Int {
        if let value = object(forKey: "mockMessages") as? Int {
            return value
        }
        return 20
    }

    static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}
