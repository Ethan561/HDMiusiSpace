//
//  HDZQ_MyOwnModel.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

struct MyFollowData:Codable {
    var status: Int = 0
    var data = [MyFollowModel]()
    var msg: String?
}

struct MyFollowModel:Codable {
    var toid: Int = 0
    var cateId: Int = 0
    var title: String
    var img: String
    var subTitle: String
    var isVip : Int
    enum CodingKeys: String, CodingKey {
        case cateId = "cate_id"
        case toid, title, img
        case subTitle = "sub_title"
        case isVip = "is_vip"
    }
}


struct MyCollectNewsData:Codable {
    var status: Int = 0
    var data = [HDSSL_SearchNews]()
    var msg: String?
}

struct MyCollectNewsModel:Codable {
    var articleId: Int = 0
    var keywords, title, img,platform: String
    var comments,likes : Int
    enum CodingKeys: String, CodingKey {
        case articleId = "article_id"
        case keywords, title, img,platform,comments,likes
    }
}

struct MyCollectExhibitionData:Codable {
    var status: Int = 0
    var data = [MyCollectExhibitionModel]()
    var msg: String?
}

struct MyCollectExhibitionModel:Codable {
    var exhibitionId: Int = 0
    var address, title, img,star: String
    var iconList : [String]?
    enum CodingKeys: String, CodingKey {
        case exhibitionId = "exhibition_id"
        case iconList = "icon_list"
        case address, title, img,star
    }
}

struct MyCollectCourseData:Codable {
    var status: Int = 0
    var data = [MyCollectCourseModel]()
    var msg: String?
}

struct MyCollectCourseModel:Codable {
    
    var classId: Int = 0
    var isFree: Int = 0
    var classNum: Int = 0
    var studyNum: Int = 0
    var studyClassNum: Int = 0
    var percentage: Int = 0
    var tid: Int = 0
    var title: String
    var img: String
    var teacherName: String
    var teacherTitle: String
    var price: Int
    var fileType : Int
    
    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case price, title, img,percentage,tid
        case isFree = "is_free"
        case classNum = "class_num"
        case studyNum = "study_num"
        case studyClassNum = "study_class_num"
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
        case fileType = "file_type"
    }
}

//足迹
struct FootprintData:Codable {
    var status: Int = 0
    var data = [FootprintModel]()
    var msg: String?
}

struct FPRelatedModel:Codable {
    var img: String?
    var title: String?
    var class_id: Int = 0
    var teacher_title: String?
    var teacher_name: String?
}

struct FPExhibit:Codable {
    var exhibit_title: String?
    var voice: String?
    var exhibit_id: Int = 0
}

struct FPContent:Codable {
    var class_list = [FPRelatedModel]()
    var exhibition_share_html: String?
    var exhibition_title: String?
    var museum_title: String?
    var exhibit_list = [FPExhibit]()
}

struct FootprintModel:Codable {
    var look_date: String?
    var list_data = [FPContent]()
}


// 用户详情
struct UserData:Codable {
    var status: Int = 0
    var data: UserModel?
    var msg: String?
}

struct UserModel:Codable {
    var sex: Int = 0
    var bind_wb: Int = 0
    var footprint_num: Int = 0
    var daycard_num: Int = 0
    var favorite_num: Int = 0
    var email: String?
    var bind_wx: Int = 0
    var wb_nickname: String?
    var nickname: String?
    var focus_num: Int = 0
    var uid: Int = 0
    var wx_nickname: String?
    var qq_nickname: String?
    var is_vip: Int = 0
    var phone: String?
    var avatar: String?
    var vip_end_time: String?
    var label_str = [String]()
    var bind_qq: Int = 0
    var profile: String?
    var space_money: String?
}


// 日卡
struct DayCardData:Codable {
    var status: Int = 0
    var data: DayCardList?
    var msg: String?
}

struct DayCardList:Codable {
    var total_num: Int = 0
    var date_list = [Date_list]()
}

struct DayCardModel:Codable {
    var article_id: Int = 0
    var img: String?
    var card_id: Int = 0
    var date: String?
    var daycard_id: Int = 0
}

struct Date_list:Codable {
    var date_list = [DayCardModel]()
    var month: String?
    var num: Int = 0
}


