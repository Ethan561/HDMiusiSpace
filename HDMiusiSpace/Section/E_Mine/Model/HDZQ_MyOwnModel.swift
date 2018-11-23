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
