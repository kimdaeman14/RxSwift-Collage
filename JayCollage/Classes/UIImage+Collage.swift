//
//  UIImage+Collage.swift
//  JayCollage
//
//  Created by Jaycee on 2020/01/01.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    static func collage(images: [UIImage], size: CGSize) -> UIImage {
        
        
        let rows = images.count < 3 ? 1 : 2
        let columns = Int(round(Double(images.count) / Double(rows)))
        let tileSize = CGSize(width: round(size.width / CGFloat(columns)), //사진 사이즈조절해주는곳인듯?.
            height: round(size.height / CGFloat(rows)))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        for (index, image) in images.enumerated() {
            image.scaled(tileSize).draw(at: CGPoint(
                x: CGFloat(index % columns) * tileSize.width,
                y: CGFloat(index / columns) * tileSize.height
            ))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    
    static func rotateCollage(images: [UIImage], size: CGSize) -> UIImage {
        
        let rows = images.count < 3 ? 1 : 2
        let columns = Int(round(Double(images.count) / Double(rows)))
        let tileSize = CGSize(width: round(size.width / CGFloat(columns)), //사진 사이즈조절해주는곳인듯?.
            height: round(size.height / CGFloat(rows)))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        for (index, image) in images.enumerated() {
            let random = CGFloat(Double.random(in: 0.1 ..< 1.0))
            let random1 = Float(Double.random(in: -20.0 ..< 20.0))
            image.rotate(radians: .pi/random1)?.scaled(tileSize).draw(at: CGPoint(
                x: CGFloat(index % columns) * tileSize.width  * random,
                y: CGFloat(index / columns) * tileSize.height * random
            ))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func scaled(_ newSize: CGSize) -> UIImage {
        guard size != newSize else {
            return self
        }
        
        let ratio = max(newSize.width / size.width, newSize.height / size.height)
        let width = size.width * ratio
        let height = size.height * ratio
        
        let scaledRect = CGRect(
            x: (newSize.width - width) / 2.0,
            y: (newSize.height - height) / 2.0,
            width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
        defer { UIGraphicsEndImageContext() }
        
        draw(in: scaledRect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        context.rotate(by: CGFloat(radians))
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
