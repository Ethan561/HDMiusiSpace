//
//  HDSSL_OrderCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_OrderCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!   //图片
    @IBOutlet weak var cell_title: UILabel!     //标题
    @IBOutlet weak var cell_author: UILabel!    //作者
    @IBOutlet weak var cell_salePrice: UILabel! //标价
    @IBOutlet weak var cell_realPrice: UILabel! //成交价
    @IBOutlet weak var cell_state: UILabel!     //交易状态（交易成功、待支付、交易关闭）
    @IBOutlet weak var cell_payState: UILabel!  //实付款、未付款
    @IBOutlet weak var cell_btn1: UIButton!     //开始上课、支付、删除订单、
    @IBOutlet weak var cell_btn2: UIButton!     //晒单分享、删除订单、待评价
    @IBOutlet weak var cell_btn3: UIButton!     //删除订单
    
    var cellType: Int?   //cell类型
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_img.layer.cornerRadius = 5
        
        cell_btn1.layer.cornerRadius = 14
        cell_btn1.layer.borderColor = UIColor.black.cgColor
        cell_btn1.layer.borderWidth = 0.5
        cell_btn1.layer.masksToBounds = true
        
        cell_btn2.layer.cornerRadius = 14
        cell_btn3.layer.borderColor = UIColor.black.cgColor
        cell_btn2.layer.borderWidth = 0.5
        cell_btn2.layer.masksToBounds = true
        
        cell_btn3.layer.cornerRadius = 14
        cell_btn3.layer.borderColor = UIColor.black.cgColor
        cell_btn3.layer.borderWidth = 0.5
        cell_btn3.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func action_tapButton1(_ sender: UIButton) {
        print(sender.tag)
    }
    @IBAction func action_tapButton2(_ sender: UIButton) {
        print(sender.tag)
    }
    @IBAction func action_tapButton3(_ sender: UIButton) {
        print(sender.tag)
    }
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_OrderCell! {
        var cell: HDSSL_OrderCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_OrderCell.className) as? HDSSL_OrderCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_OrderCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_OrderCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_OrderCell.className, owner: nil, options: nil)?.first as? HDSSL_OrderCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
