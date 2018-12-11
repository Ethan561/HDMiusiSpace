//
//  HDLY_QuestionContent_Header.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/25.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_QuestionContent_Header: UIView {

    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var questionL: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImgV.layer.cornerRadius = 15
        
    }
    

}
