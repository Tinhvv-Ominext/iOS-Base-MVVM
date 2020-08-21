//
//  Font.swift
//  Knafeh
//
//  Created by Tinh Vu on 6/23/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit

// Usage Examples
let system14            = Font(.system, size: .standard(.h4)).instance
let nunitoSemiBold10    = Font(.installed(.NunitoSemiBold), size: .standard(.h6)).instance
let nunitoSemibold12       = Font(.installed(.NunitoSemiBold), size: .standard(.h5)).instance
let nunitoSemibold16       = Font(.installed(.NunitoSemiBold), size: .standard(.h3)).instance
let nunitoBold13    = Font(.installed(.NunitoBold), size: .custom(13)).instance
let nunitoBold14    = Font(.installed(.NunitoBold), size: .standard(.h4)).instance
let nunitoBold16    = Font(.installed(.NunitoBold), size: .standard(.h3)).instance
let nunitoBold18    = Font(.installed(.NunitoBold), size: .standard(.h2)).instance
let nunitoExtraBold26    = Font(.installed(.NunitoExtraBold), size: .standard(.extra)).instance

let nunitoRegular16    = Font(.installed(.NunitoRegular), size: .standard(.h3)).instance
let nunitoRegular12    = Font(.installed(.NunitoRegular), size: .standard(.h5)).instance
let nunitoRegular14    = Font(.installed(.NunitoRegular), size: .standard(.h4)).instance

struct Font {

    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
                case .standard(let size):
                    return size.rawValue
                case .custom(let customSize):
                    return customSize
            }
        }
    }
    enum FontName: String {
        case NunitoSemiBold         = "NunitoSans-SemiBold"
        case NunitoBold             = "NunitoSans-Bold"
        case NunitoExtraBold = "NunitoSans-ExtraBold"
        case NunitoRegular             = "NunitoSans-Regular"
    }
    enum StandardSize: Double {
        case extra = 26.0
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
    }


    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {

    var instance: UIFont {

        var instanceFont: UIFont!
        switch type {
            case .custom(let fontName):
                guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                    fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
                }
                instanceFont = font
            case .installed(let fontName):
                guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                    fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
                }
                instanceFont = font
            case .system:
                instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
            case .systemBold:
                instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
            case .systemItatic:
                instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
            case .systemWeighted(let weight):
                instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                                 weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}

class Utility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
}
