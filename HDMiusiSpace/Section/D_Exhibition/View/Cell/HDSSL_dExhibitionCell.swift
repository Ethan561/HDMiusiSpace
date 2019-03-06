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
    @IBOutlet weak var cell_starL: UILabel!
    @IBOutlet weak var cell_tagBg: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var shadowBg: UIView!
    @IBOutlet weak var cell_noStarLab: UILabel!
    @IBOutlet weak var tagBgWidthCons: NSLayoutConstraint!
    
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
            //设置图片显示方式
            cell_img.contentMode = .scaleAspectFill
            //设置图片超出容器的部分不显示
            cell_img.clipsToBounds = true
            cell_noStarLab.isHidden = true
            cell_number.isHidden = false
            cell_starL.isHidden = false
            
            if star == 0 {
                //评分为0的时候显示暂无评星
                cell_noStarLab.isHidden = false
                cell_number.isHidden = true
                cell_starL.isHidden = true
            }
            
            var x:CGFloat = 0
            var imgWArr = [CGFloat]()
            var iconBgWidth:CGFloat = 0

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
                    iconBgWidth = x + imgWArr.last!
                    self.tagBgWidthCons.constant = iconBgWidth
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
