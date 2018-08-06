//
//  HD_HSP_API.swift
//  HDNanHaiMuseum
//
//  Created by HDHaoShaoPeng on 2018/6/8.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation
import Moya

enum  HD_HSP_API {
    
    //获取验证码接口
    case getYanZhengMa(phoneOremail: String ,myType: String)
    
    case getYanZhengIsRight(phoneOremail:String ,smscode: String)
    
    //地图展品接口
    case get_exhibit_list_by_map(floor_num: String)
    //服务设施
    case get_facility_by_map(floor_num: String)
    //展厅排序
    case exhibit_room_order(theme_id: String)
    //热度排序
    case exhibit_order(theme_id: String)
    //距离排序
    case distance_order(major: Array<String>)
    //位置上传
    case upload_positons(deviceno: String, major: String)
    
    //上传视频
    case uploadVideo(video: Data, api_token: String)
    
    //注册：
    case register(username: String, smscode:String , password: String)
    //登录
    case usersLogin(username: String, password: String)
    
    //获取用户信息
    case getUserInfo(api_token: String)
    
    case getZuJiInfo(api_token: String,language: String, skip: Int32,take: Int32)
    
    case getDianZanInfo(api_token: String,language: String, skip: Int32,take: Int32)
    
    case getPingLunInfo(api_token: String,language: String, skip: Int32,take: Int32)
    
    //退出登录
    case userLogout(api_token: String)
    
    //头像上传
    case upload_avatar(Data, api_token: String)
    
    //昵称修改
    case modifyNickname(api_token: String, nickname: String)
    
    case modifyPhone(api_token: String, phone: String)
    
    case modifyEmail(api_token: String, email: String)
    
    case uploadArticle(api_token:String ,title:String ,cover:String ,article_content:String)
    
    case modifyProvince(api_token: String, province: String)
    
    case modityBirthday(api_token: String, birthday: String)
    
    case modifySex(api_token: String, sex: Int32)
    
    case changeSecrete(username: String, password_old: String ,password: String,password_confirmation: String)
    
    case forgetChangeSecrete(username: String,password: String,password_confirmation: String)
    
    //三方登录
    case register_bind(params:Dictionary<String, Any>)
    
    //文创产品轮播图
    case get_wenchuang_banner
    
    case get_deviceNumber
    
    case get_wenChuangDetail
    
    case get_wenChuangList
    
    case get_xuanJiaoData
    
    case get_YuYueAdress(uid: Int)
    
    case get_zhiNan
    
    case get_provinceData
    
    case get_mineReserve(uid: Int,reserve_id: String)
    
    //博物馆详情
    case get_bwgXiangQing(language: String)
    
    //文创产品列表
    case getGoodsList(api_token: String?)
    
    //文创详情分类列表
    case get_wenchuang_list_by_class(api_token: String?, first_class: String, second_class:String)
}



extension HD_HSP_API: TargetType {
    
    //--- 服务器地址 ---
    var baseURL: URL {
        
        switch self {
        case .get_YuYueAdress(uid: _),
             .get_mineReserve(uid: _,reserve_id:_):
            return URL.init(string : kNet_Ip_YuYue)!
        default:
            return URL.init(string: HDDeclare.IP_Request_Header())!
        }
        
        
    }
    
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
        //首页主界面接口
        case .getYanZhengMa(phoneOremail: _ ,myType:_):
            return "/api/send_vcode"
            
        case .getYanZhengIsRight(phoneOremail: _, smscode: _):
            return "api/users/check_vcode"
            
            
            
        case .uploadVideo(video: _, api_token: _):
            return "/api/pai_uploadimg"
            
            
            
        //地图点位数据
        case .get_exhibit_list_by_map(floor_num: _):
            return "/api/map/get_exhibit_list_by_map"
        //服务设施
        case .get_facility_by_map(floor_num: _):
            return "/api/map/get_facility_by_map"
        //展厅排序
        case .exhibit_room_order(_):
            return "/api/exhibit/exhibit_room_order"
        //热度排序
        case .exhibit_order(theme_id: _):
            return "/api/exhibit/exhibit_order"
        //距离排序
        case .distance_order(major: _):
            return "/api/exhibit/distance_order"
        //位置上传
        case .upload_positons(deviceno: _, major: _):
            return "/api/map/positions"
        //注册：
        case .register(username: _, smscode: _ , password: _):
            return "/api/users/register"
        //获取用户信息：
        case .getUserInfo:
            return "/api/users/info"
            
        case .getZuJiInfo:
            return "/api/my_footed"
            
        case .getDianZanInfo:
            return "/api/my_liked"
            
        case .getPingLunInfo:
            return "/api/my_comment"
            
