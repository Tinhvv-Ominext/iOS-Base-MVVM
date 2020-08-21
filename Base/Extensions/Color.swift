//
//  Color.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/10/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    /// SwifterSwift: Hexadecimal value string (read-only).
    var hexString: String {
        var red:    CGFloat = 0
        var green:    CGFloat = 0
        var blue:    CGFloat = 0
        var alpha:    CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        return NSString(format: "#%06x", rgb).uppercased as String
    }

    static var primary: UIColor {
        return UIColor(red: 1 / 255, green: 93 / 255, blue: 48 / 255, alpha: 1)
    }

    static var incomingMessage: UIColor {
        return UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }

    static let primaryColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)

}

// MARK: - Initializers
public extension UIColor {

    /// SwifterSwift: Create UIColor from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (default is 1).
    convenience init(hex: Int, transparency: CGFloat = 1) {
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: (hex >> 16) & 0xff, green: (hex >> 8) & 0xff, blue: hex & 0xff, transparency: trans)
    }


    /// SwifterSwift: Create UIColor from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (default is 1).
    convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        var trans: CGFloat {
            if transparency > 1 {
                return 1
            } else if transparency < 0 {
                return 0
            } else {
                return transparency
            }
        }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }

    /// SwifterSwift: Create UIColor from a complementary of a UIColor (if applicable).
    ///
    /// - Parameter color: color of which opposite color is desired.
    convenience init?(complementaryFor color: UIColor) {
        let colorSpaceRGB = CGColorSpaceCreateDeviceRGB()
        let convertColorToRGBSpace : ((_ color: UIColor) -> UIColor?) = { (color) -> UIColor? in
            if color.cgColor.colorSpace!.model == CGColorSpaceModel.monochrome {
                let oldComponents = color.cgColor.components
                let components: [CGFloat] = [ oldComponents![0], oldComponents![0], oldComponents![0], oldComponents![1] ]
                let colorRef = CGColor(colorSpace: colorSpaceRGB, components: components)
                let colorOut = UIColor(cgColor: colorRef!)
                return colorOut
            } else {
                return color
            }
        }

        let c = convertColorToRGBSpace(color)
        guard let componentColors = c?.cgColor.components else {
            return nil
        }

        let r: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[0]*255), 2.0))/255
        let g: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[1]*255), 2.0))/255
        let b: CGFloat = sqrt(pow(255.0, 2.0) - pow((componentColors[2]*255), 2.0))/255
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

}
