//
//  HDLY_ExhibitionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ExhibitionCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var lockView: UIView!
    @IBOutlet weak var vipPriceL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!
    
    var modelA:HDLY_ExhibitionListData? {
        didSet {
            showViewData()
            
        }
    }
    func showViewData() {
        guard let model = modelA else {
            return
        }
        if  model.img != nil  {
            imgV.kf.setImage(with: URL.init(string: (model.img ?? "")), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if model.type == 0 {//0数字编号版 1列表版 2扫一扫版
            typeL.text = "数字编号版"
        }else if model.type == 1 {
            typeL.text = "列表版"
        }else if model.type == 2 {
            typeL.text = "扫一扫版"
        }
        
        if model.isLock == 0 {
            lockView.isHidden = true
        }else {
            lockView.isHidden = false
        }
        //免费类型,0不免费,1所有人免费,2svip免费
        if model.priceType == 0 {
            priceL.isHidden = false
            priceL.text = "￥\(model.price)"
            priceL.textColor = UIColor.HexColor(0xE8593E)
            vipPriceL.text = "SVIP￥\(model.vipPrice)"
            vipPriceL.textColor = UIColor.HexColor(0xCCCCCC)

        }else if model.priceType == 1 {
            vipPriceL.text = "限时免费"
            vipPriceL.textColor = UIColor.HexColor(0x4A4A4A)
            
        }else if model.priceType == 2 {
            vipPriceL.text = "SVIP免费"
            vipPriceL.textColor = UIColor.HexColor(0xD8B98D)
        }
        timeL.text = model.times
//        UIFont.showAllFonts()
        if model.isTz == 1 {
            let maTitleString: NSMutableAttributedString = NSMutableAttributedString.init(string: model.title!)
            
            let tzView:UILabel = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: 28, height: 16))
            tzView.text = "特展"
            tzView.textAlignment = .center
            tzView.font = UIFont.init(name: "PingFangSC-Regular", size: 9)
            tzView.textColor = UIColor.HexColor(0xE8593E)
            tzView.layer.cornerRadius = 8
            tzView.layer.masksToBounds = true
            tzView.layer.borderWidth = 1
            tzView.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
            
            //
            let img:UIImage? = UIImage.getImgWithView(tzView)
            if img != nil {
                let attach = NSTextAttachment()
                attach.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 16)
                attach.image = img
                let imgStr = NSAttributedString.init(attachment: attach)
                maTitleString.append(imgStr)
            }
            titleL.attributedText = maTitleString
        }else {
            titleL.text = model.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
        lockView.layer.cornerRadius = 8
        lockView.layer.masksToBounds = true
        priceL.isHidden = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_ExhibitionCell! {
        var cell: HDLY_ExhibitionCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_ExhibitionCell.className) as? HDLY_ExhibitionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_ExhibitionCell.className, bundle: nil), forCellReuseIdentifier: HDLY_ExhibitionCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_ExhibitionCell.className, owner: nil, options: nil)?.first as? HDLY_ExhibitionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