        //登录
        case .usersLogin:
            return "/api/users/login"
        case .userLogout(api_token: _):
            return "/api/users/logout"
            
        //头像上传
        case .upload_avatar(_, api_token: _):
            return "/api/users/avatar"
            
        //昵称修改
        case .modifyNickname(api_token: _, nickname: _):
            return "api/users/nickname"
        
        case .modifyPhone(api_token: _, phone: _):
            return "api/users/phone"
            
        case .modifyEmail(api_token: _, email: _):
            return "api/users/email"
        
        case .uploadArticle(api_token: _, title: _, cover: _, article_content: _):
            return "api/article_publish"
            
        case .modifyProvince(api_token: _, province: _):
            return "api/users/province"
            
        case .modityBirthday(api_token: _, birthday: _):
            return "api/users/birthday"
            
        case .modifySex(api_token: _, sex: _):
            return "api/users/sex"
            
        case .changeSecrete(username: _, password_old: _,password: _,password_confirmation: _):
            return "api/users/password"
            
        case .forgetChangeSecrete(username: _, password: _, password_confirmation: _):
            return "api/users/password"
        
        //三方登录
        case .register_bind(params: _):
            return "/api/users/register_bind"
            
        //文创产品轮播图
        case .get_wenchuang_banner:
            return "/api/wenchuang/get_wenchuang_banner"
            
        case .get_deviceNumber:
            return "/api/request_deviceno"
    
        case .get_wenChuangDetail:
            return "/api/xl_detail_a"
            
        case .get_wenChuangList:
            return "/api/xl_list"
        
            
        case .get_xuanJiaoData:
            return "/api/xjhd_detail"
            
        case .get_YuYueAdress:
            return "/api/online_reserve_link"
            
        case .get_zhiNan:
            return "/api/cgzn"
            
        case .get_mineReserve(uid: _,reserve_id: _):
            return "/api/reserve_detail"
            
        case .get_provinceData:
            return "/api/province"
            
        case .get_bwgXiangQing(language: _):
            return "/api/intro"
            
        //文创产品列表
        case .getGoodsList:
            return "/api/wenchuang/get_class"
            
