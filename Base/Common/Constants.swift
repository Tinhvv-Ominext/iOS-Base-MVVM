//
//  Constants.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

struct K {
    static let appLanguage = "AppLanguage"
    static let currentUser = "CurrentUser"
    static let currentPassword = "CurrentPassword"
    static let EN = "EN"
    static let SV = "SV"
    static let VN = "VN"

    static let FaiedLanguage = "Faied Language"
    static let LastRefreshToken = "Last Refresh Token"
    
    static let FirstTimeLoadedCalendar = "FirstTimeLoadedCalendar"
}

extension Notification.Name {
    static let languageChanged = Notification.Name("LanguageChanged")
    static let avatarChanged = Notification.Name("AvatarChanged")
}
