//
//  HDLY_ExhibitionMuseumModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


struct HDLY_ExhibitionMuseumModel: Codable {
    var status: Int = 0
    var msg: String?
    var data: ExhibitionMuseumData?
}

struct ExhibitionMuseumData: Codable {
    var img: String?
    var isFavorite: Int?
    var title, time, price, address: String?
    var iconList: [String]?
    var museumHTML: String?
    var isArea: Int?
    var areaHTML: String?
    var isTourGuide: Int?
    var tourGuide: String?
    var dataList: [DataList]?
    
    enum CodingKeys: String, CodingKey {
        case img
        case isFavorite = "is_favorite"
        case title, time, price, address
        case iconList = "icon_list"
        case museumHTML = "museum_html"
        case isArea = "is_area"
        case areaHTML = "area_html"
        case isTourGuide = "is_tour_guide"
        case tourGuide = "tour_guide"
        case dataList = "data_list"
    }
}

struct ExhibitionMuseumDataList: Codable {
    var type: Int = 0
    var exhibition: DMuseumExhibition?
    var raiders: DMuseumRaiders?
    var featured: DMuseumFeatured?
    var listen: DMuseumListen?
}

struct DMuseumExhibition: Codable {
    var exhibitionNum: Int?
    var categoryTitle: String?
    var list: [ExhibitionList]?
    
    enum CodingKeys: String, CodingKey {
        case exhibitionNum = "exhibition_num"
        case categoryTitle = "category_title"
        case list
    }
}

struct DExhibitionList: Codable {
    var exhibitionID: Int?
    var img: String?
    var title, address: String?
    var star: Double?
    var iconList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibition_id"
        case img, title, address, star
        case iconList = "icon_list"
    }
}

struct DMuseumFeatured: Codable {
    var categoryTitle: String?
    var list: [DMuseumFeaturedList]?
    
    enum CodingKeys: String, CodingKey {
        case categoryTitle = "category_title"
        case list
    }
}

struct DMuseumFeaturedList: Codable {
    var classNum, classID: Int?
    var img: String?
    var purchases: Int?
    var teacherTitle, teacherName, title: String?
    
    enum CodingKeys: String, CodingKey {
        case classNum = "class_num"
        case classID = "class_id"
        case img, purchases
        case teacherTitle = "teacher_title"
        case teacherName = "teacher_name"
        case title
    }
}

struct DMuseumListen: Codable {
    var categoryTitle, subTitle: String?
    var list: [DMuseumListenList]?
    
    enum CodingKeys: String, CodingKey {
        case categoryTitle = "category_title"
        case subTitle = "sub_title"
        case list
    }
}

struct DMuseumListenList: Codable {
    var audio: String?
    var listenID: Int = 0
    var img: String?
    var title, exhibitName: String?
    var isPlaying : Bool?

    enum CodingKeys: String, CodingKey {
        case audio
        case listenID = "listen_id"
        case img, title
        case exhibitName = "exhibit_name"
        case isPlaying
    }
}

struct DMuseumRaiders: Codable {
    var author, categoryTitle: String?
    var commentNum, strategyID: Int?
    var img: String?
    var title: String?
    var isFavorite: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case author
        case categoryTitle = "category_title"
        case commentNum = "comment_num"
        case strategyID = "strategy_id"
        case img, title
        case isFavorite = "is_favorite"
    }
}

//参观攻略
struct DStrategyListModel: Codable {
    let status: Int?
    let msg: String?
    let data: [DStrategyListData]?
}

struct DStrategyListData: Codable {
    var author, categoryTitle: String?
    var commentNum, strategyID: Int?
    var img: String?
    var title: String?
    var isFavorite: Int?
    
    enum CodingKeys: String, CodingKey {
        case author
        case categoryTitle = "category_title"
        case commentNum = "comment_num"
        case strategyID = "strategy_id"
        case img, title
        case isFavorite = "is_favorite"
    }
}

