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

