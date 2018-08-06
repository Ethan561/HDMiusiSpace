//
//  HD_ZQ_API.swift
//  HDNanHaiMuseum
//
//  Created by HD-XXZQ-iMac on 2018/6/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Moya

enum  HD_ZQ_API {
    
    //展品详情
    case getExhibitDetail(exhibitId: Int,language: String,api_token: String)
    case getExhibitRoadId(exhibitId: Int,language: String,api_token: String,road_id:Int)
    //地图展品接口
    case getMapExhibitList(floorNum: String,language: String, roadId:Int,api_token: String)
    //地图信息接口
    case getMapList(floorNum: Int,language: String)
    //路线列表接口
    case getRoadList(language: String)
    //路线列表接口
    case getRoadDetail(roadId:Int, language: String)
    //路线信息接口
    case getRouteInfo(floorNum: String,language: String, roadId:Int)
    //服务设施
    case getMapServicePoints(floorNum: String)
    //评论接口
    case getExhibitCommentList(exhibitId: Int,api_token: String)
    //写评论接口
    case writeCommentContent(exhibitId: Int,exhibitionId:Int,type:Int,api_token:String,comment:String)
    // 详情点赞接口
    case doLikeAction(exhibitId: Int,type:Int,api_token:String)
    // 评论点赞接口
    case commentLikeAction(commentId: Int,api_token:String)
    // 展品浏览记录接口
    case visitExhibit(exhibitId: Int,api_token:String)
    // 获取服务设施列表
    case getServicePointList()
    // 服务设施搜索
    case serviceSearch(typeId: Int,mapId:Int)
    // 上传定位信息
    case uploadPositions(deviceno: String,language: String,api_token: String,auto_num:Int)
    //  获取附近展品
    case getNearbyExhibits(language: String,autonum_str:Int)
    //  生成导航路线接口
    case getRoadNavigation(deviceno: String,mapId:Int,exhibitId:Int,language: String)
    
    
}

extension HD_ZQ_API: TargetType {
    
    //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
        case .getExhibitDetail(exhibitId: _, language: _, api_token: _):
            return "api/exhibit_info"
        case .getMapExhibitList(_,_,_,_):
            return "api/map_exhibit"
        case .getMapServicePoints(floorNum: _ ):
            return "api/map_service_point"
        case .getExhibitRoadId(exhibitId: _, language: _, api_token: _,road_id:_):
            return "api/exhibit_info"
        case .getExhibitCommentList( _, _):
            return "api/comment_list"
        case .writeCommentContent(_,_, _,  _, _):
            return "api/exhibit_comment"
        case .doLikeAction(_, _, _):
            return "api/do_like"
        case .commentLikeAction(_,_):
            return "api/comment_do_like"
        case .getMapList(_,_):
            return "api/map_list"
        case .getRouteInfo(_,_,_):
            return "api/road_info"
        case .visitExhibit(_,_):
            return "api/visit_exhibit"
        case .getRoadList(_):
            return "api/road_list"
        case .getRoadDetail(_):
            return "api/road_detail"
        case .getServicePointList:
            return "api/service_point_list"
        case .serviceSearch(_,_):
            return "api/service_point_search"
        case .uploadPositions(_,_,_,_):
            return "api/positions"
        case .getNearbyExhibits(_,_):
            return "api/map_near_exhibit"
        case .getRoadNavigation(_,_,_,_):
            return "api/road_navigation"
        }
    }
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .writeCommentContent(_,_,_,_,_):
            return .post
        case .uploadPositions(_,_,_,_):
            return .post
        default:
            return .get
        }
        
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .getExhibitDetail(exhibitId: let exhibitId, language: let language, api_token:let api_token):
            params = ["p":"i",
                      "language": language,
                      "exhibit_id": exhibitId,
                      "api_token": api_token]
        case .getMapExhibitList(let floorNum,let language,let roadId,let api_token):
            params = ["p":"i",
                      "language": language,
                      "map_id": floorNum,
                      "api_token": api_token,
                      "road_id":roadId]
        case .getMapServicePoints(floorNum: let floorNum):
            params = ["p":"i",
                      "map_id": floorNum]
        case .getExhibitRoadId(exhibitId: let exhibitId, language: let language, api_token:let api_token,road_id : let road_id):
            params = ["p":"i",
                      "language": language,
                      "exhibit_id": exhibitId,
                      "api_token": api_token,
                      "road_id": road_id]
        case .getExhibitCommentList(let exhibitId, let api_token):
            params = ["p":"i",
                      "type": "2",
                      "ex_id": exhibitId,
                      "api_token":api_token,
                      "skip":"0",
                      "take":"10"]
        case .writeCommentContent(let exhibitId, let exhibitionId, let type, let api_token, let comment):
            params = ["p":"i",
                      "exhibition_id": exhibitionId,
                      "exhibit_id": exhibitId,
                      "type":type,
                      "api_token":api_token,
                      "comment":comment]
             return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .doLikeAction(let exhibitId, let type, let api_token):
            params = ["p":"i",
                      "exhibit_id": exhibitId,
                      "type":type,
                      "api_token":api_token]
        case .commentLikeAction(let commentId, let api_token):
            params = ["p":"i",
                      "comment_id": commentId,
                      "api_token":api_token]
        case .getMapList(let floorNum,let language):
            params = ["p":"i",
                      "language": language,
                      "floor_id":floorNum]
        case .getRouteInfo(let floorNum, let language, let roadId):
            params = ["p":"i",
                      "language": language,
                      "map_id":floorNum,
                      "road_id":roadId]
        case .visitExhibit(let exhibitId, let api_token):
            params = ["p":"i",
                      "exhibit_id": exhibitId,
                      "api_token":api_token]
        case .getRoadList(let language):
            params = ["p":"i",
                      "language": language]
        case .getRoadDetail(let roadId, let language):
            params = ["p":"i",
                      "language": language,
                      "road_id":roadId]
        case .getServicePointList:
            params = ["p":"i"]
            
            
        case .serviceSearch(let typeId, let mapId):
            params = ["p":"i",
                      "type_id": typeId,
                      "map_id":mapId]
        case .uploadPositions(let deviceno, let language, let api_token, let auto_num):
            params = ["p":"i",
                      "language": language,
                      "deviceno": deviceno,
                      "api_token": api_token,
                      "auto_num": auto_num]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getNearbyExhibits(let language, let autonum_str):
            params = ["p":"i",
                      "language": language,
                      "autonum_str": autonum_str]
        case .getRoadNavigation(let deviceno, let mapId, let exhibitId,let language):
            params = ["p":"i",
                      "language": language,
                      "deviceno": deviceno,
                      "map_id": mapId,
                      "exhibit_id": exhibitId]
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
