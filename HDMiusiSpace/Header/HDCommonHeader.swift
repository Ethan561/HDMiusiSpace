//
//  HDCommonHeader.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

//本地数据存储
let deviceNumberKey = "deviceNumberKey"
//let userInfoKey = "userInfoKey"
let userInfoTokenKey = "userInfoTokenKey"

//屏幕高度
let ScreenHeight  : CGFloat = UIScreen.main.bounds.size.height
//屏幕宽度
let ScreenWidth   : CGFloat = UIScreen.main.bounds.size.width
//判断是否iPhone X
let NavigationHeight = (ScreenHeight == 812.0) ? 88 : 64

//馆方地址
let kWLAN_Ip_Address : String  =  "http://192.168.10.158:8667"//内网
//let kNet_Ip_Address  : String  =  "http://www.muspace.net"//外网
let kNet_Ip_Address  : String  =  "http://47.105.71.75"//外网


//kCachePath
let kCachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString

//适配iPhone X
let kNavBarHeight = 44
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height
//TabBarHeight
let kTabBarHeight = kStatusBarHeight > 20 ? 83 : 49
let kBottomHeight = kStatusBarHeight > 20 ? 34 : 0
//NavBarHeight
let kTopHeight:CGFloat =  CGFloat(Float(kNavBarHeight) + Float(kStatusBarHeight))

//kAppDelegate
let kAppDelegate = UIApplication.shared.delegate
//kKeyWindow
let kKeyWindow = UIApplication.shared.keyWindow

let Device_Is_iPhoneX:Bool = (ScreenWidth == 375.0 && ScreenHeight == 812.0 ) ? true : false

let Device_Is_iPhoneSE:Bool = (ScreenWidth == 320.0) ? true : false

let kLogin_Token = "kLogin_Token"

let HengDaSignKey = "HengDa2018@hDg5YhiZ^#vhb7GZ"

//Socket
let DeviceClientId = "DeviceClientId"
let kSocketHost = "192.168.10.158"
let kSocketPort:UInt16 = 9501

let TitleFont = UIFont.init(name: "PingFangSC-Semibold", size: 18)

//let TestToken = "ee683ca5892d31ba175ff8682c25a18e"

//通用色值设置
struct BaseColor {
    /**
     用于重要级段落文字信息 标题信息
     */
    static let blackColor = UIColor.HexColor(0x000000,1.0)
    
    /**
     用于普通级段落文字 引导词
     */
    static let darkGrayColor = UIColor.HexColor(0x343434)
    
    /**
     用于辅助次要文字信息
     */
    static let grayColor = UIColor.HexColor(0x585858)
    
    /**
     用于提示文字
     */
    static let lightGrayColor = UIColor.HexColor(0x9c9c9c)
    
    /**
     用于边框颜色
     */
    static let borderColor = UIColor.HexColor(0xe5e5e5)
    
    /**
     用于界面背景颜色
     */
    static let backGroundColor = UIColor.HexColor(0xefefef)
    
    /**
     用于头部导航颜色(红色)
     */
    static let redColor = UIColor.HexColor(0xE43941)
    
    //
    static let mainRedColor = UIColor.RGBColor(232, 89, 62)

    
}













