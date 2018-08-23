//
//  CourseModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct CourseModel: Codable {
    let status: Int
    let msg: String
    let data: DataClass
}

struct DataClass: Codable {
    let articleID: Int
    let img, title, url, notice: String
    let comment: Int
    let buynotice: String
    let isFree: Int
    let video: String?
    let yprice, price: Int
    let timg, teacher, tdes, tcontent: String
    let isFavorite, isFocus, isLike: Int
    let recommend: [Recommend]
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title, url, notice, comment, buynotice
        case isFree = "is_free"
        case video, yprice, price, timg, teacher, tdes, tcontent
        case isFavorite = "is_favorite"
        case isFocus = "is_focus"
        case isLike = "is_like"
        case recommend
    }
}

struct Recommend: Codable {
    let articleID: Int
    let title, img: String
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, img
    }
}


