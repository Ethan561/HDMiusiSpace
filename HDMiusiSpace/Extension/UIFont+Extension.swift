//
//  UIFont+Extension.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


extension UIFont {
    
    //获取系统支持的字体
    class func showAllFonts()
    {
        let familyNames = UIFont.familyNames
        for familyName in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: familyName as String)
            for fontName in fontNames
            {
                print("字体font名称：\(fontName)")
            }
        }
    }
}


