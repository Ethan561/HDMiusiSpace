//
//  HDSSL_searchTagModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/7.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation
struct HDSSL_searchPlaceholderModel:Codable {
    var status            : Int?
    var msg               : String?
    var data              : String?
}
//---搜索类别
struct HDSSL_searchTagModel: Codable {
    var status            : Int?
    var msg               : String?
    var data              : [HDSSL_SearchTag]?
}

struct HDSSL_SearchTag: Codable {
    var type              : Int?
    var title             : String?
}

//---开始搜索
struct HDSSL_SearchResultModel: Codable {
    var status            : Int?
    var msg               : String?
    var data              : [HDSSL_SearchType]?
}
struct HDSSL_SearchType: Codable {
    var news_num          : Int?   //资讯总数
    var news_list         : [HDSSL_SearchNews]?//资讯列表
    var course_num        : Int?   //课程总数
    var course_list       : [HDSSL_SearchCourse]?//课程列表
    var exhibition_num    : Int?   //展览总数
    var exhibition_list   : [HDSSL_SearchExhibition]?//展览列表
    var museum_num        : Int?   //博物馆总数
    var museum_list       : [HDSSL_SearchMuseum]?//博物馆列表
    var type              : Int?   //类型
}
struct HDSSL_SearchNews: Codable {
    var article_id        : Int?   //资讯id
    var title             : String?//资讯标题
    var img               : String?//资讯头图
    var keywords          : String?//资讯标签
    var plat_title        : String?//资讯平台
    var comments          : Int?   //评论数量
    var likes             : Int?   //点赞数量
}
struct HDSSL_SearchCourse: Codable {
    var class_id          : Int?     //课程id
    var title             : String?  //课程标题
    var price             : Float?   //价格
    var is_free           : Int?     //是否免费1免费，0不免费
    var img               : String?  //图片
    var class_num         : Int?     //课时
    var purchases         : Int?     //学习人数
    var teacher_id        : Int?     //教师id
    var teacher_name      : String?  //教师姓名
    var teacher_title     : String?  //教师头衔
    var file_type         : Int?     //课程类型1是MP3;2是MP4
}
struct HDSSL_SearchExhibition: Codable {
    var exhibition_id     : Int?     //展览id
    var title             : String?  //名字
    var img               : String?  //图片
    var is_free           : Int?     //是否免费1免费，0不免费
    var price             : Float?   //价格
    var star              : TStrInt?   //评星
    var address           : String?  //展览地址
    var icon_list         : [String]?//服务图标地址
}
struct HDSSL_SearchMuseum: Codable {
    var museum_id         : Int?     //博物馆id
    var title             : String?  //名字
    var img               : String?  //图片
    var address           : String?  //博物馆地址
    var icon_list         : [String]?//服务图标地址
}
