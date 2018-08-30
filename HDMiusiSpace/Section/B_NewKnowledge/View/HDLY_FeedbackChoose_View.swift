//
//  HDLY_FeedbackChoose_View.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/29.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

typealias ChooseBlock = (Int) -> (Void)

class HDLY_FeedbackChoose_View: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tapBtn1: UIButton!
    @IBOutlet weak var tapBtn2: UIButton!
    var tapBlock: ChooseBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 2
    }
    
    @IBAction func chooseAction(_ sender: UIButton) {
        if tapBlock != nil {
            let index: Int = sender.tag - 100
            tapBlock!(index)
        }
    }
    
    
}
