//
//  HDSSL_sameMuseumItem.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_sameMuseumItem: UICollectionViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var item_img: UIImageView!
    @IBOutlet weak var item_title: UILabel!
    @IBOutlet weak var item_loc: UILabel!
    @IBOutlet weak var item_iconBg: UIView!
    @IBOutlet weak var item_star: UIImageView!
    @IBOutlet weak var item_starNum: UILabel!
    
    var model :ExhibitionList? {
        didSet {
            showCellData()
        }
    }
    
    func showCellData() {
        for imgV in item_iconBg.subviews {
            imgV.removeFromSuperview()
        }
        if self.model != nil {
            if  model?.img != nil  {
                item_img.kf.setImage(with: URL.init(string: (model!.img)), placeholder: UIImage.grayImage(sourceImageV: item_img), options: nil, progressBlock: nil, completionHandler: nil)
            }
            item_title.text = model!.title
            item_loc.text = model!.address
            item_starNum.text = model!.star.string
            
            let star: Float = Float(model!.star.string) ?? 0.0
            var imgStr = ""
            if star < 2.0 {
                imgStr = "exhibitionCmt_1_5"
            }else if star >= 2.0 && star < 4.0 {
                imgStr = "exhibitionCmt_2_5"
            }else if star >= 4.0 && star < 6.0 {
                imgStr = "exhibitionCmt_3_5"
            }else if star >= 6.0 && star < 8.0 {
                imgStr = "exhibitionCmt_4_5"
            }else if star >= 8.0 {
                imgStr = "exhibitionCmt_5_5"
            }
            item_star.image = UIImage.init(named: imgStr)
            
            var x:CGFloat = 0
            var imgWArr = [CGFloat]()
            
            for (i,imgStr) in model!.iconList!.enumerated() {
                let imgV = UIImageView()
                imgV.contentMode = .scaleAspectFit
                imgV.kf.setImage(with: URL.init(string: imgStr), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
                    
                    let imgSize = img!.size
                    let imgH: CGFloat = 15
                    let imgW: CGFloat = 15*imgSize.width/imgSize.height
                    imgWArr.append(imgW)
                    if i > 0 {
                        let w = imgWArr[i-1]
                        x = x + w
                    }
                    imgV.frame = CGRect.init(x: x, y: 2, width: imgW, height: imgH)
                    self.item_iconBg.addSubview(imgV)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        shadowView.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.2, shadowRadius: 6, shadowOffset: CGSize.zero)
    }
    //类方法，创建cell
    class func getMyCollectionCell(collectionView : UICollectionView, indexPath : IndexPath) -> HDSSL_sameMuseumItem {
        let cell : HDSSL_sameMuseumItem = (collectionView.dequeueReusableCell(withReuseIdentifier: HDSSL_sameMuseumItem.className, for: indexPath) as! HDSSL_sameMuseumItem)
        return cell
    }
}
