//
//  HDLY_GuideCard2Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol HDLY_GuideCard2Cell_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_GuideCard2Cell)
}
//
class HDLY_GuideCard2Cell: UITableViewCell {

    @IBOutlet weak var imgBgV: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var tapBtn1: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgView1: UIView!

    @IBOutlet weak var img1BgV: UIView!
    @IBOutlet weak var imgV1: UIImageView!
    @IBOutlet weak var titleL1: UILabel!
    @IBOutlet weak var typeL1: UILabel!
    @IBOutlet weak var priceL1: UILabel!
    @IBOutlet weak var tapBtn2: UIButton!
    
    weak var delegate: HDLY_GuideCard2Cell_Delegate?
    
    var dataArray: Array<BRecmdModel>? {
        didSet{
            showViewData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bgView.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 3, shadowOffset: CGSize.zero)
        bgView1.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 3, shadowOffset: CGSize.zero)

        imgV.addRoundedCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: CGSize.init(width: 10, height: 10))
        imgV1.addRoundedCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radii: CGSize.init(width: 10, height: 10))
        
    }

    func showViewData() {
        if dataArray != nil {
            let model = dataArray?.first
            if  model?.img != nil  {
                imgV.kf.setImage(with: URL.init(string: (model?.img)!), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
//            titleL.text = model?.title
//            countL.text = model?.views?.string == nil ? "0" :(model?.views?.string)! + "人在学"
//            priceL.text = "¥" + (model?.price?.string == nil ? "0" : (model?.price?.string)!)
//            //
//
//            let model1 = dataArray?.last
//            if  model1?.img != nil  {
//                imgV1.kf.setImage(with: URL.init(string: (model1?.img)!), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
//            }
//            titleL1.text = model1?.title
//            countL1.text = model1?.views?.string == nil ? "0" :(model1?.views?.string)! + "人在学"
//            priceL1.text = "¥" + (model1?.classnum?.string == nil ? "0" : (model1?.classnum?.string)!)
        }
        
        
    }
    
    @IBAction func tapAction(_ sender: UIButton) {
        
        if dataArray != nil {
            if sender.tag == 101 {
                let model = dataArray?.first
                delegate?.didSelectItemAt(model!, self)
            }
            else if sender.tag == 102 {
                let model1 = dataArray?.last
                delegate?.didSelectItemAt(model1!, self)
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_GuideCard2Cell! {
        var cell: HDLY_GuideCard2Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_GuideCard2Cell.className) as? HDLY_GuideCard2Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_GuideCard2Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_GuideCard2Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_GuideCard2Cell.className, owner: nil, options: nil)?.first as? HDLY_GuideCard2Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
