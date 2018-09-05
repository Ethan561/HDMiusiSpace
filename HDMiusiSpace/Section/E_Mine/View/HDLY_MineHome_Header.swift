//
//  HDLY_MineHome_Header.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MineHome_Header: UIView {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var signatureL: UILabel!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var userInfoBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    override func awakeFromNib() {
        avatarImgV.layer.cornerRadius = 30
        
    }
    
    

}
