//
//  HD_LY_API.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import Moya

enum HD_LY_API {
    //新知首页
    case getNewKnowledgeHomePage()
    //新知轮播图
    case getNewKnowledgeBanner()
    
}

extension HD_LY_API: TargetType {
    
    //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
            
        //首页展厅列表接口
        case .getNewKnowledgeHomePage():
            return "/api/course/index"
        //新知轮播图
        case .getNewKnowledgeBanner():
            return "/api/course/banner"
      
            
        }
        
    }
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
//        case .uploadTimeLineImg(img: _, api_token: _, type: _),
//            return .post
        default:
            return .get
        }
    }
    
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = ["p":"i"]
        
        switch self {
        //展厅列表
        case .getNewKnowledgeHomePage():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })

        //新知轮播图
        case .getNewKnowledgeBanner():
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


