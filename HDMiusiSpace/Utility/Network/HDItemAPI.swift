//
//  HDItemAPI.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation
import Moya
import Result

enum  HDItemAPI {
    
    //首页展厅列表接口
    case getRootAFirstPage(language: String)
    //展厅介绍
    case getHallInfo(language: String , exhibition_id: String)
    //展厅列表
    case getHallList(language: String , exhibition_id: String, skip: String, take: String)
    //展品搜索
    case exhibitSearch(language: String , keyword: String)
    //热门展品
    case getHotExhibitList(language: String , skip: String, take: String)
    
    //随手拍列表
    case getTimeLineAllList(skip: String, take: String, api_token: String)
    //我的随手拍
    case getMineTimeLineList(skip: String, take: String, api_token: String)
    
    //上传图片（随手拍/留言）
    case uploadTimeLineImg(img: Data, api_token: String, type:String)
    
    //随手拍发布
    case publishTimeLine( api_token: String, content:String, imgs: Array<String>)
    
    //留言发布
    case feedbackSuggestions( api_token: String, word_content:String, contacts:String, word_img: Array<String>)
    
    //创建聊天群组
    case creatChatGroup(user_number: String , group_name: String)
    
    //加入聊天群组
    case joinChatGroup(user_number: String , group_number: String)
    
    //退出聊天群组
    case exitChatGroup(user_number: String , group_number: String)
    
    //绑定机器号
    case bindDevice(user_number: String , client_id: String)
    
    //是否已在群组
    case isExistGroup(user_number: String)
    
    //获取群组成员
    case getGroupMemberList(user_number: String , group_number: String)
    
    //获取聊天记录
    case getChatMessageList(from_user_number: String , to_user_number: String, skip: String, take: String)
    //发送文本消息
    case sendMessage(to_user_number: String,from_user_number: String , content: String)
    
    //发送语音消息
    case sendAudioMessage(from_user_number: String ,to_user_number: String, audioPath: URL)
    
    //好友位置
    case getMyPartnerLoc(user_number: String)
    
    //问卷调查
    case getQuestionDetail
    
    //删除随手拍
    case deleteTimeLine( api_token: String, pid: String)
    
    //随手拍点赞
    case dolikeTimeLine( api_token: String, type: String, pid: String, comment_id: String)
    
    //随手拍评论
    case commentTimeLine( api_token: String, pid: String, pai_comment: String)
    
    //随手拍评论列表
    case commentListTimeLine(pid: String, skip: String, take: String, api_token: String)
    
}

extension HDItemAPI: TargetType {
    
    //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
        //首页展厅列表接口
        case .getRootAFirstPage(language: _):
            return "/api/exhibition_list"
            
        //展厅介绍
        case .getHallInfo(language: _ , exhibition_id: _):
            return "api/exhibition_info"
            
        //展厅列表
        case .getHallList(language: _ , exhibition_id: _, skip: _, take: _):
            return "api/exhibit_list"
            
        //展品搜索
        case .exhibitSearch(language: _ , keyword: _):
            return "api/exhibit_search"
        //热门展品
        case .getHotExhibitList(language: _, skip: _, take: _):
            return "api/exhibit_hot"
            
        //问卷调查
        case .getQuestionDetail:
            return "api/question_list"
            
        //随手拍列表
        case .getTimeLineAllList(skip: _, take: _, api_token: _):
            return "api/pai_list"
        //我的随手拍列表
        case .getMineTimeLineList(skip: _, take: _, api_token: _):
            return "api/my_pai_list"
            
        //上传图片（随手拍/留言）
        case .uploadTimeLineImg(img: _, api_token: _, type: _):
            return "api/pai_uploadimg"
        //随手拍发布
        case .publishTimeLine( api_token: _, content:_, imgs: _):
            return "api/send_pai"
        //留言发布
        case .feedbackSuggestions( api_token: _, word_content:_, contacts:_, word_img: _):
            return "api/send_words"
            
        //创建聊天群组
        case .creatChatGroup(user_number: _ , group_name: _):
            return "api/gateway/create_group"
            
        //加入聊天群组
        case .joinChatGroup(user_number: _ , group_number: _):
            return "api/gateway/join_group"
            
        //退出聊天群组
        case .exitChatGroup(user_number: _ , group_number: _):
            return "api/gateway/exit_group"
            
        //绑定机器号
        case .bindDevice(user_number: _ , client_id: _):
            return "api/gateway/bind"
            
        //是否已在群组
        case .isExistGroup(user_number: _):
            return "api/gateway/getGroupList"
            
        //获取群组成员
        case .getGroupMemberList(user_number: _ , group_number: _):
            return "api/gateway/users_list"
            
