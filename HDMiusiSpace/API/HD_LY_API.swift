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
    //头像修改
    case modifyAvatar(api_token: String, avatar: Data)
    //获取机器号
    case requestDeviceno()
    //发送短信或邮箱验证码
    case sendSmsForCheck(username: String)
    
    //精选专题详情
    case courseTopicsInfo(api_token: String, id: String)
    
    //图片上传
    case uploadImg(api_token: String, uoload_img: Data)
    
    //报错/举报选项获取接口
    case getErrorOption( id: String, cate_id: String)
    
    //报错提交
    case sendError(api_token: String, option_id_str: String, parent_id: String , cate_id: String, content:String, uoload_img: Array<String>)

    //意见反馈
    case sendFeedback(api_token: String, cate_id: String, content:String)
    
    //轻听随看收听+1
    case courseListenedNumAdd(listen_id: String)
    
    //精选首页轮播图
    case getChoicenessHomeBanner()
    
    //精选首页
    case choicenessHomeRequest(api_token: String, deviceno: String)

    //首页资讯上拉加载
    case choicenessHomeMoreRequest(api_token: String, deviceno: String, num: String)

    //资讯详情接口
    case choicenessNewsInfo(api_token: String, article_id: String)

    //个人简介修改
    case usersProfile(api_token: String, profile: String)
    
    //修手机号/邮箱 短信验证
    case usersVerify(username: String, smscode: String)
    
    //忘记（修改）密码
    case usersPassword(api_token: String, password: String)

    //绑定新手机号/邮箱
    case usersChangeusername(api_token: String, username: String, smscode: String)

    //修改性别
    case usersChangeGender(api_token: String, sex: String)

    //第三方账号绑定注册
    case register_bind(params:Dictionary<String, Any>)
    
    
    //地图信息接口
    case getMapListAll(museum_id: Int, api_token: String)

    //获取博物馆列表
    case guideMuseumList(city_id: String, longitude: String, latitude: String, type:Int, skip:Int, take:Int)

    //展览列表
    case guideExhibitionList(museum_id: Int, skip:Int, take:Int, token: String)
    
    //展品列表
    case guideExhibitList(exhibition_id: Int, skip:Int, take:Int , api_token: String)
    
    //展品详情
    case guideExhibitInfo(exhibit_num: Int, api_token: String)
    
    //地图导览
    case guideMapGuide(museum_id: Int, api_token: String)
    
    //获取展览列表
    case exhibitionExhibitionList(type:Int, skip:Int, take:Int, city_name: String, longitude: String, latitude: String, keywords: String)
    
    //获取博物馆列表
    case exhibitionMuseumList(type:Int, skip:Int, take:Int, city_name: String, longitude: String, latitude: String, keywords: String, api_token: String)

    //获取博物馆详情
    case exhibitionMuseumInfo(museum_id: Int, api_token: String)

    //获取同馆展览列表
    case getSameExhibitionList(exhibition_id: Int, museum_id: Int, skip:Int, take:Int , api_token: String)

    //获取同馆攻略列表
    case getStrategyList(museum_id: Int, skip:Int, take:Int , api_token: String)

    //足迹上传
    case uploadFavoritesFootprint(exhibit_id: Int , api_token: String)
    
    //课程学习记录上传
    case uploadCourseRecords(chapter_id: Int , api_token: String, study_time: String)

    
    
    
}

extension HD_LY_API: TargetType {
    
