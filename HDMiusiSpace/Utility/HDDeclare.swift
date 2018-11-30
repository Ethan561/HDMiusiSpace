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
    var gender    : String?//性别
    var email    : String?//性别
    var birthday    : String?//性别
    var province    : String?//性别
    var sign      : String?//签名
    var r_type      : Int64?//签名
    var card_no   : String?//卡号
    var uid       : Int?
    var client_id : String?
    var isVip : Int?   //微博昵称
    var isBindWechat : Int?  //是否绑定微信
    var isBindWeibo : Int?   //是否绑定微博
    var isBindQQ : Int?  //是否绑定QQ
    var wechatName : String?  //微信昵称
    var weiboName : String?   //微博昵称
    var QQName : String?  //QQ昵称
    var profile : String?   //个人简介
    var labStr : [String]?   //兴趣标签
    var user = UserModel()
    //enum 类型
    var languageType    : Language_Type   = .kLanguage_Type_Chinese
    var loginStatus     : Login_Status    = .kLogin_Status_Unknown
    var net_Status_Type : Net_Status_Type = .kNet_Status_Unkown
    
    //标签
    var allTagsArray : [HDSSL_TagData]? //所有标签数据
    var selectedTagArray : [HDSSL_Tag]? //已选标签数组
    
    //保存地图信息
//    public var mapInfoArray : []?
//    // 保持路线信息
//    public var roadInfoArray : []?
    
    //初始化设置
    func config() {
        
    }
    
    public func removeUserMessage() {
        self.api_token = nil
        self.uid = 0
        self.username = nil
        
        let defaults = UserDefaults.standard
        defaults.set(nil,forKey: userInfoTokenKey)
    }
    
    public func saveUserMessage(myDic: NSDictionary) {
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
                self.gender = "男"
            }
            else
            {
                self.gender = "女"
            }
        }
    }
    
    public func saveApiTokenMessage(myDic: NSDictionary) {
        if (myDic.count > 0) {
            
            self.username = myDic["username"] as? String == nil ? self.username : myDic["username"] as? String
            self.uid = myDic["uid"] as? Int64 == 0 ? self.uid : myDic["uid"] as? Int
            self.api_token = myDic["api_token"] as? String == nil ? self.api_token : myDic["api_token"] as? String
            if HDDeclare.shared.client_id != nil && self.uid != nil {
//                RootAViewModel.bindDevice(user_number: String(self.uid!), client_id: HDDeclare.shared.client_id!)
            }

//            let defaults = UserDefaults.standard
//            defaults.set(myDic,forKey: userInfoKey)
        }
    }
    
    public func saveUserInfo(model:UserModel) {
        self.user = model
        self.isVip = self.user.is_vip
        self.isBindWeibo = self.user.bind_wb
        self.isBindWechat = self.user.bind_wx
        self.weiboName = self.user.wb_nickname
        self.wechatName = self.user.wx_nickname
        self.isBindQQ = self.user.bind_qq
        self.QQName = self.user.qq_nickname
        self.profile = self.user.profile
        self.labStr = self.user.label_str
        self.avatar = self.user.avatar
        self.nickname = self.user.nickname
        LOG(self.user.label_str)
        if self.user.sex == 1 {
            self.gender = "男"
        }
        if self.user.sex == 2 {
            self.gender = "女"
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
    
    
    //get Sign Key 
    class func getSignKey(_ params: Dictionary<String, Any>) -> String {
        var signKey = ""
        let paramsSort = params.sorted { (str1, str2) -> Bool in
            return str1.0 < str2.0
        }
        for (key,value) in paramsSort {
            let tempStr = "\(key)=\(value)&"
            signKey += tempStr
        }
//        LOG("signKey:\(signKey)")
        signKey.removeLast()
//        LOG("signKey_removeLast:\(signKey)")
        let signKey1:String = MD5(signKey)+HengDaSignKey
        return MD5(signKey1)
    }
    /*
     var exc = "Steve"
     exc.uppercased()  //转大写
     exc.lowercased()  // 转小写
     */
}

extension HDDeclare {
    class func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
}

//MARK: 图片处理
extension HDDeclare {
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
        
        var imageData:Data? = UIImageJPEGRepresentation(newImage!, 1.0) //UIImageJPEGRepresentation(newImage!, 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat(((imageData?.count)!)) / 1024.0;
        
        //调整大小
        
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = UIImageJPEGRepresentation(newImage!, CGFloat(resizeRate))
                //newImage?.jpegData(compressionQuality: CGFloat(resizeRate))
            
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        
        return imageData!
        
    }
}











