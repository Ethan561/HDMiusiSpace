//
//  HD_ZQ_Person_API.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
import Moya

enum HD_ZQ_Person_API {
    
    //我的关注
    case getMyFollow(api_token: String, skip:Int, take:Int,type:Int)
    //用户搜索
    case getMySearch(api_token: String, keywords:String, skip:Int, take:Int)
    //我的收藏资讯
    case getMyFavoriteNews(api_token: String, skip:Int, take:Int,type:Int)
    //我的收藏攻略
    case getMyFavoriteGonglve(api_token: String, skip:Int, take:Int,type:Int)
    //我的收藏精选
    case getMyFavoriteJingxuan(api_token: String, skip:Int, take:Int,type:Int)
    //我的收藏轻听随看
    case getMyFavoriteListens(api_token: String, skip:Int, take:Int,type:Int)
    //我的收藏课程
    case getMyFavoriteCourses(api_token: String, skip:Int, take:Int,type:Int)
    //我的收藏展览
    case getMyFavoriteExhibition(api_token: String, skip:Int, take:Int,type:Int)
    //我的日卡
    case getMyDayCards(api_token: String, skip:Int, take:Int)
    //我的已购买课程
    case getMyBuyCourses(api_token: String, skip:Int, take:Int)
    //我的学习中课程
    case getMyStudyCourses(api_token: String, skip:Int, take:Int)
    //第三方登录绑定手机
    case thirdBindPhone(params:[String:Any])
    //我的导览足迹
    case getMyFootPrint(api_token: String, skip:Int, take:Int)
    //关于缪斯空间
    case getAboutMuseSpaceInfo(versionId:Int)
    //我的动态
    case getMyDynamicList(api_token: String, skip:Int, take:Int)
    //个人中心页面
    case getMyDynamicIndex(api_token: String)
    //他人中心页面
    case getOtherDynamicIndex(api_token: String,toid:Int)
    //绑定第三方账号
    case bindThirdAccount(params:Dictionary<String, Any>)
    //解除绑定第三方账号
    case cancelBindThirdAccount(api_token: String,b_from:String)
    //版本更新检测
    case checkVersion(version_id: Int,device_id:String)
}
extension HD_ZQ_Person_API: TargetType {
    //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    //--- 各个请求的具体路径 ---
    var path: String {
        switch self {
        case .getMyFollow(api_token: _,  skip: _, take: _, type: _):
            return "/api/focus/my_focus"
        case .getMySearch(api_token: _, keywords: _, skip: _, take: _):
            return "/api/focus/select_user"
        case .getMyFavoriteNews(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_news"
        case .getMyFavoriteGonglve(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_news"
        case .getMyFavoriteJingxuan(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_topics"
        case .getMyFavoriteListens(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_listen"
        case .getMyFavoriteCourses(api_token: _,  skip: _, take: _, type: _):
            return "/api/myclass/favorites_list"
        case .getMyFavoriteExhibition(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_exhibition"
        case .getMyDayCards(api_token: _,  skip: _, take: _):
            return "/api/favorites/my_daycard"
        case .getMyBuyCourses(api_token: _,  skip: _, take: _):
            return "/api/myclass/buy_list"
        case .getMyStudyCourses(api_token: _,  skip: _, take: _):
            return "/api/myclass/study_list"
        case .thirdBindPhone(params:_):
            return "/api/users/bind_phone"
        case .getMyFootPrint(api_token: _,  skip: _, take: _):
            return "/api/favorites/my_footprint"
        case .getAboutMuseSpaceInfo(versionId:_):
            return "/api/users/about"
        case .getMyDynamicList(api_token: _,  skip: _, take: _):
            return "/api/dynamic/dynamic_list"
        case .getMyDynamicIndex(api_token: _):
            return "/api/dynamic/index"
        case .getOtherDynamicIndex(api_token: _,toid:_):
            return "/api/dynamic/user_index"
        case .bindThirdAccount(_):
            return "/api/users/bind_account_number"
        case .cancelBindThirdAccount(_,_):
            return "/api/users/unbind_account_number"
        case .checkVersion(_,_):
            return "/api/version/check_version"
        }
    }
    
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .thirdBindPhone(params:_):
             return  .post
        case .bindThirdAccount(params:_):
             return  .post
        case .cancelBindThirdAccount(_,_):
            return  .post

        default:
            return .get
        }
        
    }
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = ["p":"i"]
        
        switch self {
        case .getMyFollow(let apiToken,let page,let size,let type):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "type":type], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getMySearch(api_token: let apiToken, keywords: let keywords, skip: let page, take: let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "keywords":keywords], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        
        case .getMyFavoriteNews(let apiToken,let page,let size, _):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getMyFavoriteGonglve(let apiToken,let page,let size,let type):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "type":type], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyFavoriteListens(let apiToken,let page,let size,let type):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "type":type], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyFavoriteJingxuan(let apiToken,let page,let size,let type):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "type":type], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyFavoriteCourses(let apiToken,let page,let size,let type):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size,
                                     "type":type], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyFavoriteExhibition(let apiToken,let page,let size, _):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyDayCards(let apiToken,let page,let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyBuyCourses(let apiToken,let page,let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyStudyCourses(let apiToken,let page,let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .thirdBindPhone(params: let paramsTemp):
            params = params.merging(paramsTemp, uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getMyFootPrint(let apiToken,let page,let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getAboutMuseSpaceInfo(let versionId):
            params = params.merging(["version_id": versionId], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyDynamicList(let apiToken,let page,let size):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getMyDynamicIndex(let apiToken):
            params = params.merging(["api_token": apiToken], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .getOtherDynamicIndex(let apiToken,let toid):
            params = params.merging(["api_token": apiToken,
                                     "toid":toid], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        case .bindThirdAccount(params: let paramsTemp):
            params = params.merging(paramsTemp, uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .cancelBindThirdAccount(let apiToken,let b_from):
            params = params.merging(["api_token": apiToken,
                                     "b_from":b_from], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .checkVersion(let version_id,let device_id):
            params = params.merging(["version_id": version_id,
                                     "device_id":device_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        default:
            return .requestPlain//无参数
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    //--- 请求头 ---
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
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
