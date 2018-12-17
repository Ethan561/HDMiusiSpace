//
//  TopicModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct TopicModel: Codable {
    var status: Int?
    var msg: String?
    var data: TopicModelData?
}

struct TopicModelData: Codable {
    var articleID: TStrInt
    var img, title: String
    var comments, likes: TStrInt
    var url: String
    var isFavorite, isLike, isComment: Int
    var recommendsList: [TopicRecommendsList]
    var commentList: [TopicCommentList]
    var platform_title: String?
    var platform_icon: String?
    var created_at: String?

    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title
        case isComment = "is_comment"
        case comments, likes, url
        case isFavorite = "is_favorite"
        case isLike = "is_like"
        case recommendsList = "recommends_list"
        case commentList = "comment_list"
        case platform_title
        case platform_icon
        case created_at

    }
}

struct TopicCommentList: Codable {
    var uid: Int
    var comment: String
    var likeNum: TStrInt
    var createdAt: String
    var commentID: Int
    var avatar, nickname: String
    var isLike: Int
    var list: [TopicSecdCommentList]
    var showAll = false
    var height = 0
    var topHeight = 0
    enum CodingKeys: String, CodingKey {
        case uid, comment
        case likeNum = "like_num"
        case createdAt = "created_at"
        case commentID = "comment_id"
        case avatar, nickname
        case isLike = "is_like"
        case list
    }
}

struct TopicSecdCommentList: Codable {
    var commentID, uid, parentUid: Int
    var comment, uNickname, parentNickname: String
    var height = 0
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case uid
        case parentUid = "parent_uid"
        case comment
        case uNickname = "u_nickname"
        case parentNickname = "parent_nickname"
    }
}

struct TopicRecommendsList: Codable {
    var articleID: Int
    var img, title: String
    var cateID: Int
    var likes, comments: TStrInt
    var plat_title, keywords: String

    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title
        case cateID = "cate_id"
        case likes, comments
        case plat_title, keywords
    }
}

