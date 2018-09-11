//
//  HDLY_GenderTip_View.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/10.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_GenderTip_View: UIView {

    var sureBlock:((_ type: Int) -> ())?
    
    @IBOutlet weak var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
        
    }
    
    @IBAction func chooseManAction(_ sender: UIButton) {
        if sureBlock != nil {
            self.sureBlock!(1)
        }
        self.removeFromSuperview()
    }
    
    @IBAction func chooseWomanAction(_ sender: UIButton) {
        if sureBlock != nil {
            self.sureBlock!(2)
        }
        self.removeFromSuperview()
    }
}
