//
//  HDSSL_dExhibitionCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dExhibitionCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cell_locaAndPrice: UILabel!
    @IBOutlet weak var cell_number: UILabel!
    @IBOutlet weak var cell_star: UIImageView!
    @IBOutlet weak var cell_tagBg: UIView!
    @IBOutlet weak var tagL: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var cell_noStarLab: UILabel!
    
    var model: HDLY_dExhibitionListD? {
        didSet {
            showCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shadowBg.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.6, shadowRadius: 10, shadowOffset: CGSize.zero)

    }

    func showCellData() {
        for imgV in cell_tagBg.subviews {
            imgV.removeFromSuperview()
        }
        if self.model != nil {
            if  model?.img != nil  {
                cell_img.kf.setImage(with: URL.init(string: (model!.img!)), placeholder: UIImage.grayImage(sourceImageV: cell_img), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cellTitle.text = model?.title
            cell_locaAndPrice.text = model?.address
            let star: Float! = Float(model!.star?.string ?? "0")
            cell_number.text = String.init(format: "%.1f", star)
            
            var imgStr = ""
            
            cell_noStarLab.isHidden = true
            cell_number.isHidden = false
            cell_star.isHidden = false
            
            if star == 0 {
                //评分为0的时候显示暂无评星
                cell_noStarLab.isHidden = false
                cell_number.isHidden = true
                cell_star.isHidden = true
            }else if star < 2 {
                imgStr = "exhibitionCmt_1_5"
            }else if star >= 2 && star < 4 {
                imgStr = "exhibitionCmt_2_5"
            }else if star >= 4 && star < 6 {
                imgStr = "exhibitionCmt_3_5"
            }else if star >= 6 && star < 8 {
                imgStr = "exhibitionCmt_4_5"
            }else if star >= 8 {
                imgStr = "exhibitionCmt_5_5"
                
            }
            cell_star.image = UIImage.init(named: imgStr)
            
            var x:CGFloat = 0
            var imgWArr = [CGFloat]()
            
            for (i,imgStr) in model!.iconList!.enumerated() {
                let imgV = UIImageView()
                imgV.contentMode = .scaleAspectFit
                imgV.kf.setImage(with: URL.init(string: imgStr), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
                    
                    var imgSize:CGSize!
                    
                    if img != nil{
                        imgSize = img!.size
                    }else{
                        imgSize = CGSize.init(width: 15, height: 15)
                    }
//                    let imgSize = img!.size
                    let imgH: CGFloat = 15
                    let imgW: CGFloat = 15*imgSize.width/imgSize.height
                    imgWArr.append(imgW)
                    if i > 0 {
                        let w = imgWArr[i-1]
                        x = x + w
                    }
                    imgV.frame = CGRect.init(x: x, y: 2, width: imgW, height: imgH)
                    self.cell_tagBg.addSubview(imgV)
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_dExhibitionCell! {
        var cell: HDSSL_dExhibitionCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_dExhibitionCell.className) as? HDSSL_dExhibitionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_dExhibitionCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_dExhibitionCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_dExhibitionCell.className, owner: nil, options: nil)?.first as? HDSSL_dExhibitionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
