//
//  HDSSL_OrderDetialVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_OrderDetialVC: HDItemBaseVC {

    @IBOutlet weak var img_icon_state: UIImageView!  //订单状态icon
    @IBOutlet weak var lab_state: UILabel!           //订单状态描述
    @IBOutlet weak var btn_state: UIButton!          //待评价按钮
    @IBOutlet weak var btn_bottom: UIButton!         //底部按钮
    //
    @IBOutlet weak var img_content: UIImageView!     //内容图片
    @IBOutlet weak var lab_contentTitle: UILabel!    //标题
    @IBOutlet weak var classBgView: UIView!          //课时背景
    @IBOutlet weak var classTimeLab: UILabel!        //课时
    @IBOutlet weak var authorLab: UILabel!           //作者
    @IBOutlet weak var lab_contentSalePrice: UILabel!//原价
    @IBOutlet weak var lab_contentVIP: UILabel!      //优惠vip
    @IBOutlet weak var lab_contentRealPrice: UILabel!//实付款
    @IBOutlet weak var lab_orderNumber: UILabel!     //订单号
    @IBOutlet weak var lab_orderCreTime: UILabel!    //创建时间
    @IBOutlet weak var lab_orderPayTime: UILabel!    //付款时间
    @IBOutlet weak var payStateTitleLab: UILabel!    //实付款、需付款
    @IBOutlet weak var payTimeTitleLab: UILabel!     //付款时间标题
    
    var order: MyOrder?
    var orderDetail: OrderDetailModel?
    private var viewModel = HDZQ_MyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
        bindViewModel()
        
        viewModel.requestMyOrderDetail(apiToken: "123456", orderId: (order?.orderID)!, vc: self)  //HDDeclare.shared.api_token ?? ""
    }
    
    func loadMyViews() {
        //发布按钮
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("客服", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        publishBtn.setTitleColor(UIColor.black, for: .normal)
        publishBtn.addTarget(self, action: #selector(action_server), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        //UI
        btn_state.layer.cornerRadius = 15
        btn_state.layer.borderWidth = 0.5
        btn_state.layer.borderColor = UIColor.white.cgColor
        btn_state.layer.masksToBounds = true
        
        btn_bottom.layer.cornerRadius = 28
        
        img_content.layer.cornerRadius = 5
        
        //
        if order?.status == 1 {
            //待支付
            if order?.cateID == 1 {
                //课程
                
            }else {
                //门票
                
            }
            
        }else if order?.status == 2 {
            //已完成
            
        }else if order?.status == 3 {
            //已取消
            
        }
    }
    //mvvm
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.orderDetail.bind { (model) in
            weakSelf?.reloadMyViewWithData(model)
        }
    }
    func reloadMyViewWithData(_ model: OrderDetailModel){
        self.orderDetail = model
        //
        
        
    }
    //客服
    @objc func action_server(){
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
