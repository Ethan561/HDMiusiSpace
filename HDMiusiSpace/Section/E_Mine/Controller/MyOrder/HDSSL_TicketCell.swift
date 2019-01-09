//
//  HDSSL_TicketCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//block
typealias BloclkCommentTicket = (_ cellIndex: Int) -> Void //评价
typealias BloclkDeleteTicket  = (_ cellIndex: Int) -> Void //删除订单
typealias BloclkPayTicket     = (_ cellIndex: Int) -> Void //支付订单

class HDSSL_TicketCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!   //图片
    @IBOutlet weak var cell_title: UILabel!     //标题
    @IBOutlet weak var cell_salePrice: UILabel! //标价
    @IBOutlet weak var cell_realPrice: UILabel! //成交价
    @IBOutlet weak var cell_state: UILabel!     //交易状态（交易成功、待支付、交易关闭）
    @IBOutlet weak var cell_payState: UILabel!  //实付款、未付款
    @IBOutlet weak var cell_btn1: UIButton!     //支付、删除订单、
    @IBOutlet weak var cell_btn2: UIButton!     //删除订单、待评价
    
    var bloclkPayTicket    : BloclkPayTicket?
    var bloclkDeleteTicket : BloclkDeleteTicket?
    var bloclkCommentTicket: BloclkCommentTicket?
    
    var order: MyOrder?  {
        didSet{
            reloadData()
        }
    }
    
    func reloadData(){
        //button
        reloadButtonType()
        //other
        if  order?.img != nil  {
            cell_img.kf.setImage(with: URL.init(string: (order!.img!)), placeholder: UIImage.grayImage(sourceImageV: cell_img), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        cell_title.text = String.init(format: "%@", order?.title ?? "")
        cell_salePrice.text = String.init(format: "¥%@", order?.amount ?? "")
        cell_realPrice.text = String.init(format: "¥%@", order?.payAmount ?? "")
        var payStateStr = "交易成功"
        if order?.status == 1 {
            payStateStr = "待支付"
            cell_payState.text = "未付款"
        }else if order?.status == 3 {
            payStateStr = "交易关闭"
        }
        cell_state.text = payStateStr
        
        
    }
    func reloadButtonType(){
        if order?.status == 1 {
            //待支付
            cell_btn1.layer.cornerRadius = 14
            cell_btn1.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
            cell_btn1.layer.borderWidth = 0.5
            cell_btn1.layer.masksToBounds = true
            cell_btn1.setTitle("支付", for: .normal)
            cell_btn1.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
            
            cell_btn2.setTitle("删除订单", for: .normal)
            
        }else if order?.status == 2 {
            //交易成功
            cell_btn1.layer.cornerRadius = 14
            cell_btn1.layer.borderColor = UIColor.black.cgColor
            cell_btn1.layer.borderWidth = 0.5
            cell_btn1.layer.masksToBounds = true
            
            cell_btn2.layer.cornerRadius = 14
            cell_btn2.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
            cell_btn2.layer.borderWidth = 0.5
            cell_btn2.layer.masksToBounds = true
            cell_btn2.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
            
            if order?.isComment == 1 {
                cell_btn2.isHidden = true
            }else {
                cell_btn2.isHidden = false
            }
            
        }else if order?.status == 3 {
            //交易取消
            cell_btn2.isHidden = true
        }
    }
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
        weak var weakSelf = self
        if order?.status == 1 {
            //待支付
            if weakSelf?.bloclkPayTicket != nil {
                weakSelf?.bloclkPayTicket!(self.tag) //支付
            }
        }else if order?.status == 2 {
            //已完成
            if weakSelf?.bloclkDeleteTicket != nil {
                weakSelf?.bloclkDeleteTicket!(self.tag)//删除订单
            }
        }else if order?.status == 3 {
            //已取消
            if weakSelf?.bloclkDeleteTicket != nil {
                weakSelf?.bloclkDeleteTicket!(self.tag)//删除订单
            }
        }
    }
    @IBAction func action_tapButton2(_ sender: UIButton) {
        print(sender.tag)
        weak var weakSelf = self
        if order?.status == 1 {
            //待支付
            if weakSelf?.bloclkDeleteTicket != nil {
                weakSelf?.bloclkDeleteTicket!(self.tag) //删除订单
            }
        }else if order?.status == 2 {
            //已完成
            if weakSelf?.bloclkCommentTicket != nil {
                weakSelf?.bloclkCommentTicket!(self.tag)//评价
            }
        }
    }
    
    //blockFunc
    func bloclkPayTicketFunc(block: @escaping BloclkPayTicket) {
        bloclkPayTicket = block
    }
    func bloclkCommentTicketFunc(block: @escaping BloclkCommentTicket) {
        bloclkCommentTicket = block
    }
    func bloclkDeleteTicketFunc(block: @escaping BloclkDeleteTicket) {
        bloclkDeleteTicket = block
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
