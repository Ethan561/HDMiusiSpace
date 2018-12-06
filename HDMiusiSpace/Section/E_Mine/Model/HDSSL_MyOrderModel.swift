//
//  HDSSL_MyOrderModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/12/5.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
//---订单列表
struct HDSSLMyOrderModel: Codable {
    var status: Int
    var msg: String?
    var data: [MyOrder]?
}

struct MyOrder: Codable {
    var orderID, cateID: Int?
    var amount, payAmount: String?
    var goodsID, status: Int?
    var title: String?
    var img: String?
    var author: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case cateID = "cate_id"
        case amount
        case payAmount = "pay_amount"
        case goodsID = "goods_id"
        case status, title, img, author
    }
}
//---订单详情
struct HDSSLMyOrderDetailModel: Codable {
    var status: Int
    var msg: String?
    var data: OrderDetailModel?
}

struct OrderDetailModel: Codable {
    var orderID, status: Int?  //订单id //状态1待支付2已完成3已取消
    var amount, payAmount: String? //原价 //实际支付价格
    var cateID, goodsID: Int? //1购买课程 2购买普通展览 3购买景区导览 //商品id
    var orderNo, createdAt, payTime, discount: String? //订单号 //创建时间 //支付时间 //优惠价格
    var title: String? //标题
    var img: String? //图片
    var author: String? //作者
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case status, amount
        case payAmount = "pay_amount"
        case cateID = "cate_id"
        case goodsID = "goods_id"
        case orderNo = "order_no"
        case createdAt = "created_at"
        case payTime = "pay_time"
        case discount, title, img, author
    }
}
