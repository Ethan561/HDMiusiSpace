//
//  HDLY_OpenLocServiceTip.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_OpenLocServiceTip: UIView {

    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        
    }
    
    @IBAction func sureBtnAction(_ sender: Any) {
        UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
        self.removeFromSuperview()
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
}
