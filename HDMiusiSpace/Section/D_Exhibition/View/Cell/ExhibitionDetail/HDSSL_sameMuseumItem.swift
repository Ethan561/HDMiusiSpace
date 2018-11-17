//
//  HDSSL_sameMuseumItem.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_sameMuseumItem: UICollectionViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var item_title: UILabel!
    @IBOutlet weak var item_loc: UILabel!
    @IBOutlet weak var item_iconBg: UIView!
    @IBOutlet weak var item_star: UIImageView!
    @IBOutlet weak var item_starNum: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.configShadow(cornerRadius: 5.0, shadowColor: UIColor.HexColor(0xF5F5F4), shadowOpacity: 0.6, shadowRadius: 15, shadowOffset: CGSize.zero)
    }
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDSSL_sameMuseumItem {
        let cell : HDSSL_sameMuseumItem = (collectionView.dequeueReusableCell(withReuseIdentifier: HDSSL_sameMuseumItem.className, for: indexPath) as! HDSSL_sameMuseumItem)
        return cell
    }
}
