//
//  HDAlert.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
//import MBProgressHUD

class HDAlert: NSObject {
    //
    class func showAlertTipWith(type: HDAlertType, text: String) {
        if text.isEmpty == true {
            return
        }
        let tipView:HD_LY_TipView =  HD_LY_TipView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), tipMsg: text, alertType: type)
        tipView.showAlert()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            tipView.hideAlert()
        }
    }
}

























