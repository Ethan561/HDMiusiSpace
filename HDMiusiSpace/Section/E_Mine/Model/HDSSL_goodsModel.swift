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

//交易记录
struct HDSSL_OrderRecordModel: Codable {
    let status: Int?
    let msg: String?
    let data: [OrderRecordDataModel]?
}

struct OrderRecordDataModel: Codable {
    let month: String?
    let dateList: [OrderRecordModel]?
    
    enum CodingKeys: String, CodingKey {
        case month
        case dateList = "date_list"
    }
}

struct OrderRecordModel: Codable {
    let payTime: String?
    let goodsID, cardID: Int? //订单类型1购买课程，2购买普通展览，3购买景区导览，4购买vip,5充值空间币
    let payAmount, title: String?
    let img: String?
    
    enum CodingKeys: String, CodingKey {
        case payTime = "pay_time"
        case goodsID = "goods_id"
        case cardID = "card_id"
        case payAmount = "pay_amount"
        case title, img
    }
}

