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
    let listenID: Int
    let title: String
    let cateID, listening: Int
    let img: String
    
    enum CodingKeys: String, CodingKey {
        case listenID = "listen_id"
        case title
        case cateID = "cate_id"
        case listening, img
    }
}

struct ListenDetail: Codable {
    let listenID: Int
    let title, img, voice: String
    let timelong, likes, teacherID: Int
    let url, teacherImg: String
    let isFavorite, isFocus, isLike: Int
    let teacherName, teacherTitle: String
    
    enum CodingKeys: String, CodingKey {
        case listenID = "listen_id"
        case title, img, voice, timelong, likes
        case teacherID = "teacher_id"
        case url
        case teacherImg = "teacher_img"
        case isFavorite = "is_favorite"
        case isFocus = "is_focus"
        case isLike = "is_like"
        case teacherName = "teacher_name"
        case teacherTitle = "teacher_title"
    }
}
