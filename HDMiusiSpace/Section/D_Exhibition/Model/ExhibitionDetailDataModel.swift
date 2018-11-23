//
//  ExhibitionDetailModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/15.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

struct ExhibitionDetailDataModel: Codable {
    var status: Int?
    var msg: String?
    var data: DetailDataModel?
}

struct DetailDataModel: Codable {

    var imgList: [String]?
    var isFavorite: Int?
    var title: String?
    var star: Double?
    var time, exhibitionName, price, address: String?
    var museumImg: String?
    var museumTitle, museumAddress: String?
    var exhibitionHTML: String?
    var isExhibit: Int?
    var exhibitHTML: String?
    var commentList: CommentList?
    var dataList: [DataList]?
    var exhibition_id: Int?
    var share_url: String?
    var museum_id: Int?
    var longitude: String?
    var latitude: String?


    enum CodingKeys: String, CodingKey {
        
        case imgList = "img_list"
        case isFavorite = "is_favorite"
        case title, star, time
        case exhibitionName = "exhibition_name"
        case price, address
        case museumImg = "museum_img"
        case museumTitle = "museum_title"
        case museumAddress = "museum_address"
        case exhibitionHTML = "exhibition_html"
        case isExhibit = "is_exhibit"
        case exhibitHTML = "exhibit_html"
        case commentList = "comment_list"
        case dataList = "data_list"
        case exhibition_id
        case share_url
        case museum_id
        case longitude
        case latitude
    }
}

//评论1
struct CommentList: Codable {
    let total, imgNum: Int
    var list: [CommentListModel]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case imgNum = "img_num"
        case list
    }
}
//评论2
struct CommentListModel: Codable {
    var avatar: String
    var isVip: Int
    var nickname: String
    var star: Int
    var content: String
    var imgList: [String]?
    var isLike, likeNum, commentNum: Int
    var commentDate: String
    var commentId: Int
    
    enum CodingKeys: String, CodingKey {
        case avatar
        case isVip = "is_vip"
        case commentId = "comment_id"
        case nickname, star, content
        case imgList = "img_list"
        case isLike = "is_like"
        case likeNum = "like_num"
        case commentNum = "comment_num"
        case commentDate = "comment_date"
    }
}

//其他部分数据，同馆展览、展览攻略、精选推荐、免费听
struct DataList: Codable {
    let type: Int
    var exhibition: CommenExhibition?
    var raiders: DMuseumRaiders?
    var featured: DMuseumFeatured?
    var listen: DMuseumListen?
}
//同馆展览1
struct CommenExhibition: Codable {
    let exhibitionNum: Int
    let categoryTitle: String
    var list: [ExhibitionList]?
    
    enum CodingKeys: String, CodingKey {
        case exhibitionNum = "exhibition_num"
        case categoryTitle = "category_title"
        case list
    }
}
//同馆展览2
struct ExhibitionList: Codable {
    let exhibitionID: Int
    let img: String
    let title, address: String
    let star: Double
    var iconList: [String]?
    
    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibition_id"
        case img, title, address, star
        case iconList = "icon_list"
    }
}

//精选推荐1
//struct Featured: Codable {
//    let categoryTitle: String
//    var list: [FeaturedList]?
//
//    enum CodingKeys: String, CodingKey {
//        case categoryTitle = "category_title"
//        case list
//    }
//}
////精选推荐2
//struct FeaturedList: Codable {
//    let classNum, classID: Int
//    let img: String
//    let purchases: Int
//    let teacherTitle, teacherName, title: String
//
//    enum CodingKeys: String, CodingKey {
//        case classNum = "class_num"
//        case classID = "class_id"
//        case img, purchases
//        case teacherTitle = "teacher_title"
//        case teacherName = "teacher_name"
//        case title
//    }
//}
////免费听
//struct FreeListenModel: Codable {
//    let categoryTitle, subTitle: String
//    var list: [FreeListenList]?
//
//    enum CodingKeys: String, CodingKey {
//        case categoryTitle = "category_title"
//        case subTitle = "sub_title"
//        case list
//    }
//}
//
//struct FreeListenList: Codable {
//    let audio: String
//    let listenID: Int
//    let img: String
//    let title, exhibitName: String
//
//    enum CodingKeys: String, CodingKey {
//        case audio
//        case listenID = "listen_id"
//        case img, title
//        case exhibitName = "exhibit_name"
//    }
//}
////展览攻略
//struct Raiders: Codable {
//    let author, categoryTitle: String
//    let commentNum, strategyID: Int
//    let img: String
//    let title: String
//    let isFavorite: Int
//
//    enum CodingKeys: String, CodingKey {
//        case author
//        case categoryTitle = "category_title"
//        case commentNum = "comment_num"
//        case strategyID = "strategy_id"
//        case img, title
//        case isFavorite = "is_favorite"
//    }
//}
