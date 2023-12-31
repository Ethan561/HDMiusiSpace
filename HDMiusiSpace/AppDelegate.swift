//
//  AppDelegate.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import SwiftyStoreKit


//极光推送是否是发布模式
let isProduction = false
let HDJPushAliasKey = "HDJPushAliasKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var myJPushAlias: String?
    
    //当前显示的nav
    var navigationController : UINavigationController? {
        get {
            var parent: UIViewController?
            if let window = UIApplication.shared.delegate?.window,let rootVC = window?.rootViewController {
                parent = rootVC
                while (parent?.presentedViewController != nil) {
                    parent = parent?.presentedViewController!
                }
                
                if let tabbar = parent as? UITabBarController ,let nav = tabbar.selectedViewController as? UINavigationController {
                    return nav
                }else if let nav = parent as? UINavigationController {
                    return nav
                }
            }
            return nil
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Bugly.start(withAppId: "c72887a81c")
        myJPushAlias = HDLY_UserModel.shared.getDeviceNum()
        
        let IFLYAPPID = "appid=5c33efb2"
        IFlySpeechUtility.createUtility(IFLYAPPID)
        
        localDataInit()
        configUSharePlatforms()
        setRootVC()
        
        //推送代码
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2 //badge,sound,alert
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //需要IDFA 功能，定向投放广告功能
        //let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "80316ddeba93bff119c5fd1a", channel: "App Store", apsForProduction: isProduction, advertisingIdentifier: nil)
        
        //设置推送标签和别名
        NotificationCenter.default.addObserver(self, selector: #selector(jpushLoginSuccessNoti(_:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(jpushNetworkDidCloseNoti(_:)), name: NSNotification.Name.jpfNetworkDidClose, object: nil)
//        //用户登录成功绑定uid
//        NotificationCenter.default.addObserver(self, selector: #selector(jpushLoginSuccessNoti(_:)), name: NSNotification.Name.init("SetJpushAliasWithUID"), object: nil)
        
        //百度统计埋点方法，样例
        /*
         *事件id：0001
         *事件描述：“单机一下按钮”
         */
        BaiduMobStat.default()?.logEvent("0001", eventLabel: "单击一下按钮")
        
        setupIAP()
        do {
            let session:AVAudioSession = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayback)
            try session.setActive(true)
        }
        catch let error {
            print("\(error)")
        }
        ZFReachabilityManager.shared().startMonitoring()

        return true
    }
    
    
    func setupIAP() {
        //在启动时添加应用程序的观察者 可确保在应用程序的所有启动过程中都会持续，从而允许您的应用程序 接收所有支付队列通知。如果此时有任何待处理的事务，将触发block，以便可以更新应用程序状态和UI。如果没有待处理的事务，则不会调用
        
        //掉单恢复内购处理
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("====掉单恢复内购处理=====\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                    
                    
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    func setRootVC() {
        
        let JSONString = UserDefaults.standard.object(forKey: "saveTags") as? String
        
        if "1" == JSONString {

            //2、跳转vc
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HDTabBarVC") as! HDTabBarVC

            self.window?.rootViewController = vc;

        }
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
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    //后台进前台
    func applicationDidEnterBackground(_ application: UIApplication) {
        //销毁通知红点
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

//MARK:--推送代理
extension AppDelegate : JPUSHRegisterDelegate {
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
            LOG("通知消息:\(userInfo)")
            LOG("通知消息title:\(userInfo["title"])")
            LOG("通知消息content:\(userInfo["content"])")
            
            guard let nav = navigationController else {
                return
            }
            
            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SystemMsgVC") as! HDLY_SystemMsgVC
            //前台弹窗提醒
            if UIApplication.shared.applicationState == .active  {
                let alertController = UIAlertController(title: "系统消息",
                    message: "通知消息content:\(userInfo["content"])", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                    action in
                    vc.hidesBottomBarWhenPushed = true
                    nav.pushViewController(vc, animated: true)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                nav.visibleViewController?.present(alertController, animated: true, completion: nil)
            }
            
            //后台通知消息点击查看
            if UIApplication.shared.applicationState == .background  {
                
                
                nav.pushViewController(vc, animated: true)
            }
            
        }
        // 系统要求执行这个方法
        completionHandler()
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        
        LOG("==== didReceiveRemoteNotification ==== :\(userInfo)")
        guard let nav = navigationController else {
            return
        }
        
        let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SystemMsgVC") as! HDLY_SystemMsgVC
        vc.hidesBottomBarWhenPushed = true

        //前台弹窗提醒
        if UIApplication.shared.applicationState == .active  {
            let alertController = UIAlertController(title: "系统消息",
                                                    message: "通知消息content:\(userInfo["content"])", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                action in
                nav.pushViewController(vc, animated: true)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            nav.visibleViewController?.present(alertController, animated: true, completion: nil)
        }
        
        //后台通知消息点击查看
        if UIApplication.shared.applicationState == .background  {
            
            
            nav.pushViewController(vc, animated: true)
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    //系统获取Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    //获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    //noti
    @objc func jpushLoginSuccessNoti(_ noti: Notification) {
        //标签分组
        JPUSHService.setTags(["phone"], completion: nil, seq: 1)
        //用户别名(设置唯一标识)
        guard let alias =  myJPushAlias else {
            return
        }
        let signKey1:String = MD5(alias)+HengDaSignKey
        JPUSHService.setAlias(MD5(signKey1), completion: { (iResCode, iAlias, seq) in
            print("=== setAliasSuccess,\(MD5(signKey1)) . completion,\(iResCode),\(iAlias),\(seq)")
        }, seq: 0)
        
    }
    
    @objc func jpushNetworkDidCloseNoti(_ noti: Notification) {
        JPUSHService.deleteTags(["phone"], completion: nil, seq: 0)
        JPUSHService.deleteAlias({ (iResCode, iAlias, seq) in
            print("退出注销别名 \(iResCode),\(String(describing: iAlias)),\(seq)")
        }, seq: 0)
        
    }
    
    
    
    
    
}


