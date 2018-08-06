//
//  HDItemAPI.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation
import Moya

enum  HDItemAPI {
    
    //首页主界面接口
    case getRootAFirstPage
    //地图展品接口
    case get_exhibit_list_by_map(floor_num: String)
    //服务设施
    case get_facility_by_map(floor_num: String)
    //展厅排序
    case exhibit_room_order(theme_id: String)
    //热度排序
    case exhibit_order(theme_id: String)
    //距离排序
    case distance_order(major: Array<Any>)
    //位置上传
    case upload_positons(deviceno: String, major: String)
}

extension HDItemAPI: TargetType {

     //--- 服务器地址 ---
    var baseURL: URL {
        return URL.init(string: HDDeclare.IP_Request_Header())!
    }
    
    //--- 各个请求的具体路径 ---
    var path: String {
        
        switch self {
        //首页主界面接口
        case .getRootAFirstPage:
            return "/api/index"
        //地图点位数据
        case .get_exhibit_list_by_map(floor_num: _):
            return "/api/map/get_exhibit_list_by_map"
        //服务设施
        case .get_facility_by_map(floor_num: _):
            return "/api/map/get_facility_by_map"
        //展厅排序
        case .exhibit_room_order(_):
            return "/api/exhibit/exhibit_room_order"
        //热度排序
        case .exhibit_order(theme_id: _):
            return "/api/exhibit/exhibit_order"
        //距离排序
        case .distance_order(major: _):
            return "/api/exhibit/distance_order"
            
        //位置上传
        case .upload_positons(deviceno: _, major: _):
            return "/api/map/positions"
            
            
            
            
            
        }
    }
      
    //--- 请求类型 ---
    var method: Moya.Method {
        switch self {
        case .upload_positons(deviceno: _, major: _):
            return .post
        default:
            return .get
        }
    }
    
    //--- 请求任务事件（这里附带上参数）---
    var task: Task {
        var params: [String: Any] = [:]
        
        switch self {
        case .getRootAFirstPage:
            params = ["p":"i"]
            
        case .get_exhibit_list_by_map(floor_num: let floor):
            params = ["p":"i",
                      "floor_num": floor]
        case .get_facility_by_map(floor_num: let floor):
            params = ["p":"i",
                      "floor_num": floor]
        
        case .upload_positons(deviceno: let deviceno, major: let major):
            params = ["p":"i",
                      "deviceno": deviceno,
                      "major": major,
            ]
            
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































