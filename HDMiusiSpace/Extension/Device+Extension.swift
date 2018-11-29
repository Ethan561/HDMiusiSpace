//
//  Device+Extension.swift
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/22.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

/* iPhoneX      的分辨率：2436 * 1125 || pt: 812 * 375   ratio == 812/375 == 2.16
 * iPhoneXs     的分辨率：2436 * 1125 || pt: 812 * 375
 * iPhoneXs Max 的分辨率：2688 * 1242 || pt: 896 * 414   ratio == 896/414 == 2.16
 * iPhoneXr     的分辨率：1792 * 828  || pt: 896 * 414
 */


extension UIDevice {
    /// 是不是iPhoneX ,如果是竖屏则 UIScreen.main.bounds.height == 812
    public func isPhoneX() -> Bool {
        if UIScreen.main.bounds.width == 812 || UIScreen.main.bounds.width == 896 {  /// 横屏
            return true
        }
        return false
    }
    
    /// 是不是iPad
    public func isPad() -> Bool {
        return (UIDevice.current.userInterfaceIdiom == .pad) ? true : false;
    }
    
    public func isiPhoneXSeries() -> Bool {
        if UIScreen.main.bounds.height/UIScreen.main.bounds.width >= 2.16 {
            return true
        }
        return false
    }
    
    
    func getUUID() -> String {
        let uuid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return uuid
    }
    
    
    
}




