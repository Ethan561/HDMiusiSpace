//
//  CountyDataModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
struct CountyDataModel: Codable {
    var status        : Int?
    var msg           : String?
    var data          : CountyDataSecModel?
}
struct CountyDataSecModel: Codable {
    var type_list        : [CountyTypeListModel]?
    var country_list     : [CountyListModel]?
}
//国际左侧列表
struct CountyTypeListModel: Codable {
    var type              : Int? //类型，大洲
    var type_name         : String? //名字
}
//国际热门
struct CountyListModel: Codable {
    var city_name     : String?  //名字
    var city_id       : Int?  //id
    var museum_name   : String?  //博物馆名字
    var img           : String?  //图片
}
