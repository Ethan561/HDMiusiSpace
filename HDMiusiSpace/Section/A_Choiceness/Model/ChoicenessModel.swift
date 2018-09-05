//
//  ChoicenessModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/1.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct ChoicenessModel: Codable {
    var status: Int?
    var msg: String?
    var data: [ChoicenessModelData]?
}

// type  0：category ，1：item_list，2：item_card ，3：item_class

struct ChoicenessModelData: Codable {
    let type: TStrInt
    let itemList: ChoicenessItemList?
    let category: ChoicenessCategory?
    let itemClass: [BRecmdModel]?
    let itemCard: ChoicenessItemCard?
    
    enum CodingKeys: String, CodingKey {
        case type
        case itemList = "item_list"
        case category
        case itemClass = "item_class"
        case itemCard = "item_card"
    }
}

struct ChoicenessCategory: Codable {
    let title: String
    let type: Int
}

struct ChoicenessItemCard: Codable {
    let daycardID, cardID, articleID: Int
    let img: String
    let isFavorite, type: Int
    
    enum CodingKeys: String, CodingKey {
        case daycardID = "daycard_id"
        case cardID = "card_id"
        case articleID = "article_id"
        case img
        case isFavorite = "is_favorite"
        case type
    }
}

struct ChoicenessItemClass: Codable {
    let articleID: Int
    let title, img: String
    let isTop: Int
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case title, img
        case isTop = "is_top"
    }
}

struct ChoicenessItemList: Codable {
    let articleID: TStrInt
    let img, title, platTitle, keywords: String
    let likes, comments: TStrInt
    
    enum CodingKeys: String, CodingKey {
        case articleID = "article_id"
        case img, title
        case platTitle = "plat_title"
        case keywords, likes, comments
    }
}


struct ChoicenessModelTest: Codable {
    var status: Int?
    var msg: String?
    var data: [ChoicenessModelData]
}


