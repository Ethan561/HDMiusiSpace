//
//  HDLY_ChangeCityAlert.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/4.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ChangeCityAlert: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cancleBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var tipL: UILabel!
    
    var sureBtnBlock: (() -> ())?
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        
        
    }
    
    
    @IBAction func cancleBtnAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func sureBtnAction(_ sender: Any) {
        self.removeFromSuperview()
        if self.sureBtnBlock != nil {
            self.sureBtnBlock!()
        }
    }

}
