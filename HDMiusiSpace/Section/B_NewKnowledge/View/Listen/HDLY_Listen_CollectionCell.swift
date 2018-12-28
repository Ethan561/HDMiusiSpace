//
//  HDLY_Listen_CollectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Listen_CollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var voiceBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
    }
    
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDLY_Listen_CollectionCell {
        let cell : HDLY_Listen_CollectionCell = (collectionView.dequeueReusableCell(withReuseIdentifier: HDLY_Listen_CollectionCell.className, for: indexPath) as! HDLY_Listen_CollectionCell)
        //cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
}









