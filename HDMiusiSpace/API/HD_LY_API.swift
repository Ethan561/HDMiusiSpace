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

    //课程导读详情
    case courseInfo(api_token: String, id: String)
    
    //course - 精选推荐更多/最新/艺术/亲子互动
    case courseBoutique(skip: String, take: String, type: String, cate_id: String)
    
    //精选专题换一换
    case courseTopics()
    
    //轻听随看列表
    case courseListen(skip: String, take: String, cate_id: String)
    
    //轻听随看详情
    case courseListenDetail(listen_id: String, api_token: String)

    //comment - 提交评论
    case commentDocomment(api_token:String, comment: String, id: String, return_id: String, cate_id: String)

    //like - 点赞/取消点赞   (用户不登录可以给资讯点赞，cate_id=2且未登录时必须上传deviceno;cate_id!=2时必须登录才能点赞)
    case doLikeRequest( id: String, cate_id: String,api_token:String, deviceno: String)
    
    //favorites - 收藏/取消
    case doFavoriteRequest( id: String, cate_id: String,api_token:String)

    //focus - 关注/取消
    case doFocusRequest( id: String, cate_id: String,api_token:String)
    
    //课程详情
    case courseDetailInfo(api_token: String, id: String)
    
    //课程章节
    case courseChapterInfo(api_token: String, id: String)

    //获得课程购买信息
    case courseBuyInfo(api_token: String, id: String)
    
    //留言发布
    case courseLeaveMessage(api_token: String, id: String, content: String)

    //留言列表
    case courseMessageList(skip: String, take: String, api_token: String, id: String)

    //问题提交
    case courseQuestion(api_token: String, id: String,title: String, content: String)

    //问题列表
    case courseQuestionList(skip: String, take: String, api_token: String, id: String)

    //注册：
    case register(username: String, smscode:String )
    //登录
    case usersLogin(username: String, password: String,smscode: String, deviceno: String)
    //获取用户信息
    case getUserInfo(api_token: String)
    //退出登录
    case userLogout(api_token: String)
    //昵称修改
    case modifyNickname(api_token: String, nickname: String)
    //昵称修改
    case modifyAvatar(api_token: String, avatar: Data)
    //获取机器号
    case requestDeviceno()
    //发送短信或邮箱验证码
    case sendSmsForCheck(username: String)
    
    //精选专题详情
    case courseTopicsInfo(api_token: String, id: String)
    
    
    
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
        //课程导读详情
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
            
        //comment - 提交评论
        case .commentDocomment(api_token:_,comment: _, id: _, return_id: _, cate_id: _):
            return "/api/comment/docomment"
            
        //like - 点赞/取消点赞   (用户不登录可以给资讯点赞，cate_id=2且未登录时必须上传deviceno;cate_id!=2时必须登录才能点赞)
        case .doLikeRequest( id: _, cate_id: _,api_token:_, deviceno: _):
            return "/api/like/do_like"
            
        //favorites - 收藏/取消
        case .doFavoriteRequest( id: _, cate_id: _,api_token:_):
            return "/api/favorites/do_favorite"
            
        //focus - 关注/取消
        case .doFocusRequest( id: _, cate_id: _,api_token:_):
            return "/api/focus/dofocus"
            
        //课程详情
        case .courseDetailInfo(api_token: _, id: _):
            return "/api/course/course_info"
            
        //课程章节
        case .courseChapterInfo(api_token: _, id: _):
            return "/api/course/chapter"
            
        //获得课程购买信息
        case .courseBuyInfo(api_token:  _, id:  _):
            return "/api/course/get_buy_info"
            
        //留言发布
        case .courseLeaveMessage(api_token: _, id: _, content: _):
            return "/api/course/message"
            
        //留言列表
        case .courseMessageList(skip: _, take: _, api_token: _, id: _):
            return "/api/course/messagelist"
            
        //问题提交
        case .courseQuestion(api_token: _, id: _,title: _, content: _):
            return "/api/course/question"
            
        //问题列表
        case .courseQuestionList(skip: _, take: _, api_token: _, id: _):
            return "/api/course/questionlist"
            
        //注册：
        case .register(username: _, smscode:_ ):
            return "/api/users/register"
        //登录
        case .usersLogin(username: _, password: _,smscode: _, deviceno: _):
            return "/api/users/login"
        //获取用户信息
        case .getUserInfo(api_token: _):
            return "/api/users/info"
        //退出登录
        case .userLogout(api_token: _):
            return "/api/users/logout"
        //昵称修改
        case .modifyNickname(api_token: _, nickname: _):
            return "/api/users/nickname"
        //头像修改
        case .modifyAvatar(api_token: _, avatar: _):
            return "/api/users/avatar"
        //获取机器号
        case .requestDeviceno():
            return "/api/request_deviceno"
        //发送短信或邮箱验证码
        case .sendSmsForCheck(username: _):
            return "/api/send_sms"
            
        //精选专题详情
        case .courseTopicsInfo(api_token: _, id: _):
            return "/api/course/topics_info"
    
            
        }
        
    }
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .commentDocomment(api_token:_,comment: _, id: _, return_id: _, cate_id: _),
             .doLikeRequest( id: _, cate_id: _,api_token:_, deviceno: _),
             .doFavoriteRequest( id: _, cate_id: _,api_token:_),
             .doFocusRequest( id: _, cate_id: _,api_token:_),
             .courseLeaveMessage(api_token: _, id: _, content: _),
             .courseQuestion(api_token: _, id: _,title: _, content: _),
             .register(username: _, smscode:_ ),
             .usersLogin(username: _, password: _,smscode: _, deviceno: _),
             .modifyNickname(api_token: _, nickname: _),
             .modifyAvatar(api_token: _, avatar: _),
             .sendSmsForCheck(username: _):
            
            return  .post
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
            
            //课程导读详情
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
            
        //comment - 提交评论
        case .commentDocomment(api_token: let api_token ,comment: let comment , id: let id, return_id: let return_id, cate_id: let cate_id):
            
            params = params.merging(["api_token":api_token,"comment":comment,"id":id,"return_id":return_id,"cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        //like - 点赞/取消点赞   (用户不登录可以给资讯点赞，cate_id=2且未登录时必须上传deviceno;cate_id!=2时必须登录才能点赞)
        case .doLikeRequest( id: let id, cate_id:  let cate_id ,api_token: let api_token, deviceno: let deviceno):
            params = params.merging(["api_token" : api_token,"id":id,"deviceno":deviceno,"cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        //favorites - 收藏/取消
        case .doFavoriteRequest( id: let id, cate_id: let cate_id ,api_token: let api_token):
            params = params.merging(["api_token":api_token,"id":id,"cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        //focus - 关注/取消
        case .doFocusRequest( id: let id, cate_id: let cate_id ,api_token: let api_token):
            params = params.merging(["api_token":api_token,"id":id,"cate_id":cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
        //课程详情
        case .courseDetailInfo(api_token: let api_token , id: let id):
            
            params = params.merging(["api_token":api_token,"id":id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //课程章节
        case .courseChapterInfo(api_token: let api_token , id: let id ):
            
            params = params.merging(["api_token":api_token,"id":id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //获得课程购买信息
        case .courseBuyInfo(api_token: let api_token, id: let id):
            params = params.merging(["api_token":api_token,"id":id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
        
            
        //留言发布
        case .courseLeaveMessage(api_token: let api_token , id: let id, content: let content):
            params = params.merging(["api_token": api_token, "id": id, "content": content], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //留言列表
        case .courseMessageList(skip: let skip, take: let take, api_token: let api_token , id: let id):
            
            params = params.merging(["api_token": api_token, "id": id, "skip": skip, "take": take], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        //问题提交
        case .courseQuestion(api_token: let api_token, id: let id,title: let title, content: let content):
            params = params.merging(["api_token": api_token, "id": id, "title": title, "content": content], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //问题列表
        case .courseQuestionList(skip: let skip, take: let take, api_token: let api_token , id: let id):
            params = params.merging(["api_token": api_token, "id": id, "skip": skip, "take": take], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //注册：
        case .register(username: let username, smscode: let smscode):
            
            params = params.merging(["username": username, "smscode": smscode], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //登录
        case .usersLogin(username: let username , password: let password ,smscode: let smscode , deviceno: let deviceno):
            
            params = params.merging(["username": username, "password": password, "smscode": smscode, "deviceno": deviceno], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)

        //获取用户信息
        case .getUserInfo(api_token: let api_token):
            params = params.merging(["api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //退出登录
        case .userLogout(api_token: let api_token):
            params = params.merging(["api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //昵称修改
        case .modifyNickname(api_token: let api_token, nickname: let nickname):
            params = params.merging(["api_token": api_token, "nickname": nickname], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //头像修改
        case .modifyAvatar(api_token: let api_token, avatar: let avatar):
            
            let formatter:DateFormatter =  DateFormatter.init()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName:String = formatter.string(from: Date.init()) + ".png"
            
            let imgData = MultipartFormData(provider: .data(avatar), name: "avatar", fileName: fileName, mimeType: "image/png")
            let multipartData = [imgData]
            
            params = params.merging(["api_token": api_token], uniquingKeysWith: {$1})
            //let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": "RootSign"]
            params.merge(dic2, uniquingKeysWith: { $1 })

            return .uploadCompositeMultipart(multipartData, urlParameters: params)

        //获取机器号
        case .requestDeviceno():
            
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //发送短信或邮箱验证码
        case .sendSmsForCheck(username: let username):
            params = params.merging(["username": username], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //精选专题详情
        case .courseTopicsInfo(api_token: let api_token, id: let id):
            params = params.merging(["api_token": api_token, "id": id], uniquingKeysWith: {$1})
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


