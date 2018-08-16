//
//  HDPagerViewCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/10.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDPagerViewCell: FSPagerViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var countL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // remove the default shadow.
        self.contentView.layer.shadowColor = nil
        self.contentView.layer.shadowRadius = 0
        self.contentView.layer.shadowOpacity = 0
        self.contentView.layer.shadowOffset = .zero
    }
    
}
