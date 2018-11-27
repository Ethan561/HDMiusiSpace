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
    //我的收藏资讯
    case getMyFavoriteNews(api_token: String, skip:Int, take:Int,type:Int)
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
    case getAboutMuseSpaceInfo()

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
        case .getMyFavoriteNews(api_token: _,  skip: _, take: _, type: _):
            return "/api/favorites/my_news"
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
        case .getAboutMuseSpaceInfo:
            return "/api/users/about"
        }
    }
    
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .thirdBindPhone(params:_):
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
        
        case .getMyFavoriteNews(let apiToken,let page,let size, _):
            params = params.merging(["api_token": apiToken,
                                     "skip":page,
                                     "take":size], uniquingKeysWith: {$1})
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
        case .getAboutMuseSpaceInfo():
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
