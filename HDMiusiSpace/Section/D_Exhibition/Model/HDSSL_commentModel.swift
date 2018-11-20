//
//  HDSSL_commentModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
struct HDSSL_commentModel: Codable {
    var status      : Int?
    var msg         : String?
    var data        : [HDSSL_uncommentModel]?
}
struct HDSSL_uncommentModel: Codable {
    var exhibition_id      : Int?
    var img                : String?
    var look_time          : String? //上次查看时间
    var title              : String?
}
