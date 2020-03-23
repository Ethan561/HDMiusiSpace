//
//  HDLY_Recommend_Cell1.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/10.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Recommend_Cell1: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var courseL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var newTipL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        imgV.layer.cornerRadius = 8
        //        imgV.layer.masksToBounds = true
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        newTipL.backgroundColor = BaseColor.mainRedColor
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Recommend_Cell1! {
        var cell: HDLY_Recommend_Cell1? = tableV.dequeueReusableCell(withIdentifier: HDLY_Recommend_Cell1.className) as? HDLY_Recommend_Cell1
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Recommend_Cell1.className, bundle: nil), forCellReuseIdentifier: HDLY_Recommend_Cell1.className)
            cell = Bundle.main.loadNibNamed(HDLY_Recommend_Cell1.className, owner: nil, options: nil)?.first as? HDLY_Recommend_Cell1
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    public func setPriceLabel(model:BItemModel) {
        if model.boutiquelist?.is_free?.int == 0 {
            priceL.textColor = UIColor.HexColor(0xE8593E)
            if model.boutiquelist?.price != nil {
                let oprice = Double(model.boutiquelist?.oprice ?? "0")!
                let price = Double(model.boutiquelist?.price ?? "0")!
                if oprice > price {
                    let priceString = NSMutableAttributedString.init(string: "原价¥\(model.boutiquelist!.oprice!)")
                    let ypriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0x999999),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),//字体
                            NSAttributedString.Key.strikethroughStyle: NSNumber.init(value: 1)//删除线
                            ] as [NSAttributedString.Key : Any]
                    priceString.addAttributes(ypriceAttribute, range: NSRange(location: 0, length: priceString.length))
                    //
                    let vipPriceString = NSMutableAttributedString.init(string: "¥\(model.boutiquelist!.price!) ")
                    let vipPriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0xE8593E),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),//字体
                            ] as [NSAttributedString.Key : Any]
                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
                    vipPriceString.append(priceString)
                    priceL.attributedText = vipPriceString
                } else {
                    let vipPriceString = NSMutableAttributedString.init(string: "¥\(model.boutiquelist!.price!) ")
                    let vipPriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0xE8593E),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),//字体
                            ] as [NSAttributedString.Key : Any]
                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
                    priceL.attributedText = vipPriceString
                }
            }
        }else {
            priceL.text = "免费"
            priceL.textColor = UIColor.HexColor(0x4A4A4A)
        }
    }
    
    public func setPriceLabel1(model:CourseListModel) {
        if model.isFree == 0 {
            if !model.price.isEmpty {
                let oprice = Double(model.oprice ?? "0")!
                let price = Double(model.price )!
                if oprice > price {
                    let priceString = NSMutableAttributedString.init(string: "原价¥\(model.oprice ?? "")")
                    let ypriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0x999999),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),//字体
                            NSAttributedString.Key.strikethroughStyle: NSNumber.init(value: 1)//删除线
                            ] as [NSAttributedString.Key : Any]
                    priceString.addAttributes(ypriceAttribute, range: NSRange(location: 0, length: priceString.length))
                    //
                    let vipPriceString = NSMutableAttributedString.init(string: "¥\(model.price) ")
                    let vipPriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0xE8593E),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),//字体
                            ] as [NSAttributedString.Key : Any]
                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
                    vipPriceString.append(priceString)
                    priceL.attributedText = vipPriceString
                } else {
                    let vipPriceString = NSMutableAttributedString.init(string: "¥\(model.price) ")
                    let vipPriceAttribute =
                        [NSAttributedString.Key.foregroundColor : UIColor.HexColor(0xE8593E),//颜色
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),//字体
                            ] as [NSAttributedString.Key : Any]
                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
                    priceL.attributedText = vipPriceString
                }
            }
        }else {
            priceL.text = "免费"
            priceL.textColor = UIColor.HexColor(0x4A4A4A)
        }
    }
    
}
