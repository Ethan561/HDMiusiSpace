//
//  HDLY_MuseumRecmdItem.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/19.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumRecmdItem: UICollectionViewCell {

 
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var courseL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
        
    }
    
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDLY_MuseumRecmdItem {
        let cell : HDLY_MuseumRecmdItem = (collectionView.dequeueReusableCell(withReuseIdentifier: HDLY_MuseumRecmdItem.className, for: indexPath) as! HDLY_MuseumRecmdItem)
        // cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }

}
