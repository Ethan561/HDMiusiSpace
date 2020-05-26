//
//  CourseChapter.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseChapter: Codable {
    let status: Int
    let msg: String
    let data: ChapterData
}

struct ChapterData: Codable {
    let articleID: TStrInt
    let img: String
    let isFree: Int
    let video: String
    var yprice, oprice, price : String?
    let fileType, isFavorite: TStrInt
    let isBuy: Int
    let sectionList: [ChapterSection]
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img
        case isFree = "is_free"
        case video, yprice, oprice, price
        case fileType = "file_type"
        case isFavorite = "is_favorite"
        case isBuy = "is_buy"
        case sectionList = "section_list"
    }
}

struct ChapterSection: Codable {
    let title: String
    let chapterNum: TStrInt
    let chapterList: [ChapterList]
    
    enum CodingKeys: String, CodingKey {
        case title
        case chapterNum = "chapter_num"
        case chapterList = "chapter_list"
    }
}

struct ChapterList: Codable {
    let title, timeLong, video: String
    let freeType: Int //1免费2vip免费0收费
    let isPlay: Int  //isPlay:是否能播放1能0不能
    var chapter_id: Int = 0
    var is_portrait: Int = 0
    var default_img:String=""
    enum CodingKeys: String, CodingKey {
        case title
        case timeLong = "time_long"
        case video
        case freeType = "free_type"
        case isPlay = "is_play"
        case default_img
        case chapter_id
        case is_portrait
    }
}

