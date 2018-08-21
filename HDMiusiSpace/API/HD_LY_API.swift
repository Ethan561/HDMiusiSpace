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
    //新知首页分类
    case courseCateList()
    
    //新知轮播图
    case getNewKnowledgeBanner()

    //课程详情
    case courseInfo(api_token: String, id: String)
    
    //course - 精选推荐更多/最新/艺术/亲子互动
    case courseBoutique(skip: String, take: String, type: String, cate_id: String)
    
    //精选专题换一换
    case courseTopics()

    //轻听随看列表
    case courseListen(skip: String, take: String, cate_id: String)
    
    //轻听随看详情
    case courseListenDetail(listen_id: String, api_token: String)

    
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
        //新知首页分类
        case .courseCateList():
            return "/api/course/cate_list"

        //新知轮播图
        case .getNewKnowledgeBanner():
            return "/api/course/banner"
        //course - 精选推荐更多/最新/艺术/亲子互动
        case .courseBoutique(skip: _, take: _, type: _, cate_id: _):
            return "/api/course/boutique"
        //课程详情
        case .courseInfo(api_token: _, id: _):
            return "/api/course/courseinfo"
        //精选专题换一换
        case .courseTopics():
            return "/api/course/topics"
        //轻听随看列表
        case .courseListen(skip: _, take: _, cate_id: _):
            return "/api/course/listen"
        //轻听随看详情
        case .courseListenDetail(listen_id: _, api_token: _):
            return "/api/course/detail"
            
            
            
            
            
            
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
            
        //course - 精选推荐更多/最新/艺术/亲子互动
        case .courseBoutique(skip: let skip , take: let take, type: let type, cate_id: let cate_id):
            
            params = params.merging(["skip":skip, "take":take, "type":type, "cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //课程详情
        case .courseInfo(api_token: let api_token , id: let id):
            
            params = params.merging(["api_token":api_token,"id":id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //新知首页分类
        case .courseCateList():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //精选专题换一换
        case .courseTopics():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        //轻听随看列表
        case .courseListen(skip: let skip , take: let take, cate_id: let cate_id):
            params = params.merging(["skip":skip, "take":take,"cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //轻听随看详情
        case .courseListenDetail(listen_id: let listen_id, api_token: let api_token):
            params = params.merging(["listen_id":listen_id,"api_token":api_token], uniquingKeysWith: {$1})
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


