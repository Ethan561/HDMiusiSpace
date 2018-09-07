//
//  HDSSL_searchTagModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/7.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation
struct HDSSL_searchTagModel:Codable {
    var status             : Int?
    var msg                : String?
    var data               : [HDSSL_SearchTag]?
}

struct HDSSL_SearchTag:Codable {
    var type          : Int?
    var title         : String?
}
