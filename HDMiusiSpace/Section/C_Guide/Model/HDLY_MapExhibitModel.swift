//
//  HDLY_MapExhibitModel.swift
//  HDGansuKJG
//
//  Created by liuyi on 2018/10/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

//
struct HDLY_MapModel: Codable {
    let status: Int
    let msg: String
    let data: HDLY_MapData
}

struct HDLY_MapData: Codable {
    let mapPath: String
    let width, height: TStrInt
    let leftTopLongitude, leftTopLatitude, rightBottomLongitude, rightBottomLatitude: String
    var list: [HDLY_MapList]?
    
    enum CodingKeys: String, CodingKey {
        case mapPath = "map_path"
        case width, height
        case leftTopLongitude = "left_top_longitude"
        case leftTopLatitude = "left_top_latitude"
        case rightBottomLongitude = "right_bottom_longitude"
        case rightBottomLatitude = "right_bottom_latitude"
        case list
    }
}

struct HDLY_MapList: Codable {
    let type: Int
    let title: String
    let audio: String
    let longitude, latitude: String
    let star, exhibitionID: TStrInt
    let audio_id: Int
    
    enum CodingKeys: String, CodingKey {
        case type, title, audio, longitude, latitude, star
        case exhibitionID = "exhibition_id"
        case audio_id
    }
    
}


