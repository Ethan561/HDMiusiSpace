//
//  HDLY_ListenTags_CollectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/18.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ListenTags_CollectionCell: UICollectionViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var tagBtn: UIButton!
    var isFolder = false {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleL.layer.cornerRadius = 15
        titleL.layer.masksToBounds = true
        titleL.textColor = UIColor.HexColor(0x4A4A4A)

        tagBtn.setImage(UIImage.init(named: "xz_qtsk_icon_arrow_on"), for: UIControl.State.selected)
        tagBtn.setTitle("", for: UIControl.State.selected)
        
        tagBtn.setImage(UIImage.init(named: "xinzhi_qingtingsuikan_icon_Arrow_default"), for: UIControl.State.normal)
        tagBtn.setTitle("", for: UIControl.State.normal)
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected  == true{
                if isFolder {
        
                }else {
                    self.titleL.backgroundColor = UIColor.HexColor(0xE8593E)
                    self.titleL.textColor = UIColor.HexColor(0xFFFFFF)
                }
            }else {
                if isFolder {

                }else {
                    self.titleL.backgroundColor = UIColor.HexColor(0xEEEEEE)
                    self.titleL.textColor = UIColor.HexColor(0x4A4A4A)

                }
            }
        }
    }
    
}
