//
//  HDSSL_goodsModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/12/4.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
struct HDSSL_goodsModel: Codable {
    var status: Int
    var msg: String?
    var data: GoodsData?
}

struct GoodsData: Codable {
    var spaceMoney: String?
    var goodsList: [GoodsList]?
    
    enum CodingKeys: String, CodingKey {
        case spaceMoney = "space_money"
        case goodsList = "goods_list"
    }
}

struct GoodsList: Codable {
    var goodsID: Int?
    var price: String?
    var spaceMoney, vipSpaceMoney: Int?
    
    enum CodingKeys: String, CodingKey {
        case goodsID = "goods_id"
        case price
        case spaceMoney = "space_money"
        case vipSpaceMoney = "vip_space_money"
    }
}
