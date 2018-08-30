//
//  ReportErrorModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/29.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

struct ReportErrorModel: Codable {
    var status: Int?
    var msg: String?
    var data: ReportErrorData?
}

struct ReportErrorData: Codable {
    var title, articleTitle, img: String
    var type: Int
    var optionList: [ReportErrorOptionList]
    
    enum CodingKeys: String, CodingKey {
        case title
        case articleTitle = "article_title"
        case img, type
        case optionList = "option_list"
    }
}

struct ReportErrorOptionList: Codable {
    var optionID: Int
    var optionTitle: String
    
    enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
        case optionTitle = "option_title"
    }
}

