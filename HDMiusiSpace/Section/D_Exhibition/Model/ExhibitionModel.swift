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
