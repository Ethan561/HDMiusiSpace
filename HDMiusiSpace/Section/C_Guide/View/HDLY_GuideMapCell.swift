//
//  HDLY_GuideMapCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/5.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_GuideMapCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var vipPriceL: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var freeL: UILabel!
    
    var model:MuseumMapModel? {
        didSet {
            showData()
        }
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_GuideMapCell! {
        var cell: HDLY_GuideMapCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_GuideMapCell.className) as? HDLY_GuideMapCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_GuideMapCell.className, bundle: nil), forCellReuseIdentifier: HDLY_GuideMapCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_GuideMapCell.className, owner: nil, options: nil)?.first as? HDLY_GuideMapCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 3, shadowOffset: CGSize.zero)
        
//        imgV.addRoundedCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: CGSize.init(width: 50, height: 50))
        
    }
    
    func showData() {
        guard let model1 = model else {
            return
        }
        if  model1.img != nil  {
            imgV.kf.setImage(with: URL.init(string: (model1.img!)), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
        }
        typeL.text = model1.version
        
        // 免费类型：0不免费,1所有人免费,2svip免费
        priceL.isHidden = true
        vipPriceL.isHidden = true
        freeL.isHidden = true
        if model1.priceType == 0 {//免费类型,0不免费,1所有人免费,2svip免费
            priceL.isHidden = false
            vipPriceL.isHidden = false
            priceL.text = "￥\(model1.price)"
            vipPriceL.text = "SVIP￥\(model1.vipPrice)"
        }else if model1.priceType == 1 {
            freeL.isHidden = false
            freeL.text = "限时免费"
            freeL.textColor = UIColor.HexColor(0x4A4A4A)
        }else if model1.priceType == 2 {
            priceL.isHidden = false
            vipPriceL.isHidden = false
            priceL.text = "￥\(model1.price)"
            vipPriceL.text = "SVIP免费"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
