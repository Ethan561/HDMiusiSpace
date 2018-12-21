//
//  HDLY_Topic_CollectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Topic_CollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var newTipL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        newTipL.backgroundColor = BaseColor.mainRedColor
        
    }

    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDLY_Topic_CollectionCell {
        let cell : HDLY_Topic_CollectionCell = (collectionView.dequeueReusableCell(withReuseIdentifier: HDLY_Topic_CollectionCell.className, for: indexPath) as! HDLY_Topic_CollectionCell)
        // cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
}
