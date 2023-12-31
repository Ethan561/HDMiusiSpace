//
//  HDSSL_commentModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
struct HDSSL_commentModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : [HDSSL_uncommentModel]?
}
struct HDSSL_uncommentModel: Codable {
    var exhibition_id      : Int?
    var img                : String?
    var look_time          : String? //上次查看时间
    var title              : String?
}
//发布评论
struct HDSSL_backCommentModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : HDSSL_commentResultModel?
}
struct HDSSL_commentResultModel: Codable {
    var comment_id             : Int?//评论id
    var exhibition_list        : [HDSSL_uncommentModel]? //待评论
    var html_url               : String? //分享url
}

//生成画报
struct HDSSL_PaperModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : String?
}
//获取画报数据
struct HDSSL_GetPaperDataModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : HDSSL_PaperDataModel?
}
struct HDSSL_PaperDataModel: Codable {
    var avatar            : String?//用户头像
    var nickname          : String?//用户昵称
    var content           : String?//评论内容
    
    var title             : String?//展览标题
    var exhibition_address: String?//展览地址
    var img               : String?//展览图片
    var star              : Int?//评星
    var is_card           : Int?//是否有证件
    var is_tour           : Int?//是否有导览图标
    var museum_address    : String?//博物馆地址
    
    var qr_code           : String?//二维码地址
    var qr_code_des       : String?//二维码描述
    var qr_code_title     : String?//二维码标题
    
}