        //获取聊天记录
        case .getChatMessageList(from_user_number: _ , to_user_number: _, skip: _, take: _):
            return "api/gateway/chat_message"
            
        //发送文本消息
        case .sendMessage(to_user_number: _, from_user_number: _ , content: _):
            return "api/gateway/send_msg"
            
        //发送语音消息
        case .sendAudioMessage(from_user_number: _ ,to_user_number: _, audioPath: _):
            return "api/gateway/upload_audio"
            
        //好友位置
        case .getMyPartnerLoc(user_number: _ ):
            return "api/gateway/get_gps"
            
        //删除随手拍
        case .deleteTimeLine( api_token: _, pid: _):
            return "api/del_my_pai_list"
            
        //随手拍点赞
        case .dolikeTimeLine( api_token: _, type: _, pid: _, comment_id: _):
            return "api/pai_dolike"
            
        //随手拍评论
        case .commentTimeLine( api_token: _, pid: _, pai_comment: _):
            return "api/pai_comment"
            
        //随手拍评论列表
        case .commentListTimeLine(pid: _,skip: _, take: _, api_token: _):
            return "api/pai_comment_list"
            
            
        }
        
    }
    
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .uploadTimeLineImg(img: _, api_token: _, type: _),
             .publishTimeLine(api_token: _, content: _, imgs: _),
             .feedbackSuggestions( api_token: _, word_content:_, contacts:_, word_img: _),
             .sendMessage(to_user_number: _, from_user_number: _, content: _),
             .sendAudioMessage(from_user_number: _, to_user_number: _, audioPath: _),
             .commentTimeLine(api_token: _, pid: _, pai_comment: _):
            return .post
        default:
            return .get
        }
    }
    
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        //展厅列表
        case .getRootAFirstPage(language: let language):
            params = ["p":"i",
                      "language": language]
        //展厅介绍
        case .getHallInfo(language: let language , exhibition_id: let exhibition_id):
            params = ["p":"i",
                      "language": language,
                      "exhibition_id": exhibition_id]
            
        //展厅列表
        case .getHallList(language: let language , exhibition_id: let exhibition_id, skip: let skip, take: let take):
            params = ["p":"i",
                      "language": language,
                      "exhibition_id": exhibition_id,
                      "skip": skip,
                      "take": take]
            
        //展品搜索
        case .exhibitSearch(language: let language , keyword: let keyword):
            params = ["p":"i",
                      "language": language,
                      "keyword": keyword]
        //热门展品
        case .getHotExhibitList(language: let language , skip: let skip, take: let take):
            params = ["p":"i",
                      "language": language,
                      "skip": skip,
                      "take": take]
            
        //随手拍列表
        case .getTimeLineAllList(skip: let skip, take: let take, api_token: let api_token):
            params = ["p":"i",
                      "skip": skip,
                      "take": take,
                      "api_token": api_token,
            ]
            
        //我的随手拍列表
        case .getMineTimeLineList(skip: let skip, take: let take, api_token: let api_token):
            params = ["p":"i",
                      "skip": skip,
                      "take": take,
                      "api_token": api_token,
            ]
            
        //上传图片（随手拍/留言）
        case .uploadTimeLineImg(img: let imgData, api_token: let api_token, type: let type):
            let formatter:DateFormatter =  DateFormatter.init()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName:String = formatter.string(from: Date.init()) + ".png"
            
            let imgData = MultipartFormData(provider: .data(imgData), name: "img_file", fileName: fileName, mimeType: "image/png")
            let multipartData = [imgData]
            let urlParameters = ["p":"i", "api_token": api_token, "type": type]
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            
        //随手拍发布
        case .publishTimeLine( api_token: let api_token, content: let content , imgs: let imgs):
            params = ["p":"i",
                      "api_token": api_token,
                      "pai_content": content,
                      "pai_img": imgs,
            ]
            
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //留言发布
        case .feedbackSuggestions( api_token: let api_token, word_content: let word_content, contacts: let contacts, word_img: let word_img):
            params = ["p":"i",
                      "api_token": api_token,
                      "word_content": word_content,
                      "contacts": contacts,
                      "word_img": word_img,
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //创建聊天群组
        case .creatChatGroup(user_number: let user_number , group_name: let group_name):
            params = ["p":"i",
                      "user_number": user_number,
                      "group_name": group_name]
            
            
        //加入聊天群组
        case .joinChatGroup(user_number: let user_number , group_number: let group_number):
            params = ["p":"i",
                      "user_number": user_number,
                      "group_number": group_number]
            
        //退出聊天群组
        case .exitChatGroup(user_number: let user_number , group_number: let group_number):
            params = ["p":"i",
                      "user_number": user_number,
                      "group_number": group_number]
            
        //绑定机器号
        case .bindDevice(user_number: let user_number , client_id: let client_id):
            params = ["p":"i",
                      "user_number": user_number,
                      "client_id"  : client_id]
            
        //是否已在群组
        case .isExistGroup(user_number: let user_number):
            params = ["p":"i",
                      "user_number": user_number]
            
        //获取群组成员
        case .getGroupMemberList(user_number: let user_number , group_number: let group_number):
            params = ["p":"i",
                      "user_number": user_number,
                      "group_number": group_number]
        //获取聊天记录
        case .getChatMessageList(from_user_number: let from_user_number , to_user_number: let to_user_number, skip: let skip , take: let take):
            params = ["p":"i",
                      "from_user_number": from_user_number,
                      "to_user_number": to_user_number,
                      "skip": skip,
                      "take": take]
        //发送文本消息
        case .sendMessage(to_user_number: let to_user_number, from_user_number: let from_user_number , content: let content):
            params = ["p":"i",
                      "from_user_number": from_user_number,
                      "to_user_number": to_user_number,
                      "content": content]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //发送语音消息
        case .sendAudioMessage(from_user_number: let from_user_number ,to_user_number: let to_user_number, audioPath: let audioPath):
            
            let formatter:DateFormatter =  DateFormatter.init()
            formatter.dateFormat = "yyyyMMddHHmmss"
            let fileName:String = formatter.string(from: Date.init()) + ".mp3"
            let audioData = NSData.init(contentsOf: audioPath)
            
            let formData = MultipartFormData.init(provider: .data(audioData! as Data), name: "chat_audio", fileName: fileName, mimeType: "mp3")
            let multipartData = [formData]
            let urlParameters = ["p":"i", "from_user_number": from_user_number, "to_user_number": to_user_number]
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            
        //好友位置
        case .getMyPartnerLoc(user_number: let user_number ):
            params = ["p":"i",
                      "user_number": user_number]
        //问卷调查
        case .getQuestionDetail:
            params = ["p":"i"]
            
        //删除随手拍
        case .deleteTimeLine( api_token: let api_token , pid:  let pid):
            params = ["p":"i",
                      "api_token": api_token,
                      "pid": pid ]
        //随手拍点赞
        case .dolikeTimeLine( api_token: let api_token, type: let type, pid: let pid, comment_id: let comment_id):
            params = ["p":"i",
                      "api_token": api_token,
                      "type": type,
                      "pid": pid ,
                      "comment_id": comment_id]
            
        //随手拍评论
        case .commentTimeLine( api_token: let api_token, pid: let pid, pai_comment: let pai_comment):
            params = ["p":"i",
                      "api_token": api_token,
                      "pid": pid ,
                      "pai_comment": pai_comment]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        //随手拍评论列表
        case .commentListTimeLine(pid: let pid, skip: let skip, take: let take, api_token: let api_token):
            params = ["p":"i",
                      "pid": pid ,
                      "skip": skip,
                      "take": take ,
                      "api_token": api_token]
            
            
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


struct AuthPlugin: PluginType {
    //   let token: String
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        //设置超时时间
        request.timeoutInterval = 30
        //设置请求头的数据类型
        request.setValue("application/json", forHTTPHeaderField: "accept")
        return request
    }
    
    
}



