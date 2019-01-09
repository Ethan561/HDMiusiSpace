//
//  HDLY_MuseumListModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/9.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


struct HDLY_MuseumListModel: Codable {
    let status: Int
    let msg: String
    let data: [MuseumListData]
}

struct MuseumListData: Codable {
    let type: Int
    let list: MuseumListCard?
    let map: MuseumMapModel?
}

struct MuseumListCard: Codable {
    let count: Int
    let distance, title: String
    let museumID: Int
    let list: [MuseumListModel]
    
    enum CodingKeys: String, CodingKey {
        case count, distance, title
        case museumID = "museum_id"
        case list
    }
}

struct MuseumListModel: Codable {
    let id: Int
    let img: String?
    let title: String
    let type, priceType: Int
    var price, vipPrice: String
    let isLock: Int
    
    enum CodingKeys: String, CodingKey {
        case id, img, title, type
        case priceType = "price_type"
        case price
        case vipPrice = "vip_price"
        case isLock = "is_lock"

    }
}

struct MuseumMapModel: Codable {
    let museumID, count: Int
    let distance, title: String
    let id: Int
    let img: String?
    let priceType: Int
    var price, vipPrice: String
    let version: String
    let isLock: Int
    
    enum CodingKeys: String, CodingKey {
        case museumID = "museum_id"
        case count, distance, title, id, img
        case priceType = "price_type"
        case price
        case vipPrice = "vip_price"
        case version
        case isLock = "is_lock"

    }
}

//exhibition_list

struct HDLY_ExhibitionListM: Codable {
    let status: Int
    let msg: String
    let data: [HDLY_ExhibitionListData]
}

struct HDLY_ExhibitionListData: Codable {
    var exhibitionID: Int = 0
    var title: String?
    var img: String?
    var type: Int, priceType: Int = 0
    var price, vipPrice: String
    var isLock: Int, isTz: Int = 0
    var times: String?

    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibition_id"
        case title, img, type
        case priceType = "price_type"
        case price
        case vipPrice = "vip_price"
        case isLock = "is_lock"
        case isTz = "is_tz"
        case times
    }
}

//exhibit_list
struct HDLY_ExhibitList: Codable {
    let status: Int
    let msg: String
    let data: HDLY_ExhibitListD
}

struct HDLY_ExhibitListD: Codable {
    let img: String
    let exhibitionID: String
    let exhibitList: [HDLY_ExhibitListM]
    
    enum CodingKeys: String, CodingKey {
        case img
        case exhibitionID = "exhibition_id"
        case exhibitList = "exhibit_list"
    }
}

struct HDLY_ExhibitListM: Codable {
    var exhibitID: Int = 0
    var title: String?
    var audio: String?
    var longTime: String?
    var isPlaying : Bool?

    enum CodingKeys: String, CodingKey {
        case exhibitID = "exhibit_id"
        case title, audio
        case longTime = "long_time"
        case isPlaying
    }
}






