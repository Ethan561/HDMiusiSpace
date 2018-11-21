//
//  HDSSL_commentListModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

struct HDSSL_commentListModel: Codable {
    var status: Int?
    var msg: String?
    var data: ExComListModel?
}

struct ExComListModel: Codable {
    var total, imgNum: Int?
    var list: [ExCommentModel]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case imgNum = "img_num"
        case list
    }
}

struct ExCommentModel: Codable {
    var commentID: Int?
    var avatar: String?
    var isVip: Int?
    var nickname: String?
    var star: Int?
    var content: String?
    var imgList: [String]?
    var isLike, likeNum, commentNum: Int?
    var commentDate: String?
    var commentList: [ReplyCommentModel]?
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case avatar
        case isVip = "is_vip"
        case nickname, star, content
        case imgList = "img_list"
        case isLike = "is_like"
        case likeNum = "like_num"
        case commentNum = "comment_num"
        case commentDate = "comment_date"
        case commentList = "comment_list"
    }
}

struct ReplyCommentModel: Codable {
    var avatar: String?
    var nickname: String?
    var likeNum: Int?
    var content, commentDate: String?
    
    enum CodingKeys: String, CodingKey {
        case avatar, nickname
        case likeNum = "like_num"
        case content
        case commentDate = "comment_date"
    }
}
