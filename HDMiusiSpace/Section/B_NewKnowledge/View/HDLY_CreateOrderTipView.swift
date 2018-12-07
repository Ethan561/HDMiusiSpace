//
//  HDLY_ CreateOrderTipView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CreateOrderTipView: UIView {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var spaceCoinL: UILabel!
    @IBOutlet weak var successView: UIView!
    
    var sureBlock: (() -> (Void))?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sureBtn.layer.cornerRadius = 28
        sureBtn.layer.masksToBounds = true
        
        
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    
    @IBAction func sureBtnAction(_ sender: Any) {
        if sureBlock != nil {
            self.sureBlock!()
        }
        
    }
    
    
    
    
}
