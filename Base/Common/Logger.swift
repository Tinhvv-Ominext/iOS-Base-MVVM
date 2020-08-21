//
//  Logger.swift
//  Knafeh
//
//  Created by Tinh Vu on 6/26/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

enum LogType: String{
    case error
    case warning
    case success
    case action
    case canceled
}


class Logger{

    static func log(_ logType:LogType,_ message: Any){
        
        switch logType {
            case LogType.error:
                print("\n📕 Error: \(message)\n")
            case LogType.warning:
                print("\n📙 Warning: \(message)\n")
            case LogType.success:
                print("\n📗 Success: \(message)\n")
            case LogType.action:
                print("\n📘 Action: \(message)\n")
            case LogType.canceled:
                print("\n📓 Cancelled: \(message)\n")
        }
    }

}