/** 是否缓存 */
public let kShouldCache             = true

/** 线上线下标识*/
public let kServiceIsOnline         = true

/** 超时时间 */
public let kRequestTimeoutInterval:TimeInterval  = 20

public let kCacheStatusCode = 200


final class RequestCachePlugin: PluginType {
    var url:String = ""
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        //print("request")
        var request = request
        request.timeoutInterval = kRequestTimeoutInterval
        //request.cachePolicy = .useProtocolCachePolicy
        return request
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        //print("willSend")
        url = "\(request)"
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
       // print("didReceive")
        if case let .success(response) = result{
            if response.statusCode == 200 {
                HD_LY_Cache.saveDataCache(response.data, forKey: url)
            }
        }
        //print("target.path: \(target.path)")
    }
    
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        //print("process")
        let result = result
        switch result {
        case .success(let response):
            if response.statusCode != 200 {
                if response.statusCode == 405 || response.statusCode == 404 {
                    return result
                }
                return readCache(result)
            }else{
                return result
            }
        case .failure(_):
            return readCache(result)
        }
    }
    
    private func readCache(_ result: Result<Response, MoyaError>)->Result<Response, MoyaError>{
        if kShouldCache {
            
            let resData:Data? = HD_LY_Cache.readDataCache(url) as? Data
            if  resData != nil {
                let response = Response(statusCode: kCacheStatusCode, data: resData!)
                print("===== 接口缓存数据返回：\(String(describing: response.request))")
                return .success(response)
            }
        }
        return result
    }
}







