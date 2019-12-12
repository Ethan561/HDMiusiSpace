//
//  HDLY_NumCollectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_NumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var tagBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleL.layer.cornerRadius = 8
        titleL.layer.masksToBounds = true
//        titleL.textColor = UIColor.HexColor(0x4A4A4A)
        
//        tagBtn.setImage(UIImage.init(named: "xz_qtsk_icon_arrow_on"), for: UIControl.State.selected)
//        tagBtn.setTitle("", for: UIControl.State.selected)
//
//        tagBtn.setImage(UIImage.init(named: "xinzhi_qingtingsuikan_icon_Arrow_default"), for: UIControl.State.normal)
//        tagBtn.setTitle("", for: UIControl.State.normal)
        
    }
    
    // 设置高亮效果
    override var isHighlighted: Bool {
        willSet {
            if newValue {
                titleL.backgroundColor = UIColor.darkGray
            } else {
                titleL.backgroundColor = UIColor.HexColor(0xEEEEEE)
            }
        }
    }
    
    // 设置选中选中
    override var isSelected: Bool {
        willSet {
            if newValue {
                
            } else {
                
            }
        }
    }
}





