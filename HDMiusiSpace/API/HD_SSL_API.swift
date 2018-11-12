//
//  HD_SSL_API.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/1.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation
import Moya

enum HD_SSL_API {
    //获取启动标签列表
    case getLaunchTagList(api_token: String)
    //保存标签
    case saveSelectedTags(api_token: String,label_id_str: String,deviceno: String)
    //请求搜索类型
    case getSearchTypes()
    //搜索
    case startSearchWith(keyword: String,skip: Int, take: Int,searchType: Int)
    
    //获取城市列表1=全部城市，2=有博物馆部分城市
    case getCityList(type: Int)
    
    //获取城市列表1=全部城市，2=有博物馆部分城市
    case getWorldCityList(kind: Int,type: Int)
    
    //城市搜索
    case searchCityByString(keyname: String,kind: Int)
}
extension HD_SSL_API: TargetType {
    //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
            
        //获取启动标签列表
        case .getLaunchTagList(api_token: _):
            return "/api/index/label"
            
        //保存标签
        case .saveSelectedTags(api_token: _,label_id_str: _,deviceno: _):
            return "/api/index/labelsave"
            
        //请求搜索类型
        case .getSearchTypes():
            return  "/api/search/search_type"
            
            //搜索
        case .startSearchWith(keyword: _, skip: _, take: _, searchType: _):
            return "/api/search/index"
            
        case .getCityList(type: _):
            return "/api/guide/city_list"
            
        case .getWorldCityList(kind: _, type: _):
            return "/api/guide/country_list"
            
        case .searchCityByString(keyname: _,kind: _):
            return "/api/guide/city_select"
        //...
            
            
        }
    }
    
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .saveSelectedTags(api_token:_,label_id_str: _,deviceno: _):
            
            return  .post
            
        default:
            return .get
        }
    }
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = ["p":"i"]
        
        switch self {
        
        //获取启动标签
        case .getLaunchTagList(api_token: let api_token):
            params = params.merging(["api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //保存启动标签
        case .saveSelectedTags(api_token: let api_token, label_id_str: let label_id_str, deviceno: let deviceno):
            params = params.merging(["api_token": api_token,
                                     "label_id_str":label_id_str,
                                     "deviceno":deviceno], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //请求搜索类型
        case .getSearchTypes():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        
        //搜索
        case .startSearchWith(keyword: let keyword, skip: let skip, take: let take, searchType: let searchType):
            params = params.merging(["keyword": keyword,
                                     "skip":skip,
                                     "take":take,
                                     "type":searchType], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getCityList(type: let type):
            params = params.merging(["kind":type], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getWorldCityList(kind: let kind, type: let type):
            params = params.merging(["kind":kind,"type":type], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .searchCityByString(keyname: let keyname,kind: let kind):
            params = params.merging(["keyname":keyname,"kind":kind], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //...
            
            
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
