//
//  HDLY_NotiMsgModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/1.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

struct HDLY_NotiMsgModel: Codable {
    var status: Int?
    var msg: String?
    var data: HDLY_NotiMsgData?
}

struct HDLY_NotiMsgData: Codable {
    var systemMsgNum: Int?
    var systemMsgTime, systemMsgTitle: String?
    var dynamicMsgNum: Int?
    var dynamicMsgTime, dynamicMsgTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case systemMsgNum = "system_msg_num"
        case systemMsgTime = "system_msg_time"
        case systemMsgTitle = "system_msg_title"
        case dynamicMsgNum = "dynamic_msg_num"
        case dynamicMsgTime = "dynamic_msg_time"
        case dynamicMsgTitle = "dynamic_msg_title"
    }
}


struct HDLY_SystemMsgModel: Codable {
    var status: Int?
    var msg: String?
    var data: [SystemMsgModelData]?
}

struct SystemMsgModelData: Codable {
    var cateID, msgID: Int?
    var createdAt, title, content: String?
    var img: String?
    
    enum CodingKeys: String, CodingKey {
        case cateID = "cate_id"
        case msgID = "msg_id"
        case createdAt = "created_at"
        case title, content, img
    }
}





struct HDLY_DynamicMsgModel: Codable {
    var status: Int?
    var msg: String?
    var data: [DynamicMsgModelData]?
}

struct DynamicMsgModelData: Codable {
    var cateID, msgID: Int?
    var createdAt, title, des: String?
    var avatar: String?
    var uid: Int?
    
    enum CodingKeys: String, CodingKey {
        case cateID = "cate_id"
        case msgID = "msg_id"
        case createdAt = "created_at"
        case title, des, avatar, uid
    }
}





