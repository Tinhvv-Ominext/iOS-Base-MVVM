//
//  Image.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/12/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import UIKit

extension UIImage {

    func fixOrientation() -> UIImage {
        if (imageOrientation == .up) { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    func scale(to newSize: CGSize) -> UIImage? {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIImage {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    class func image(_ path: String, size: CGFloat) -> UIImage? {

        let image = UIImage(contentsOfFile: path)
        return image?.square(to: size)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func square(to extent: CGFloat) -> UIImage {

        var cropped: UIImage!

        let width = self.size.width
        let height = self.size.height

        if (width == height) {
            cropped = self
        } else if (width > height) {
            let xpos = (width - height) / 2
            cropped = self.crop(x: xpos, y: 0, width: height, height: height)
        } else if (height > width) {
            let ypos = (height - width) / 2
            cropped = self.crop(x: 0, y: ypos, width: width, height: width)
        }

        return cropped.resize(width: extent, height: extent)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func resize(width: CGFloat, height: CGFloat) -> UIImage {

        let size = CGSize(width: width, height: height)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: rect)
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resized!
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func crop(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> UIImage {

        let rect = CGRect(x: x, y: y, width: width, height: height)

        if let cgImage = self.cgImage {
            if let cropped = cgImage.cropping(to: rect) {
                return UIImage(cgImage: cropped)
            }
        }

        return UIImage()
    }
}
