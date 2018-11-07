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
        
//        tagBtn.setImage(UIImage.init(named: "xz_qtsk_icon_arrow_on"), for: UIControlState.selected)
//        tagBtn.setTitle("", for: UIControlState.selected)
//
//        tagBtn.setImage(UIImage.init(named: "xinzhi_qingtingsuikan_icon_Arrow_default"), for: UIControlState.normal)
//        tagBtn.setTitle("", for: UIControlState.normal)
        
    }
    
    
}





