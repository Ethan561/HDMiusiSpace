//
//  HDSSL_TagModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/4.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation

struct HDSSL_TagModel: Codable {
    var status       : Int?
    var msg          : String?
    var data         : [HDSSL_TagData]?
}

struct HDSSL_TagData: Codable {
    var labelcate_id: Int?           // 类别id
    var type        : Int?           // 是否多选，1单2多
    var title       : String?        // 类别标题
    var des         : String?        // 类别描述
    var list        : [HDSSL_Tag]?   // 类别列表
}

struct HDSSL_Tag : Codable {
    var label_id : Int?              // 标签id
    var title    : String?           // 标签名称
    var is_chose : Int?              // 是否选择，1 Yes，0 No
}


struct UpdateData: Codable {
    var status : Int = 0
    var msg : String
    var data : UpdateModel?
}

struct UpdateModel: Codable {
    var version_id: Int = 0
    var version_no : String
    var version_url : String
    var version_info : String
    var install : Int
    var created_at : String
    var is_new : Int
}



