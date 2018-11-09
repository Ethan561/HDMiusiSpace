//
//  CityModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/8.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
struct CityDataModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : CityDataSecModel?
}
struct CityDataSecModel: Codable {
    var hot_city  : [CityModel]?
    var city_list : [CitiesModel]?
}
struct CitiesModel: Codable {
    var key_name  : String?
    var city_list : [CityModel]?
}
struct CityModel: Codable {
    var city_id   : Int?
    var city_name : String?
}
