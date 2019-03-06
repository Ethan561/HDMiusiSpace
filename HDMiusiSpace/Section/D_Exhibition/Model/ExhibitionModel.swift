//
//  ExhibitionModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

struct HDSSL_dExhibition: Codable {
    var exhibit_id         : Int?    //展览id
    var title             : String?  //名字
    var img               : String?  //图片
    var address           : String?  //地址
    var icon_list         : [String]?//服务图标地址
}

struct HDSSL_dMuseum: Codable {
    var museum_id         : Int?     //博物馆id
    var title             : String?  //名字
    var img               : String?  //图片
    var address           : String?  //博物馆地址
    var icon_list         : [String]?//服务图标地址
}
//本地保存选中的城市
struct HDSSL_selectedCity:Codable {
    var city_id          : Int?     //选择城市id
    var city_name        : String?  //名字
}


struct HDLY_dExhibitionListM: Codable {
    let status: Int
    let msg: String
    let data: [HDLY_dExhibitionListD]
}

struct HDLY_dExhibitionListD: Codable {
    var exhibitionID: Int = 0
    var img: String?
    var title, address: String?
    var star: TStrInt?
    var iconList: [String]?
    
    var iconTitleString: NSMutableAttributedString?
    
    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibition_id"
        case img, title, address
        case star
        case iconList = "icon_list"
    }
}


struct HDLY_dMuseumListM: Codable {
    let status: Int
    let msg: String
    let data: [HDLY_dMuseumListD]
}

struct HDLY_dMuseumListD: Codable {
    var museumID: Int = 0
    var img: String?
    var title, address, distance: String?
    var iconList: [String]?
    var isGg: Int = 0
    var ggTitle: String?
    var isLive: Int = 0
    var liveTitle: String?
    var isFree: Int = 0
    var price:  String?
    var isFavorite: Int = 0

    enum CodingKeys: String, CodingKey {
        case museumID = "museum_id"
        case img, title, address, distance
        case iconList = "icon_list"
        case isGg = "is_gg"
        case ggTitle = "gg_title"
        case isLive = "is_live"
        case liveTitle = "live_title"
        case isFree = "is_free"
        case price
        case isFavorite = "is_favorite"
    }
}

struct MyCollectStrategyData: Codable {
    let status: Int
    let msg: String
    let data: [StrategyModel]
}

struct StrategyModel: Codable {
    var author :String
    var comment_num  :Int
    var likes_num    :Int
    var strategy_id   :Int
    var img    :String
    var title:String
}

