//
//  HDLY_UserModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_UserModel: NSObject {
    //单例
    static let shared = HDLY_UserModel()
    public typealias backBlock = (_ backMsg :String) ->()
    
    open func getDeviceNum() {
        let declare:HDDeclare = HDDeclare.shared
        let defaults = UserDefaults.standard
        
        let deviceNum:String? = defaults.string(forKey: deviceNumberKey)
        if (deviceNum != nil) {
            declare.deviceno = deviceNum
        }else {
            HDLY_UserModel.shared.requestDeviceNumber()
        }
    }
    //请求机器号
    open func requestDeviceNumber () {
    
        let declare = HDDeclare.shared
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.requestDeviceno(), cache: false, showHud: false , success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" 获取机器号： \(String(describing: dic))")
            declare.deviceno = dic!["data"] as? String
            if (declare.deviceno != nil)
            {
                let defaults = UserDefaults.standard
                defaults.set(declare.deviceno,forKey: deviceNumberKey)
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    //获取用户信息
    open func requestUserInfo (loadingVC:UIViewController? = nil,blockProperty:backBlock? = nil) {
        
        let declare = HDDeclare.shared
        if (declare.api_token != nil) {
            LOG("token:\(String(describing: declare.api_token))")
            
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.getUserInfo(api_token: declare.api_token!), cache: false, showHud: false , success: { (result) in
                
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" 获取用户信息： \(String(describing: dic))")
                declare.loginStatus = Login_Status.kLogin_Status_Login
                let jsonDecoder = JSONDecoder()
                guard let model:UserData = try? jsonDecoder.decode(UserData.self, from: result) else { return }
                declare.saveUserInfo(model: model.data ?? UserModel())
                if (blockProperty != nil)
                {
                    blockProperty!(_:"success")
                }
                
            }) { (errorCode, msg) in
                declare.loginStatus = Login_Status.kLogin_Status_Logout
//                declare.removeUserMessage()
            }
        }
    }
    
    open func sendSmsForCheck(username: String, vc: UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.sendSmsForCheck(username: username), showHud: true, loadingVC: vc , success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" dic ： \(String(describing: dic))")
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
    
    
}
