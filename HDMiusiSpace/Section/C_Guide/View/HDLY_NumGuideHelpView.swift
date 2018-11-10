//
//  HDLY_NumGuideHelpView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_NumGuideHelpView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
        
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
