//
//  Extension-UIImage.swift
//  SwiftDiary-05
//
//  Created by 伏文东 on 2018/1/21.
//  Copyright © 2018年 伏文东. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.set()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    static func avatarImage(image: UIImage, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    static func navAvatarImage(image: UIImage, size: CGSize, backColor: UIColor?) -> UIImage? {
        let rect = CGRect(origin: CGPoint(), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor?.setFill()
        UIRectFill(rect)
        
        let path = UIBezierPath(ovalIn: rect)
        path.addClip()
        
        image.draw(in: rect)
        
        UIColor.groupTableViewBackground.setStroke()
        path.lineWidth = 0.5
        path.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}

