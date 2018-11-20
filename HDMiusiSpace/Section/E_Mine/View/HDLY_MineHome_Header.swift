//
//  HDLY_MineHome_Header.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol HDLY_MineHome_Header_Delegate:NSObjectProtocol {
    func pushToMyDetails(type:Int) 
}

class HDLY_MineHome_Header: UIView {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var signatureL: UILabel!
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var followNumberLabel: UILabel!
    @IBOutlet weak var userInfoBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var collectNumberLabel: UILabel!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var foorprintNumberLabel: UILabel!
    
     weak var delegate: HDLY_MineHome_Header_Delegate?
    
    override func awakeFromNib() {
        avatarImgV.layer.cornerRadius = 30
    }
    
   
    @IBAction func showMyfollowAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.pushToMyDetails(type: 0)
        }
    }
    
    @IBAction func showMyClickAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.pushToMyDetails(type: 1)
        }
    }
    
    @IBAction func showMyCardAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.pushToMyDetails(type: 2)
        }
    }
    
    @IBAction func showMyFootprintAction(_ sender: UIButton) {
        if delegate != nil {
            delegate?.pushToMyDetails(type: 3)
        }
    }
}
