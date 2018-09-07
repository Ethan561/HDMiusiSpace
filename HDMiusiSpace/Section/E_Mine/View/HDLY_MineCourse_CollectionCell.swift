//
//  HDLY_MineCourse_CollectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MineCourse_CollectionCell: UICollectionViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        
    }
    
    
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDLY_MineCourse_CollectionCell {
        let cell : HDLY_MineCourse_CollectionCell = (collectionView.dequeueReusableCell(withReuseIdentifier: HDLY_MineCourse_CollectionCell.className, for: indexPath) as! HDLY_MineCourse_CollectionCell)
        // cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
}
