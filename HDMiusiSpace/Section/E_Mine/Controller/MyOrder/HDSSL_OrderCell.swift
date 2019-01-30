//
//  HDSSL_OrderCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

//block
typealias BloclkBeginClass  = (_ cellIndex: Int) -> Void //开始上课
typealias BloclkShareOrder  = (_ cellIndex: Int) -> Void //晒单分享
typealias BloclkDeleteOrder = (_ cellIndex: Int) -> Void //删除订单
typealias BloclkPayOrder    = (_ cellIndex: Int) -> Void //支付订单

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
    
    var bloclkBeginClass: BloclkBeginClass?
    var bloclkShareOrder: BloclkShareOrder?
    var bloclkDeleteOrder: BloclkDeleteOrder?
    var bloclkPayOrder: BloclkPayOrder?
    
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
        cell_author.text = String.init(format: "%@", order?.author ?? "")
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
            cell_btn3.isHidden = true
            
            cell_btn1.layer.cornerRadius = 14
            cell_btn1.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
            cell_btn1.layer.borderWidth = 0.5
            cell_btn1.layer.masksToBounds = true
            cell_btn1.setTitle("支付", for: .normal)
            cell_btn1.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
            
            cell_btn2.setTitle("删除订单", for: .normal)
            
        }else if order?.status == 2 {
            //交易成功，开始上课
            cell_btn1.isHidden = false
            cell_btn2.isHidden = false
            cell_btn3.isHidden = false
            cell_btn1.setTitle("开始上课", for: .normal)
            cell_btn1.layer.borderColor = UIColor.black.cgColor

        }else if order?.status == 3 {
            //交易取消
            cell_btn2.isHidden = true
            cell_btn3.isHidden = true
            
            cell_btn1.setTitle("删除订单", for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_img.layer.cornerRadius = 5
        cell_img.layer.masksToBounds = true
        
        cell_btn1.layer.cornerRadius = 14
        cell_btn1.layer.borderColor = UIColor.black.cgColor
        cell_btn1.layer.borderWidth = 0.5
        cell_btn1.layer.masksToBounds = true
        
        cell_btn2.layer.cornerRadius = 14
        cell_btn2.layer.borderColor = UIColor.black.cgColor
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
    //action
    //右到左1，2，3，3个按钮点击事件根据订单状态变化而变化
    //第一个按钮
    @IBAction func action_tapButton1(_ sender: UIButton) {
        
        weak var weakSelf = self
        
        if order?.status == 1 {
            //待支付
            if weakSelf?.bloclkPayOrder != nil {
                weakSelf?.bloclkPayOrder!(self.tag) //支付
            }
        }else if order?.status == 2 {
            //已完成
            if weakSelf?.bloclkBeginClass != nil {
                weakSelf?.bloclkBeginClass!(self.tag)//开始上课
            }
        }else if order?.status == 3 {
            //已取消
            if weakSelf?.bloclkDeleteOrder != nil {
                weakSelf?.bloclkDeleteOrder!(self.tag)//删除订单
            }
        }
    }
    //第二个按钮
    @IBAction func action_tapButton2(_ sender: UIButton) {
        weak var weakSelf = self
        if order?.status == 1 {
            //待支付
            if weakSelf?.bloclkDeleteOrder != nil {
                weakSelf?.bloclkDeleteOrder!(self.tag) //删除订单
            }
        }else if order?.status == 2 {
            //已完成
            if weakSelf?.bloclkShareOrder != nil {
                weakSelf?.bloclkShareOrder!(self.tag)//晒单分享
            }
        }
    }
    //第三个按钮
    @IBAction func action_tapButton3(_ sender: UIButton) {
        weak var weakSelf = self
        
         if order?.status == 2 {
            //已完成
            if weakSelf?.bloclkDeleteOrder != nil {
                weakSelf?.bloclkDeleteOrder!(self.tag) //删除订单
            }
        }
    }
    
    //block
    func bloclkBeginClassFunc(block: @escaping BloclkBeginClass) {
        bloclkBeginClass = block
    }
    func bloclkShareOrderFunc(block: @escaping BloclkShareOrder) {
        bloclkShareOrder = block
    }
    func bloclkDeleteOrderFunc(block: @escaping BloclkDeleteOrder) {
        bloclkDeleteOrder = block
    }
    func bloclkPayOrderFunc(block: @escaping BloclkPayOrder) {
        bloclkPayOrder = block
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
