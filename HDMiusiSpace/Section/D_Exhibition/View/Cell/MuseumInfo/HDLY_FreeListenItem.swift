//
//  HDLY_FreeListenClctCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/19.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_FreeListenItem: UICollectionViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var progressV: UIProgressView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var imgBgView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgBgView.layer.cornerRadius = 8
        imgBgView.layer.masksToBounds = true
        playBtn.setImage(UIImage.init(named: "kz_mft_icon_play"), for: .normal)
        playBtn.setImage(UIImage.init(named: "kz_mft_icon_pause"), for: .selected)
        playBtn.isUserInteractionEnabled = false
        
        progressV.progressTintColor = UIColor.red
    }
    
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDLY_FreeListenItem {
        let cell : HDLY_FreeListenItem = (collectionView.dequeueReusableCell(withReuseIdentifier: HDLY_FreeListenItem.className, for: indexPath) as! HDLY_FreeListenItem)
        // cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
}
