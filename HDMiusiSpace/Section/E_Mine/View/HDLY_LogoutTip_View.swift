//
//  HDLY_LogoutTip_View.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_LogoutTip_View: UIView {

    var sureBlock:(() -> ())?
    
    @IBOutlet weak var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        if sureBlock != nil {
            self.sureBlock!()
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    
    
}
