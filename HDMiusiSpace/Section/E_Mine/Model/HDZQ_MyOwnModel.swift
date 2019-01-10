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

struct SearResultData:Codable {
    var status: Int = 0
    var data = [FollowPerModel]()
    var msg: String?
}

struct FollowPerModel:Codable {
    var uid: Int = 0
    var is_focus: Int = 0
//    var cateId: Int = 0
    var title: String
    var img: String
    var sub_title: String
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

struct MyCollectListenData:Codable {
    var status: Int = 0
    var data = [MyCollectListenModel]()
    var msg: String?
}

struct MyCollectListenModel:Codable {
    var listen_id: Int = 0
    var title, img: String
    var listening : Int
}

struct MyCollectJingxuanData:Codable {
    var status: Int = 0
    var data = [MyCollectJingxuanModel]()
    var msg: String?
}

struct MyCollectJingxuanModel:Codable {
    var article_id: Int = 0
    var title, img: String
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
    var price: String
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
    var share_des: String?
    var exhibition_title: String?
    var museum_title: String?
    var exhibit_list = [FPExhibit]()
}

struct FootprintModel:Codable {
    var look_date: String?
    var list_data = [FPContent]()
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

struct DynamicData:Codable {
    var status: Int = 0
    var data : [MyDynamic]
    var msg: String?
}

//我的动态
struct MyDynamic: Codable {
    var commentID, cateID, articleID: Int?
    var comment, createdAt: String?
    var avatar: String?
    var nickname: String?
    var newsInfo: MyDynamicNewsInfo?
    var listenInfo, topicInfo: MyDynamicListenInfo?
    var strategyInfo: MyDynamicNewsInfo?
    var exhibitionInfo: MyDynamicExhibitionInfo?
    var height = 0
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case cateID = "cate_id"
        case articleID = "article_id"
        case comment
        case createdAt = "created_at"
        case avatar, nickname
        case newsInfo = "news_info"
        case listenInfo = "listen_info"
        case topicInfo = "topic_info"
        case strategyInfo = "strategy_info"
        case exhibitionInfo = "exhibition_info"
    }
}

//展览
struct MyDynamicExhibitionInfo: Codable {
    let articleID: Int?
    let title, price: String?
    let isFree: Int?
    let img: String?
    let star, address: String?
    let iconList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, price
        case isFree = "is_free"
        case img, star, address
        case iconList = "icon_list"
    }
}

//轻听和专题
struct MyDynamicListenInfo: Codable {
    let articleID: Int?
    let title: String?
    let listening: Int?
    let img: String?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, listening, img
    }
}
//资讯
struct MyDynamicNewsInfo: Codable {
    let articleID: Int?
    let img: String?
    let title, platTitle, keywords: String?
    let likes, comments: Int?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title
        case platTitle = "plat_title"
        case keywords, likes, comments
    }
}
//攻略
struct MyDynamicStrategyInfo: Codable {
    let articleID: Int?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
    }
}

//
struct UserDynamicModel:Codable {
    var status: Int = 0
    var data: UserDynamic?
    var msg: String?
}

struct UserDynamic:Codable {
    var sex: Int = 0
    var footprint_num: Int = 0
    var daycard_num: Int = 0
    var favorite_num: Int = 0
    var email: String?
    var nickname: String?
    var class_list = [CoureModel]()
    var focus_num: Int = 0
    var is_new_footprint: Int = 0
    var uid: Int = 0
    var dynamic_list = [MyDynamic]()
    var is_vip: Int = 0
    var phone: String?
    var avatar: String?
    var is_new_msg: Int = 0
    var vip_end_time: String?
    var profile: String?
    var space_money: String?
}

struct CoureModel:Codable {
    var percentage: Int = 0
    var img: String?
    var title: String?
    var class_num: Int = 0
    var class_id: Int = 0
}

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

struct OtherDynamicData:Codable {
    var status: Int = 0
    var data: OtherDynamic?
    var msg: String?
}

struct OtherDynamic:Codable {
    var toid: String?
    var dynamic_list = [MyDynamic]()
    var favorite_num: Int = 0
    var is_vip: Int = 0
    var avatar: String?
    var nickname: String?
    var is_focus: Int = 0
    var focus_num: Int = 0
    var sex: Int = 0
    var profile: String?
}

//
struct TeacherDynamic: Codable {
    var status: Int?
    var msg: String?
    var data: TeacherDynamicData?
}

struct TeacherDynamicData: Codable {
    var teacherID: Int?
    var title, subTitle, des: String?
    var avatar: String?
    var isFocus: Int?
    var classList: [TeacherClassList]?
    
    enum CodingKeys: String, CodingKey {
        case teacherID = "teacher_id"
        case title
        case subTitle = "sub_title"
        case des, avatar
        case isFocus = "is_focus"
        case classList = "class_list"
    }
}

struct TeacherClassList: Codable {
    var classID, uid: Int?
    var title, price: String?
    var isFree: Int?
    var img: String?
    var classNum, purchases, fileType, teacherID: Int?
    var teacherName, teacherTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case classID = "class_id"
        case uid, title, price
        case isFree = "is_free"
        case img
        case classNum = "class_num"
        case purchases
        case fileType = "file_type"
        case teacherID = "teacher_id"
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
    }
}


struct PlatDynamic: Codable {
    var status: Int?
    var msg: String?
    var data: PlatDynamicData?
}

struct PlatDynamicData: Codable {
    var title, des: String?
    var avatar: String?
    var platformID, isFocus: Int?
    var newsList: [PlatNewsList]?
    
    enum CodingKeys: String, CodingKey {
        case title, des, avatar
        case platformID = "platform_id"
        case isFocus = "is_focus"
        case newsList = "news_list"
    }
}

struct PlatNewsList: Codable {
    var articleID: Int?
    var img: String?
    var title, keywords, createdAt: String?
    var avatar: String?
    var platformTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title, keywords
        case createdAt = "created_at"
        case avatar
        case platformTitle = "platform_title"
    }
}



