//
//  AppDelegate.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Bugly.start(withAppId: "c72887a81c")
        
        localDataInit()
        configUSharePlatforms()
        
        return true
    }
    
    func configUSharePlatforms()  {
        // 友盟
        UMSocialManager.default().umSocialAppkey = "5b6d5e77a40fa3255f0000d3"
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx9ca30fef57bc6b2c", appSecret: "4e9f7919fc56d67cfab5f8623e955e01", redirectURL: "http://www.wenbozaixian.com")
        UMSocialManager.default().setPlaform(.QQ, appKey: "1107710751", appSecret: "QkR5CsAp4zF8Vv6a", redirectURL: "http://www.wenbozaixian.com")
        UMSocialManager.default().setPlaform(.sina, appKey: "1098762141", appSecret: "00004c4f1dc6241353460db57d556475", redirectURL: "http://www.wenbozaixian.com")
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result:Bool = UMSocialManager.default().handleOpen(url)
        
        return result
    }
    
    func localDataInit()  {
        
        let declare:HDDeclare = HDDeclare.shared
        declare.loginStatus = Login_Status.kLogin_Status_Unknown
        
        let defaults = UserDefaults.standard
        let token:String? = defaults.value(forKey: userInfoTokenKey) as? String
        if (token != nil) {
            declare.api_token = token
            HDLY_UserModel.shared.requestUserInfo()
        }
        let deviceNum:String? = defaults.string(forKey: deviceNumberKey)
        if (deviceNum != nil) {
            declare.deviceno = deviceNum
        } else {
            HDLY_UserModel.shared.requestDeviceNumber()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

