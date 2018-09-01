//
//  HDLY_Kids_Cell2.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol HDLY_Kids_Cell2_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Kids_Cell2)
}
    
class HDLY_Kids_Cell2: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var tapBtn1: UIButton!
    
    @IBOutlet weak var imgV1: UIImageView!
    @IBOutlet weak var titleL1: UILabel!
    @IBOutlet weak var countL1: UILabel!
    @IBOutlet weak var priceL1: UILabel!
    @IBOutlet weak var tapBtn2: UIButton!
    
    weak var delegate: HDLY_Kids_Cell2_Delegate?
    
    var dataArray: Array<BRecmdModel>? {
        didSet{
            showViewData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
        
        imgV1.layer.cornerRadius = 8
        imgV1.layer.masksToBounds = true
    }

    func showViewData() {
        if dataArray != nil {
            let model = dataArray?.first
            if  model?.img != nil  {
                imgV.kf.setImage(with: URL.init(string: (model?.img)!), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            titleL.text = model?.title
            countL.text = model?.views?.string == nil ? "0" :(model?.views?.string)! + "人在学"
            priceL.text = "¥" + (model?.price?.string == nil ? "0" : (model?.price?.string)!)
            //
            
            let model1 = dataArray?.last
            if  model1?.img != nil  {
                imgV1.kf.setImage(with: URL.init(string: (model1?.img)!), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            titleL1.text = model1?.title
            countL1.text = model1?.views?.string == nil ? "0" :(model1?.views?.string)! + "人在学"
            priceL1.text = "¥" + (model1?.classnum?.string == nil ? "0" : (model1?.classnum?.string)!)
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
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Kids_Cell2! {
        var cell: HDLY_Kids_Cell2? = tableV.dequeueReusableCell(withIdentifier: HDLY_Kids_Cell2.className) as? HDLY_Kids_Cell2
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Kids_Cell2.className, bundle: nil), forCellReuseIdentifier: HDLY_Kids_Cell2.className)
            cell = Bundle.main.loadNibNamed(HDLY_Kids_Cell2.className, owner: nil, options: nil)?.first as? HDLY_Kids_Cell2
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
