//
//  OrderInfoModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


struct OrderBuyInfoModel: Codable {
    let status: Int?
    let msg: String?
    let data: OrderBuyInfoData?
}

struct OrderBuyInfoData: Codable {
    var goodsID, cateID, title: String?
    var priceType, isVip: Int?
    var price : String?
    var spaceMoney: String?
    var isBuy: Int?
    
    enum CodingKeys: String, CodingKey {
        case goodsID = "goods_id"
        case cateID = "cate_id"
        case title
        case priceType = "price_type"
        case price
        case isVip = "is_vip"
        case spaceMoney = "space_money"
        case isBuy = "is_buy"
    }
}

struct OrderResultModel: Codable {
    let status: Int?
    let msg: String?
    let data: OrderResultData?
}

struct OrderResultData: Codable {
    var isNeedPay: Int?
    var zfbPayString: String?
    var payType, orderID: Int?
    
    enum CodingKeys: String, CodingKey {
        case isNeedPay = "is_need_pay"
        case zfbPayString = "zfb_pay_string"
        case payType = "pay_type"
        case orderID = "order_id"
    }
}


