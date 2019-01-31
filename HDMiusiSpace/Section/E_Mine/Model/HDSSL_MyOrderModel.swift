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
    var isComment:Int?//是否评论1已评论0未评论
    var isShare:Int? //是否分享1已分享0未分享
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case cateID = "cate_id"
        case amount
        case payAmount = "pay_amount"
        case goodsID = "goods_id"
        case status, title, img, author
        case isComment = "is_comment"
        case isShare = "is_share"
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
    var classNum:Int? //课时
    var isComment:Int?//是否评论1已评论0未评论
    var isShare:Int? //是否分享1已分享0未分享
    var phone: String?//客服电话
    var type:Int?  //展览类型 0数字编号版1列表版2扫一扫版
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case status, amount
        case payAmount = "pay_amount"
        case cateID = "cate_id"
        case goodsID = "goods_id"
        case orderNo = "order_no"
        case createdAt = "created_at"
        case payTime = "pay_time"
        case discount, title, img, author, phone
        case classNum = "class_num"
        case isComment = "is_comment"
        case isShare = "is_share"
        case type
    }
}
//---订单分享图片
struct HDSSLMyOrderSharePicModel: Codable {
    var status: Int
    var msg: String?
    var data: String?
}
//---订单删除
struct HDSSLDeleteOrderModel: Codable {
    var status: Int
    var msg: String?
    var data: TStrInt?
}
//获取画报数据
struct HDSSL_shareOrderDataModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : HDSSL_shareOrderModel?
}
struct HDSSL_shareOrderModel: Codable {
    var uid               : Int?   //uid
    var goods_id          : Int?   //课程id
    var pay_amount        : String?//支付金额
    var title             : String?//课程标题
    var img               : String?//课程图片
    var avatar            : String?//用户头像
    var nickname          : String?//用户昵称
    var des               : String?//课程描述
    var author            : String?//作者
    var sub_title         : String?//作者头衔
    var class_num         : Int?   //课时
    var study_num         : Int?   //学习人数
    var qr_code           : String?//二维码地址
    var qr_code_des       : String?//二维码描述
    var qr_code_title     : String?//二维码标题
}
