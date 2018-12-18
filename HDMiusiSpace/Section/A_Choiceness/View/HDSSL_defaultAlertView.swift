//
//  HDSSL_defaultAlertView.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/12/4.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias BlockAlertResult = (_ type: Int)->Void

class HDSSL_defaultAlertView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var alertBg: UIView!
    @IBOutlet weak var topTitleLabel: UILabel! //标题
    @IBOutlet weak var titleLab: UILabel!//描述
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_sure: UIButton!
    
    var blockResult: BlockAlertResult! //
    
    func blockSelected(block: @escaping BlockAlertResult) -> Void {
        blockResult = block
    }
    
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.backgroundColor = UIColor.init(white: 0.2, alpha: 0.7)
    }
    @IBAction func action_cancel(_ sender: UIButton) {
        self.removeFromSuperview()
        weak var weakself = self
        
        if weakself?.blockResult != nil {
            weakself?.blockResult!(0)
        }
    }
    @IBAction func action_sure(_ sender: UIButton) {
        self.removeFromSuperview()
        weak var weakself = self
        
        if weakself?.blockResult != nil {
            weakself?.blockResult!(1)
        }
    }
    
}
