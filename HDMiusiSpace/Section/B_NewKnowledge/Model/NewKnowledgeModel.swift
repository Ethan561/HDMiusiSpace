//
//  NewKnowledgeModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/15.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

/*
 val NEWS_CATEGORY = 0         分类
 val NEWS_LIST = 1             精品推荐 列表形式
 val NEWS_CARD = 2             精品推荐 卡片形式
 val NEWS_LISTEN = 3           轻听随看
 val NEWS_PATERBITY_CARD = 4   亲子互动 卡片形式
 val NEWS_PATERBITY_LIST = 5   亲子互动 列表形式
 val NEWS_TOPIC = 6            精选专题
 */

struct BItemModel:Codable {
    var type: TStrInt?
    var category: BCategoryModel?
    var boutiquelist: BRecmdModel?
    var boutiquecard: BRecmdModel?
    var listen: [BRecmdModel]?
    var interactioncard: BRecmdModel?
    var interactionlist: [BRecmdModel]?
    var topic: [BRecmdModel]?
}

struct BCategoryModel:Codable {
    var type: Int?
    var title: String?
}

struct BRecmdModel:Codable {
    var article_id: TStrInt?
    var title: String?
    var des: String?
    var img: String?
    var icon: String?
    var price: String?
    var is_top: TStrInt?
    var is_big: TStrInt?
    var is_card: TStrInt?
    var views: TStrInt?
    var classnum: TStrInt?
    var file_type: TStrInt?//1是MP3;2是MP4
    var is_free: TStrInt?//1免费，0不免费
    var is_voice: Int?
    var voice: String?
    var teacher_name: String?
    var teacher_title: String?
    
}


struct BbannerModel:Codable {
    var article_id: TStrInt?
    var title: String?
    var des: String?
    var img: String?
    var views: TStrInt?
    var cate_id: TStrInt?
    var mid: TStrInt?
}

struct RecmdMoreModel:Codable {
    let status: Int
    let msg: String
    let data: [CourseListModel]
}

struct CourseListModel: Codable {
    let classID, uid: Int
    let title: String
    let price: String
    let isFree ,fileType: Int
    
    let img: String
    let classNum, purchases, isBigImg: Int
    let teacher_name, teacher_title: String

    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case uid, title, price
        case isFree = "is_free"
        case img, teacher_name, teacher_title
        case classNum = "class_num"
        case purchases
        case isBigImg = "is_big_img"
        case fileType = "file_type"
    }
}



struct CourseMenu: Codable {
    let status: Int
    let msg: String
    let data: [CourseMenuModel]
}

struct CourseMenuModel: Codable {
    let cateID: Int
    let cateName: String
    
    enum CodingKeys: String, CodingKey {
        case cateID = "cate_id"
        case cateName = "cate_name"
    }
}





