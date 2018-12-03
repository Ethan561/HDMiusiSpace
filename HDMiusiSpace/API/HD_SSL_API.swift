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
    
    //---搜索
    //
    case getSearchPlaceholder()
    //请求搜索类型
    case getSearchTypes()
    //开始搜索
    case startSearchWith(keyword: String,skip: Int, take: Int,searchType: Int)
    
    
    //获取城市列表1=全部城市，2=有博物馆部分城市
    case getCityList(type: Int)
    
    //获取城市列表1=全部城市，2=有博物馆部分城市
    case getWorldCityList(kind: Int,type: Int)
    
    //城市搜索
    case searchCityByString(keyname: String,kind: Int)
    
    //展览详情
    case getExhibitionDetail(exhibitionId: Int)
    
    //获取听过未评论列表
    case getHeartedButCommentList(api_token: String,skip: Int,take: Int)
    //获取展览列表
    case getExhibitionCommentList(api_token: String,skip: Int,take: Int,type: Int,exhibitionID: Int)
    
    //发布评论
    case publishCommentWith(api_token: String,exhibitId: Int,star: Int,content: String,imgsPaths:Array<String>)
    //生成画报
    case createPaperWith(api_token: String,commentId: Int)
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
            
        //默认搜索提示
        case .getSearchPlaceholder():
            return "/api/search/default_title"
        //请求搜索类型
        case .getSearchTypes():
            return  "/api/search/search_type"
        //开始搜索
        case .startSearchWith(keyword: _, skip: _, take: _, searchType: _):
            return "/api/search/index"
            
        case .getCityList(type: _):
            return "/api/guide/city_list"
            
        case .getWorldCityList(kind: _, type: _):
            return "/api/guide/country_list"
            
        case .searchCityByString(keyname: _,kind: _):
            return "/api/guide/city_select"
            
        case .getExhibitionDetail(exhibitionId: _):
            return "/api/exhibition/exhibition_info"
            
        case .getHeartedButCommentList(api_token: _,skip: _, take: _):
            return "/api/exhibition/uncomment_exhibition"
        case .getExhibitionCommentList(api_token: _, skip: _, take: _, type: _, exhibitionID: _):
            return "/api/exhibition/comment_list"
            
        case .publishCommentWith(api_token: _, exhibitId: _, star: _, content: _, imgsPaths: _):
            return "/api/exhibition/exhibition_comment"
            
        case .createPaperWith(api_token: _, commentId: _):
            return "/api/exhibition/save_photo"
            
        //...
            
            
        }
    }
    
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .saveSelectedTags(api_token:_,label_id_str: _,deviceno: _),
             .publishCommentWith(api_token: _, exhibitId: _, star: _, content: _, imgsPaths: _):
            
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
            
        //默认搜搜提示信息
        case .getSearchPlaceholder():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //请求搜索类型
        case .getSearchTypes():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        
        //开始搜索
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
            
        case .getExhibitionDetail(exhibitionId: let exhibitionId):
            params = params.merging(["exhibition_id":exhibitionId,"api_token":""], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getHeartedButCommentList(api_token: let api_token,skip: let skip, take: let take):
            params = params.merging(["skip":skip,"take":take,"api_token":api_token], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .publishCommentWith(api_token: let api_token, exhibitId: let exhibitId, star: let star, content: let content, imgsPaths: let imgsPaths):
            params = params.merging(["api_token": api_token, "exhibition_id": exhibitId,"star":star,"content":content,"uoload_img":imgsPaths], uniquingKeysWith: {$1})
//            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": "RootSign"] //图片相关的接口直接用RootSign
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
        case .createPaperWith(api_token: let api_token, commentId: let commentId):
            params = params.merging(["api_token":api_token,"comment_id":commentId], uniquingKeysWith: {$1})
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getExhibitionCommentList(api_token: let api_token, skip: let skip, take: let take, type: let type, exhibitionID: let exhibitionID):
            params = params.merging(["exhibition_id":exhibitionID,"type":type,"skip":skip,"take":take,"api_token":api_token], uniquingKeysWith: {$1})
            
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
