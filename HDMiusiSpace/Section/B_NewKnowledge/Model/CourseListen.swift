//
//  CourseListen.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseListen: Codable {
    let status: Int
    let msg: String
    let data: CourseListenData
}

struct CourseListenData: Codable {
    let cates: [ListenTags]
    let list:  [ListenList]
}

struct ListenTags: Codable {
    let cateID: Int
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case cateID = "cate_id"
        case title
    }
}

struct ListenList: Codable {
    var listenID: Int?
    var title: String?
    var cateID, listening: Int?
    var img: String?
    var is_voice: Int = 0
    var voice: String?
    enum CodingKeys: String, CodingKey {
        case listenID = "listen_id"
        case title
        case cateID = "cate_id"
        case listening, img
        case is_voice
        case voice
    }
}

//  ListenDetail
struct ListenDetail: Codable {
    var listenID: TStrInt?
    var title, img , icon, voice: String?
    var timelong, likes, teacherID, isComment: TStrInt?
    var comments: Int?
    var url, teacherImg: String?
    var isFavorite, isFocus, isLike: Int?
    var teacherName, teacherTitle: String?
    var commentList: [TopicCommentList]?
    var share_url: String?
    var is_voice: Int = 0

    enum CodingKeys: String, CodingKey {
        case listenID = "listen_id"
        case title, img, voice, timelong, likes, icon
        case teacherID = "teacher_id"
        case isComment = "is_comment"
        case comments, url
        case teacherImg = "teacher_img"
        case isFavorite = "is_favorite"
        case isFocus = "is_focus"
        case isLike = "is_like"
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
        case commentList = "comment_list"
        case share_url
        case is_voice
    }
}


struct ListenCommentList: Codable {
    var uid: Int?
    var comment: String?
    var content: String?
    var likeNum: TStrInt?
    var createdAt: String?
    var commentID: Int?
    var avatar, nickname: String?
    var isLike: Int?
    var list: [ListenReturnList]?
    
    enum CodingKeys: String, CodingKey {
        case uid, comment
        case likeNum = "like_num"
        case createdAt = "created_at"
        case commentID = "comment_id"
        case avatar, nickname, content
        case isLike = "is_like"
        case list
    }
}

struct ListenReturnList: Codable {
    let commentID, uid, parentUid: Int?
    let comment, uNickname, parentNickname: String?
    
    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case uid
        case parentUid = "parent_uid"
        case comment
        case uNickname = "u_nickname"
        case parentNickname = "parent_nickname"
    }
}


struct LikeModel: Codable {
    var is_like: TStrInt?
    var like_num: TStrInt?
}

struct FavoriteModel: Codable {
    var is_favorite: TStrInt?
    var favorite_num: TStrInt?
}



