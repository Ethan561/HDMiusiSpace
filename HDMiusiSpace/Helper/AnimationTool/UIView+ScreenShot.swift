//
//  UIView+ScreenShot.swift
//  SwiftAnimations
//
//  Created by liuyi on 2018/4/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

extension UIView {
    
    //
    func screenShot() -> UIImage {
        return screenShot(rect: bounds)
    }
    
    func screenShot(rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        guard let content = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        let path = UIBezierPath.init(rect: rect)
        path.addClip()
        layer.render(in: content)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        image!.draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        
        let image2 = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image2!
        
    }
    
}
















