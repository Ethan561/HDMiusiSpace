//
//  HDSSL_TicketCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_TicketCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!   //图片
    @IBOutlet weak var cell_title: UILabel!     //标题
    @IBOutlet weak var cell_salePrice: UILabel! //标价
    @IBOutlet weak var cell_realPrice: UILabel! //成交价
    @IBOutlet weak var cell_state: UILabel!     //交易状态（交易成功、待支付、交易关闭）
    @IBOutlet weak var cell_payState: UILabel!  //实付款、未付款
    @IBOutlet weak var cell_btn1: UIButton!     //支付、删除订单、
    @IBOutlet weak var cell_btn2: UIButton!     //删除订单、待评价
    
    var cellType: Int?   //cell类型
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_TicketCell! {
        var cell: HDSSL_TicketCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_TicketCell.className) as? HDSSL_TicketCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_TicketCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_TicketCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_TicketCell.className, owner: nil, options: nil)?.first as? HDSSL_TicketCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