        //文创详情分类列表
        case .get_wenchuang_list_by_class(_, _, _):
            return "/api/wenchuang/get_wenchuang_list_by_class"
        }
    }
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .getYanZhengMa(phoneOremail: _ ,myType: _),
             .uploadVideo(video: _, api_token: _),
             .getYanZhengIsRight(phoneOremail: _, smscode: _),
             .upload_positons,
             .register,
             .usersLogin(username: _, password: _),
             .upload_avatar(_, api_token: _),
             .modifyNickname(api_token: _, nickname: _),
             .modifyPhone(api_token: _, phone: _),
             .modifyEmail(api_token: _, email: _),
             .uploadArticle(api_token: _, title: _, cover: _, article_content: _),
             .modifyProvince(api_token: _, province: _),
             .modityBirthday(api_token: _, birthday: _),
             .modifySex(api_token: _, sex: _),
             .changeSecrete(username: _, password_old: _,password: _,password_confirmation: _),
             .forgetChangeSecrete(username: _, password: _, password_confirmation: _),
             .register_bind(params: _):
            return .post
        default:
            return .get
        }
    }
    
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case .getYanZhengMa(phoneOremail: let phoneOremail ,myType: let myType):
            params = ["p":"i",
                      "phoneOremail": phoneOremail,"type": myType]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .getYanZhengIsRight(phoneOremail: let phoneOremail, smscode: let smscode):
            params = ["p":"i",
                      "phoneOremail": phoneOremail,
                      "smscode":smscode]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .get_exhibit_list_by_map(floor_num: let floor):
            params = ["p":"i",
                      "floor_num": floor]
        case .get_facility_by_map(floor_num: let floor):
            params = ["p":"i",
                      "floor_num": floor]
            
        case .upload_positons(deviceno: let deviceno, major: let major):
            params = ["p":"i",
                      "deviceno": deviceno,
                      "major": major,
            ]
            
        case .exhibit_room_order(theme_id: let theme_id), .exhibit_order(theme_id: let theme_id):
            params = ["p":"i",
                      "theme_id": theme_id]
            
        case .distance_order(major: let majorArr):
            params = ["p":"i",
                      "major": majorArr]
            
        case .register(username: let username, smscode: let smscode , password: let password):
            params = ["p":"i",
                      "username": username,
                      "password": password,
                      "smscode": smscode,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .getUserInfo(api_token: let token):
            params = ["p":"i",
                      "api_token": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.methodDependent)
            
        case .getZuJiInfo(api_token: let token,language: let language, skip: let skip, take: let take):
            params = ["p":"i",
                      "api_token": token,
                      "language": language,
                      "skip":skip,
                      "take": take]
            return .requestParameters(parameters: params, encoding: URLEncoding.methodDependent)
            
        case .getDianZanInfo(api_token: let token,language: let language, skip: let skip, take: let take):
            params = ["p":"i",
                      "api_token": token,
                      "language": language,
                      "skip":skip,
                      "take": take]
            return .requestParameters(parameters: params, encoding: URLEncoding.methodDependent)
            
        case .getPingLunInfo(api_token: let token,language: let language, skip: let skip, take: let take):
            params = ["p":"i",
                      "api_token": token,
                      "language": language,
                      "skip":skip,
                      "take": take]
            return .requestParameters(parameters: params, encoding: URLEncoding.methodDependent)

        case .userLogout(api_token: let token):
            params = ["p":"i",
                      "api_token": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.methodDependent)
            
        case  .usersLogin(username: let username, password: let password ):
            params = ["p":"i",
                      "username": username,
                      "password": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //上传头像
        case   .upload_avatar(let data, api_token: let api_token):
            let imgData = MultipartFormData(provider: .data(data), name: "avatar", fileName: "avatar.png", mimeType: "image/png")
            let multipartData = [imgData]
            let urlParameters = ["p":"i","api_token": api_token]
            
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            
        case .modifyNickname(api_token: let token, nickname: let name):
            params = ["p":"i",
                      "api_token": token,
                      "nickname" : name
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
           
        case .modifyPhone(api_token: let token, phone: let phone):
            params = ["p":"i",
                      "api_token": token,
                      "phone" : phone
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        case .modifyEmail(api_token: let token, email: let email):
            params = ["p":"i",
                      "api_token": token,
                      "email" : email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        
        case .uploadArticle(api_token: let token, title: let title, cover: let cover, article_content: let content):
            params = ["p":"i", "api_token":token, "title":title, "cover":cover, "article_content":content]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .modifyProvince(api_token: let token, province: let province):
            params = ["p":"i",
                      "api_token": token,
                      "province" : province
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .modityBirthday(api_token: let token, birthday: let birthday):
            params = ["p":"i",
                      "api_token": token,
                      "birthday" : birthday
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .modifySex(api_token: let token, sex: let sex):
            params = ["p":"i",
                      "api_token": token,
                      "sex" : sex
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .changeSecrete(username: let username, password_old: let password_old, password: let password, password_confirmation: let password_confirmation):
            params = ["p":"i",
                      "username": username,
                      "password_old" : password_old,
                      "password": password,
                      "password_confirmation" : password_confirmation]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .forgetChangeSecrete(username: let username, password: let password, password_confirmation: let password_confirmation):
            params = ["p":"i",
                      "username": username,
                      "password": password,
                      "password_confirmation" : password_confirmation]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .uploadVideo(video: let videoData, api_token: let api_token):
            
            let formatter:DateFormatter =  DateFormatter.init()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName:String = formatter.string(from: Date.init()) + ".mp4"
            
            let uploadData = MultipartFormData(provider: .data(videoData), name: "img_file", fileName: fileName, mimeType: "video/mp4")
            let multipartData = [uploadData]
            let urlParameters = ["p":"i", "api_token": api_token, "type": "4"]
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            
        //三方登录
        case .register_bind(params: let par):
            params = par
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //文创产品轮播图
        case .get_wenchuang_banner:
            params = ["p":"i"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_deviceNumber:
            params = ["p":"i"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_wenChuangDetail:
            params = ["p":"i"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_wenChuangList:
            params = ["p":"i"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_xuanJiaoData:
            params = ["p":"i","id":"1"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
        case .get_YuYueAdress(uid: let uid):
            params = ["p":"i","uid":uid]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_zhiNan:
            params = ["p":"i","language":"1"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_provinceData:
            params = ["p":"i"]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_mineReserve(uid: let uid,reserve_id: let reserve_id):
            params = ["uid":uid,"reserve_id":reserve_id]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)

        case .get_bwgXiangQing(language:let language):
            params = ["p":"i","language":language]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        //文创产品列表
        case .getGoodsList(api_token: let token?):
            params = ["p":"i", "api_token": token]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .get_wenchuang_list_by_class(api_token: let token?, first_class: let first, second_class: let second):
            params = ["p":"i", "api_token": token, "first_class":first,"second_class":second]
            
        default:
            return .requestPlain//无参数
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
        
    }
    
    //--- 请求头 ---
    var headers: [String : String]? {
        return ["Accept":"application/json"]//"Content-Type":"application/json",
    }
    
    //--- 是否执行Alamofire验证 ---
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
}

