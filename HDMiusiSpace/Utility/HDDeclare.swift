//
//  HDDeclare.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/23.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

enum Language_Type {
    case   kLanguage_Type_Unknown
    case   kLanguage_Type_Chinese
    case   kLanguage_Type_English
    case   kLanguage_Type_Japanese
    case   kLanguage_Type_Korean
    case   kLanguage_Type_French
    case   kLanguage_Type_Germany
    case   kLanguage_Type_Spanish
}

enum Login_Status {
  case  kLogin_Status_Unknown
  case  kLogin_Status_Login
  case  kLogin_Status_Logout
  case  kLogin_Status_Uncomplete//未补全信息
}

enum Net_Status_Type {
  case  kNet_Status_Unkown
  case  kNet_Status_Wifi
  case  kNet_Status_3G_4G
  case  kNet_Status_Failed
}

//使用 final，不能够被继承
final class HDDeclare: NSObject {
    //单例
    static let shared = HDDeclare()
    //私有化初始方法，防止被外界调用
    private override init() {
        super.init()
        LOG("HDDeclare 初始化了一次")
        //
        self.config()
    }
    
    /****************************************************/
    
    //SSID_Name
    let kWLAN_SSID_Name1 = "SXBWY"
    let kWLAN_SSID_Name2 = "sxbwy"//HD_Software
    //tabBarVC
    public var tabBarVC: HDTabBarVC?
    
    //用户信息
    var deviceno  : String?//机器号
    var api_token : String?//token
    var username  : String?//用户名
    var phone     : String?//手机号
    var nickname  : String?//昵称
    var avatar    : String?//头像
    var sex    : String?//性别
    var email    : String?//性别
    var birthday    : String?//性别
    var province    : String?//性别
    var sign      : String?//签名
    var r_type      : Int64?//签名
    var card_no   : String?//卡号
    var uid       : Int?
    var client_id : String?

    
    //enum 类型
    var languageType    : Language_Type   = .kLanguage_Type_Chinese
    var loginStatus     : Login_Status    = .kLogin_Status_Unknown
    var net_Status_Type : Net_Status_Type = .kNet_Status_Unkown
    
    //保存地图信息
//    public var mapInfoArray : []?
//    // 保持路线信息
//    public var roadInfoArray : []?
    
    //初始化设置
    func config() {
        
    }
    
    open func removeUserMessage() {
        self.api_token = nil
        self.uid = 0
        self.username = nil
        
        let defaults = UserDefaults.standard
        defaults.set(nil,forKey: userInfoKey)
    }
    
    open func saveUserMessage(myDic: NSDictionary) {
        if (myDic.count > 0) {
            let avatarStr = myDic["avatar"] as? String == nil ? self.avatar : myDic["avatar"] as? String
            self.avatar = HDDeclare.IP_Request_Header() + avatarStr!
            self.birthday = myDic["birthday"] as? String == nil ? self.birthday : myDic["birthday"] as? String
            self.email = myDic["email"] as? String == nil ? self.email : myDic["email"] as? String
            self.nickname = myDic["nickname"] as? String == nil ? self.nickname : myDic["nickname"] as? String
            self.phone = myDic["phone"] as? String == nil ? self.phone : myDic["phone"] as? String
            self.phone = myDic["phone"] as? String == nil ? self.phone : myDic["phone"] as? String
            self.province = myDic["province"] as? String == nil ? self.province : myDic["province"] as? String
            self.r_type = myDic["r_type"] as? Int64
            
            if self.r_type == 1
            {
                self.username = self.phone
            }
            else
            {
                self.username = self.email
            }
            
            let sex = myDic["sex"] as? Int64
            if sex == 1
            {
                self.sex = "男"
            }
            else
            {
                self.sex = "女"
            }
        }
    }
    
    open func saveApiTokenMessage(myDic: NSDictionary) {
        if (myDic.count > 0) {
            
            self.username = myDic["username"] as? String == nil ? self.username : myDic["username"] as? String
            self.uid = myDic["uid"] as? Int64 == 0 ? self.uid : myDic["uid"] as? Int
            self.api_token = myDic["api_token"] as? String == nil ? self.api_token : myDic["api_token"] as? String
            if HDDeclare.shared.client_id != nil && self.uid != nil {
//                RootAViewModel.bindDevice(user_number: String(self.uid!), client_id: HDDeclare.shared.client_id!)
            }

            let defaults = UserDefaults.standard
            defaults.set(myDic,forKey: userInfoKey)
        }
    }
}



//SSID
extension HDDeclare {
    func getUsedSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<AnyObject>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                }
            }
        }
        return ssid
    }
    
    func isWLANNet() -> Bool {
        let ssid = getUsedSSID()
        var isWlan = false
        if ssid == kWLAN_SSID_Name1 || ssid == kWLAN_SSID_Name2  {
            isWlan = true
        }
        return isWlan
    }
    
    class func IP_Request_Header() -> String {
        if HDDeclare.shared.isWLANNet() == true {
            return kWLAN_Ip_Address
        }
        return kNet_Ip_Address
    }
    
    
    
    //图片压缩方法
    class func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        
        var maxImageSize = maxImageLenght
        
        
        
        if (maxSize <= 0.0) {
            
            maxSize = 1024.0;
            
        }
        
        if (maxImageSize <= 0.0)  {
            
            maxImageSize = 1024.0;
            
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
            
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        
        return imageData!
        
    }
}














