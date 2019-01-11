//
//  HDZQ_DynamicDeleteView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2019/1/11.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_DynamicDeleteView: UIView {
    
    var sureBlock:(() -> ())?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tipTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 4
    }
    
    @IBAction func sureAction(_ sender: UIButton) {
        if sureBlock != nil {
            self.sureBlock!()
            self.removeFromSuperview()
        }
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}