    //--- 服务器地址 ---
    var baseURL: URL {
        
        switch self {
//        case .getMapListAll(floorNum: _, language: _),
//             .getMapExhibitListA(map_id: _, language: _):
//            return URL.init(string: HD_MapTest_IP)!
        default:
            return URL.init(string: HDDeclare.IP_Request_Header())!
        }
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
    
        //图片上传
        case .uploadImg(api_token: _, uoload_img: _):
            return "/api/deviceno/uploadimg"
            
        //报错/举报选项获取接口
        case .getErrorOption( id: _, cate_id: _):
            return "/api/deviceno/get_error_option"
            
        //报错提交
        case .sendError(api_token: _, option_id_str: _, parent_id: _ , cate_id: _, content:_, uoload_img: _):
            return "/api/deviceno/send_error"
            
        //意见反馈
        case .sendFeedback(api_token: _, cate_id: _ , content:_ ):
            return "/api/deviceno/feedback"
            
        //轻听随看收听+1
        case .courseListenedNumAdd(listen_id: _):
            return "/api/course/listen_in"

        //精选首页轮播图
        case .getChoicenessHomeBanner():
            return "/api/index/banner"
            
        //精选首页
        case .choicenessHomeRequest(api_token: _, deviceno: _):
            return "/api/index/index"
            
        //首页资讯上拉加载
        case .choicenessHomeMoreRequest(api_token: _, deviceno: _, num: _):
            return "/api/index/get_more_news"
            
        //资讯详情接口
        case .choicenessNewsInfo(api_token: _, article_id: _):
            return "/api/index/news_info"
            
        //个人简介修改
        case .usersProfile(api_token: _, profile: _):
            return "/api/users/profile"
            
        //修手机号/邮箱 短信验证
        case .usersVerify(username: _, smscode: _):
            return "/api/users/verify"
        
        //忘记（修改）密码
        case .usersPassword(api_token: _, password: _):
            return "/api/users/password"
            
            
        //绑定新手机号/邮箱
        case .usersChangeusername(api_token: _, username: _, smscode: _):
            return "/api/users/changeusername"
            
        //修改性别
        case .usersChangeGender(api_token: _, sex: _):
            return "/api/users/sex"
            
         //第三方账号绑定注册
        case .register_bind(params: _):
            return "/api/users/register_bind"
      
            
        case .getMapListAll(museum_id: _, api_token: _):
            return "/api/guide/map_guide"
            
            
        case .guideMuseumList(city_id: _, longitude: _, latitude: _, type: _, skip: _, take: _):
            return "/api/guide/museum_list"
            
            
        case .guideExhibitionList(museum_id: _, skip: _, take: _, token: _):
            return "/api/guide/exhibition_list"
            
        case .guideExhibitList(exhibition_id: _, skip: _, take: _, api_token: _):
            return "/api/guide/exhibit_list"
            
        case .guideExhibitInfo(exhibit_num: _, api_token: _):
            return "/api/guide/exhibit_info"
            
        case .guideMapGuide(museum_id: _, api_token: _):
            return "/api/guide/map_guide"
            
        case .exhibitionExhibitionList(_):
            return "/api/exhibition/exhibition_list"
            
        case .exhibitionMuseumList(_):
            return "/api/exhibition/museum_list"
            
        case .exhibitionMuseumInfo(_):
            return "/api/exhibition/museum_info"
            
        case .getSameExhibitionList(_):
            return "/api/exhibition/same_exhibition_list"
            
        case .getStrategyList(_):
            return "/api/exhibition/strategy_list"
            
        case .uploadFavoritesFootprint(_):
            return "/api/favorites/footprint"
            
        case .uploadCourseRecords(_):
            return "/api/myclass/study_class"
            
            
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
             .sendSmsForCheck(username: _),
             .uploadImg(api_token: _, uoload_img: _),
             .sendError(api_token: _, option_id_str: _, parent_id: _ , cate_id: _, content:_, uoload_img: _),
             .sendFeedback(api_token: _, cate_id: _ , content:_ ),
             .usersProfile(api_token: _, profile: _),
             .usersVerify(username: _, smscode: _),
             .usersPassword(api_token: _, password: _),
             .usersChangeusername(api_token: _, username: _, smscode: _),
             .usersChangeGender(api_token: _, sex: _),
             .register_bind(params: _),
             .uploadFavoritesFootprint(exhibit_id: _, api_token: _),
             .uploadCourseRecords(chapter_id: _, api_token: _, study_time: _):
            
            
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
            if password.count > 1 {
                params = params.merging(["username": username, "password": password, "deviceno": deviceno], uniquingKeysWith: {$1})
            }else if smscode.count > 1 {
                params = params.merging(["username": username, "smscode": smscode, "deviceno": deviceno], uniquingKeysWith: {$1})
            }
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
            
        //图片上传
        case .uploadImg(api_token: let api_token, uoload_img: let uoload_img):
            let formatter:DateFormatter =  DateFormatter.init()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName:String = formatter.string(from: Date.init()) + ".png"
            
            let imgData = MultipartFormData(provider: .data(uoload_img), name: "uoload_img", fileName: fileName, mimeType: "image/png")
            let multipartData = [imgData]
            
            params = params.merging(["api_token": api_token], uniquingKeysWith: {$1})
            
            return .uploadCompositeMultipart(multipartData, urlParameters: params)
            
        //报错/举报选项获取接口
        case .getErrorOption( id: let id, cate_id: let cate_id):
            params = params.merging(["id": id, "cate_id": cate_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })

        //报错提交
        case .sendError(api_token: let api_token, option_id_str: let option_id_str, parent_id: let parent_id , cate_id: let cate_id , content: let content , uoload_img: let uoload_img):
            params = params.merging(["api_token": api_token, "option_id_str": option_id_str, "parent_id": parent_id, "cate_id": cate_id, "content": content, "uoload_img": uoload_img], uniquingKeysWith: {$1})
//            let signKey =  HDDeclare.getSignKey(params)
//            let dic2 = ["Sign": signKey]
            let dic2 = ["Sign": "RootSign"]

            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //意见反馈
        case .sendFeedback(api_token: let api_token , cate_id: let cate_id , content: let content):
            params = params.merging(["api_token": api_token,"cate_id":cate_id, "content": content], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //轻听随看收听+1
        case .courseListenedNumAdd(listen_id: let listen_id ):
            params = params.merging(["listen_id": listen_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //精选首页轮播图
        case .getChoicenessHomeBanner():
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //精选首页
        case .choicenessHomeRequest(api_token: let api_token, deviceno: let deviceno):
            params = params.merging(["api_token": api_token, "deviceno": deviceno], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        //首页资讯上拉加载
        case .choicenessHomeMoreRequest(api_token: let api_token , deviceno: let deviceno, num: let num):
            params = params.merging(["api_token": api_token, "deviceno": deviceno, "num": num], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //资讯详情接口
        case .choicenessNewsInfo(api_token: let api_token , article_id: let article_id):
            params = params.merging(["api_token": api_token, "article_id": article_id], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        //个人简介修改
        case .usersProfile(api_token: let api_token , profile: let profile):
            params = params.merging(["api_token": api_token, "profile": profile], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .usersVerify(username: let username, smscode: let smscode):
            params = params.merging(["username": username, "smscode": smscode], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //忘记（修改）密码
        case .usersPassword(api_token: let api_token, password: let password):
            params = params.merging(["api_token": api_token, "password": password], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
        //绑定新手机号/邮箱
        case .usersChangeusername(api_token: let api_token, username: let username, smscode: let smscode):
            params = params.merging(["api_token": api_token, "username": username, "smscode": smscode], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //修改性别
        case .usersChangeGender(api_token: let api_token, sex: let sex):
            params = params.merging(["api_token": api_token, "sex": sex], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //第三方账号绑定注册
        case .register_bind(params: let paramsTemp):
            params = params.merging(paramsTemp, uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            

            
        case .getMapListAll(museum_id: let museum_id, api_token: let api_token):
            params = ["p":"i",
                      "museum_id": museum_id,
                      "api_token":api_token]
            params = params.merging(["museum_id": museum_id, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .guideMuseumList(let city_id, let longitude, let latitude, let type, let skip, let take):
            
            params = params.merging(["city_id": city_id, "longitude": longitude, "latitude": latitude, "type": type, "skip": skip, "take": take], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .guideExhibitionList(let museum_id, let skip, let take, let token):
            
            params = params.merging(["museum_id": museum_id, "skip": skip, "take": take, "api_token": token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .guideExhibitList(let exhibition_id, let skip, let take, let api_token):
            
            params = params.merging(["exhibition_id": exhibition_id, "skip": skip, "take": take, "api_token": api_token ], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .guideExhibitInfo(let exhibit_num, let api_token):
            
            params = params.merging(["exhibit_num": exhibit_num, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .guideMapGuide(let museum_id, let api_token):
            
            params = params.merging(["museum_id": museum_id, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .exhibitionExhibitionList(let type, let skip, let take, let city_name, let longitude, let latitude, let keywords):
            params = params.merging(["type": type, "skip": skip, "take": take, "city_name": city_name, "longitude": longitude, "latitude": latitude, "keywords": keywords], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .exhibitionMuseumList(let type, let skip, let take, let city_name, let longitude, let latitude, let keywords, let api_token):
            params = params.merging(["type": type, "skip": skip, "take": take, "city_name": city_name, "longitude": longitude, "latitude": latitude, "keywords": keywords, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .exhibitionMuseumInfo(let museum_id, let api_token):
            params = params.merging(["museum_id": museum_id, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .getSameExhibitionList(let exhibition_id, let museum_id, let skip, let take, let api_token):
            params = params.merging(["exhibition_id": exhibition_id,"museum_id": museum_id, "skip": skip, "take": take,  "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
        case .getStrategyList(let museum_id, let skip, let take, let api_token):
            
            params = params.merging(["museum_id": museum_id, "skip": skip, "take": take,  "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            
        case .uploadFavoritesFootprint(let exhibit_id, let api_token):
            params = params.merging(["exhibit_id": exhibit_id, "api_token": api_token], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
            
        case .uploadCourseRecords(let chapter_id, let api_token, let study_time):
            params = params.merging(["chapter_id": chapter_id, "api_token": api_token, "study_time": study_time], uniquingKeysWith: {$1})
            let signKey =  HDDeclare.getSignKey(params)
            let dic2 = ["Sign": signKey]
            params.merge(dic2, uniquingKeysWith: { $1 })
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
            
            
        }
        
        //GET 请求返回
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


