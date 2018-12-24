//
//  HDLY_QuestionNoticeTip.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_QuestionNoticeTip: UIView {

    @IBOutlet weak var tipBgView: UIView!
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipBgView.layer.cornerRadius = 6
        tipBgView.layer.masksToBounds = true
        
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    

}
