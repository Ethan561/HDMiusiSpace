//
//  HDLY_OpenVipTipView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_OpenVipTipView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var sureBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var model:HDLY_ExhibitionListData?
    var sureBlock:((HDLY_ExhibitionListData) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sureBtn.layer.cornerRadius = 19
        sureBtn.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.removeFromSuperview()
        
    }
    
    @IBAction func sureAction(_ sender: Any) {
        
        if self.sureBlock != nil && self.model != nil {
            self.sureBlock!(model!)
        }
        
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }


}
