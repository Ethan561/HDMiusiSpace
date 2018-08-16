//
//  NewKnowledgeModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/15.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

/*
 val NEWS_CATEGORY = 0         分类
 val NEWS_LIST = 1             精品推荐 列表形式
 val NEWS_CARD = 2             精品推荐 卡片形式
 val NEWS_LISTEN = 3           轻听随看
 val NEWS_PATERBITY_CARD = 4   亲子互动 卡片形式
 val NEWS_PATERBITY_LIST = 5   亲子互动 列表形式
 val NEWS_TOPIC = 6            精选专题
 */

struct BItemModel:Codable {
    var type: TStrInt?
    var category: BCategoryModel?
    var boutiquelist: BRecmdModel?
    var boutiquecard: BRecmdModel?
    var listen: [BRecmdModel]?
    var interactioncard: BRecmdModel?
    var interactionlist: [BRecmdModel]?
    var topic: [BRecmdModel]?
}

struct BCategoryModel:Codable {
    var type: Int?
    var title: String?
}

struct BRecmdModel:Codable {
    var article_id: TStrInt?
    var title: String?
    var des: String?
    var img: String?
    var price: TStrInt?
    var is_top: TStrInt?
    var is_big: TStrInt?
    var views: TStrInt?
    var classnum: TStrInt?

}


struct BbannerModel:Codable {
    var article_id: TStrInt?
    var title: String?
    var des: String?
    var img: String?
    var views: TStrInt?
    var cate_id: TStrInt?
    var mid: TStrInt?
}




