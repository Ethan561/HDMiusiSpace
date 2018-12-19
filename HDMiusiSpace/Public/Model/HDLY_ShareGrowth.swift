//
//  HDLY_ShareGrowth.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/19.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


class HDLY_ShareGrowth: NSObject {
    
    
   class func shareGrowthRequest() {
    
    let token:String? = HDDeclare.shared.api_token
        if token == nil {
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .growthShare(api_token: token!), showHud: true, loadingVC: nil, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let data:Int = dic?["data"] as! Int
            if data == 1 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    HDAlert.showAlertTipWith(type: .onlyText, text: "成长值+1")
                })
            } else {
                
            }
            
        }) { (errorCode, msg) in
           
        }
    }
    
    
}



