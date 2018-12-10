//
//  CourseDetail.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseDetail: Codable {
    var status: Int
    var msg: String
    var data: CourseDetailModel
}

struct CourseDetailModel: Codable {
    var articleID: TStrInt
    var img, title, buynotice: String
    var isFree: Int
    var video: String
    var yprice, price : String?
    var teacherID: TStrInt
    var url: String
    var fileType: Int
    var timg, teacherName, teacherTitle: String
    var isFavorite, isFocus, isBuy: Int
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title, buynotice
        case isFree = "is_free"
        case video, yprice, price
        case teacherID = "teacher_id"
        case url
        case fileType = "file_type"
        case timg
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
        case isFavorite = "is_favorite"
        case isFocus = "is_focus"
        case isBuy = "is_buy"
    }
}

//评论列表
struct CourseMessageList: Codable {
    let status: Int
    let msg: String
    let data: [CourseMessageModel]
}

struct CourseMessageModel: Codable {
    var uid: TStrInt
    var content: String?
    var likeNum, messageID: TStrInt
    var avatar, nickname, time: String?
    var isLike: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, content
        case likeNum = "like_num"
        case messageID = "message_id"
        case avatar, nickname, time
        case isLike = "is_like"
    }
}



