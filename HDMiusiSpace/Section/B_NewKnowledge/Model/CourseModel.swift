//
//  CourseModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseModel: Codable {
    let status: Int
    let msg: String
    var data: CourseInfoModel
}

struct CourseInfoModel: Codable {
    var articleID: TStrInt
    var img, title, buynotice: String
    var isFree: Int
    var video: String
    var yprice, oprice, price : String?
    var teacherID: TStrInt
    var url: String
    var fileType: Int
    var timg, teacherName, teacherTitle, teacherContent: String
    var isFavorite, isFocus, isBuy: Int
    var recommendsMessage: [ListenCommentList]?
    var recommendsList: [CourseInfoRecommends]?
    var share_url: String?
    var share_des: String?
    var notice: String?
    var is_portrait: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title, buynotice
        case isFree = "is_free"
        case video, yprice, oprice, price
        case teacherID = "teacher_id"
        case url
        case fileType = "file_type"
        case timg
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
        case teacherContent = "teacher_content"
        case isFavorite = "is_favorite"
        case isFocus = "is_focus"
        case isBuy = "is_buy"
        case recommendsMessage = "recommends_message"
        case recommendsList = "recommends_list"
        case share_url
        case share_des
        case notice
         case is_portrait
    }
}

struct CourseInfoRecommends: Codable {
    let articleID: Int
    let img, title: String
    let cateID: Int
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title
        case cateID = "cate_id"
    }
}



