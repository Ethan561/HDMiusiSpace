//
//  HDSSL_strategyModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2019/1/2.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import Foundation

struct HDSSL_strategyModel: Codable {
    var status: Int?
    var msg: String?
    var data: HD_strategyModel?
}

struct HD_strategyModel: Codable {
    var strategyID: Int?
    var author: String?
    var img: String?
    var title: String?
    var likes: TStrInt?
    var comments: TStrInt?
    var createdAt: String?
    var url, shareURL: String?
    var isFavorite, isLike: Int?
    var commentList: [TopicCommentList]?
    var share_des: String?
    
    enum CodingKeys: String, CodingKey {
        case strategyID = "strategy_id"
        case author, img, title, likes
        case createdAt = "created_at"
        case url
        case shareURL = "share_url"
        case isFavorite = "is_favorite"
        case isLike = "is_like"
        case comments
        case commentList = "comment_list"
        case share_des
    }
}

