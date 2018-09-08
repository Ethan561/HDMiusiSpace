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
        UMSocialManager.default().umSocialAppkey = "5b2b4712a40fa323f9000015"
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wx6103d36ef011b95c", appSecret: "ae4c79fa510102a0cb6f6394804fb0d0", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.QQ, appKey: "101479719", appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.sina, appKey: "4147125496", appSecret: "dd9b779609591e5901c1f649fdfdd7b0", redirectURL: "http://sns.whalecloud.com/sina2/callback")
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

