//
//  HDLY_MapExhibitModel.swift
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct HDLY_MapExhibitModel: Codable {
    let status: Int
    let msg: String
    let data: [MapExhibitData]
}

struct MapExhibitData: Codable {
    var autonum: Int = 0
    var mxAnd, mxIos: String?
    var exhibitCount: Int = 0
    var exhibit: [MapExhibit]
    var x, y: Int
    
    enum CodingKeys: String, CodingKey {
        case autonum
        case mxAnd = "mx_and"
        case mxIos = "mx_ios"
        case exhibitCount = "exhibit_count"
        case exhibit
        case x, y
    }
}

struct MapExhibit: Codable {
    var exhibitID: Int
    var exhibitName, exhibitIcon1, exhibitListImg: String?
    var mapID, x, y: Int
    var content, audio, timelong: String
    var audiotime: Int
    var autoString: String
    
    enum CodingKeys: String, CodingKey {
        case exhibitID = "exhibit_id"
        case exhibitName = "exhibit_name"
        case exhibitIcon1 = "exhibit_icon1"
        case exhibitListImg = "exhibit_list_img"
        case mapID = "map_id"
        case x, y, content, audio, timelong, audiotime
        case autoString = "auto_string"
    }
}

struct HDMapDataModel:Codable {
    var status: Int = 0
    var data = [MapModel]()
    var msg: String?
}

struct MapModel :Codable{
    var width: Int = 0
    var height: Int = 0
    var map_id: Int = 0
    var floor_id: Int = 0
    var map_name: String?
    var map_path: String?
    
}

//路线
struct HDLY_RoadModel: Codable {
    var status: Int = 0
    var msg: String?
    var data: [HDLY_RoadDataModel]?
}

struct HDLY_RoadDataModel: Codable {
    var roadID: Int = 0
    var roadName, roadImg, roadLong: String?
    var exhibitCounts: Int = 0
    var exhibit: [RoadDatumExhibit]?
    
    enum CodingKeys: String, CodingKey {
        case roadID = "road_id"
        case roadName = "road_name"
        case roadImg = "road_img"
        case roadLong = "road_long"
        case exhibitCounts = "exhibit_counts"
        case exhibit
    }
}

struct RoadDatumExhibit: Codable {
    var exhibitionID: Int = 0
    var exhibitionName, exhibitionAddress: String?
    var exhibits: [RoadExhibit]?
    var collapsed: Bool?

    enum CodingKeys: String, CodingKey {
        case exhibitionID = "exhibition_id"
        case exhibitionName = "exhibition_name"
        case exhibitionAddress = "exhibition_address"
        case exhibits
        case collapsed
    }
}

struct RoadExhibit: Codable {
    let exhibitID, exhibitName: String
    
    enum CodingKeys: String, CodingKey {
        case exhibitID = "exhibit_id"
        case exhibitName = "exhibit_name"
    }
}


