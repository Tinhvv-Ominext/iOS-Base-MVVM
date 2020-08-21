//
//  Enums.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/12/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit

enum TabType: Int {
    case activity
    case calendar
    case chat
    case profile

    var title: String {
        switch self {
            case .calendar:
            return "Calendar"
            case .chat:
                return "Chat"
            case .activity:
                return "Activity"
            case .profile:
                return "My Profile"
        }
    }

    var imageName: String? {
        switch self {
            case .calendar:
                return "ic_calendar"
            case .chat:
                return "ic_chat"
            case .activity:
                return "ic_activity"
            case .profile:
                return nil
        }
    }

    var imageNameSelected: String? {
        switch self {
            case .calendar:
                return "ic_calendar-1"
            case .chat:
                return "ic_chat-1"
            case .activity:
                return "ic_activity-1"
            case .profile:
                return nil
        }
    }

    var image: UIImage? {
        guard let name = imageName else {
            return nil
        }

        return UIImage(named: name)
    }

    var imageSelected: UIImage? {
        guard let name = imageNameSelected else {
            return nil
        }

        return UIImage(named: name)
    }
}
