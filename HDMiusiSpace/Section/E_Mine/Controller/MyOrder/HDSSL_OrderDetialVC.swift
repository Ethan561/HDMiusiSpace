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

        self.title = "订单详情"
        loadMyViews()
        bindViewModel()
        
        viewModel.requestMyOrderDetail(apiToken: HDDeclare.shared.api_token ?? "", orderId: (order?.orderID)!, vc: self)  //HDDeclare.shared.api_token ?? ""
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
        btn_state.layer.cornerRadius = 14
        btn_state.layer.borderWidth = 1.0
        btn_state.layer.borderColor = UIColor.white.cgColor
        btn_state.layer.masksToBounds = true
        
        btn_bottom.layer.cornerRadius = 28
        
        img_content.layer.cornerRadius = 5
        img_content.layer.masksToBounds = true
        //
        if order?.status == 1 {  //1待支付
            
            img_icon_state.image = UIImage.init(named: "wddd_dzf")
            lab_state.text = "订单待支付"
            btn_state.isHidden = true
            payTimeTitleLab.isHidden = true
            lab_orderPayTime.isHidden = true
            
            btn_bottom.setTitle("立即支付", for: .normal)
            
            if order?.cateID == 1 { //课程
                
                
            }else { //门票
                classBgView.isHidden = true
                
            }
            
        }else if order?.status == 2 {  //2已完成
            img_icon_state.image = UIImage.init(named: "wddd_ywc")
            lab_state.text = "订单已完成"
            btn_state.isHidden = false
            if order?.cateID == 1 { //课程
                btn_state.setTitle("晒单分享", for: .normal)
                btn_bottom.setTitle("立即学习", for: .normal)
            }else { //展览门票
                btn_state.setTitle("待评价", for: .normal)
                classBgView.isHidden = true
                btn_bottom.setTitle("进入导览", for: .normal)
            }
            
        }else if order?.status == 3 {  //3已取消
            img_icon_state.image = UIImage.init(named: "wddd_yqx")
            lab_state.text = "订单已取消"
            btn_state.isHidden = true
            payTimeTitleLab.isHidden = true
            lab_orderPayTime.isHidden = true
            btn_bottom.isHidden = true
            if order?.cateID == 1 { //课程
                
                
            }else { //展览门票
                classBgView.isHidden = true
            }
        }
    }
    //mvvm
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.orderDetail.bind { (model) in
            weakSelf?.reloadMyViewWithData(model)
        }
        viewModel.orderPicPath.bind { (path) in
            //订单分享图
            print(path)
            //进入分享页面
            if path.count > 0 {
                let shareOrderVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_orderShareVC") as! HDSSL_orderShareVC
                shareOrderVC.sharePath = path
                shareOrderVC.orderID = self.orderDetail?.orderID!
                self.navigationController?.pushViewController(shareOrderVC, animated: true)
            }
        }
    }
    func reloadMyViewWithData(_ model: OrderDetailModel){
        self.orderDetail = model
        //
        img_content.kf.setImage(with: URL.init(string: (orderDetail?.img)!), placeholder: UIImage.grayImage(sourceImageV: img_content), options: nil, progressBlock: nil, completionHandler: nil)
        lab_contentTitle.text = orderDetail?.title
        classTimeLab.text = String.init(format: "%d课时", orderDetail?.classNum ?? 0)
        authorLab.text = String.init(format: "%@", orderDetail?.author ?? "")
        lab_contentSalePrice.text = String.init(format: "¥%@", orderDetail?.amount ?? "")
        lab_contentVIP.text = String.init(format: "%@", orderDetail?.discount ?? "")
        lab_contentRealPrice.text = String.init(format: "¥%@", orderDetail?.payAmount ?? "")
        
        lab_orderNumber.text = String.init(format: "%@", orderDetail?.orderNo ?? "")
        lab_orderCreTime.text = String.init(format: "%@", orderDetail?.createdAt ?? "")
        lab_orderPayTime.text = String.init(format: "%@", orderDetail?.payTime ?? "")
        
    }
    //客服电话
    @objc func action_server(){
        let str = orderDetail!.phone
        if str != "" {
            UIApplication.shared.openURL(URL(string: String.init(format: "telprompt:%@", str!))!)
        }else {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "连接失败，请稍后再试")
        }
    }
    
    //评价
    @IBAction func action_comment(_ sender: UIButton) {
        if order?.status == 2 {  //2已完成
            
            if order?.cateID == 1 { //课程
                //请求图片地址，然后跳转页面
                viewModel.getOrderSharePicPath(apiToken: HDDeclare.shared.api_token ?? "", order_id: (order?.orderID)!, vc: self) //HDDeclare.shared.api_token ?? ""
            }else { //展览门票
                //待评价
                let storyboard = UIStoryboard.init(name: "RootD", bundle: nil)
                let commentvc = storyboard.instantiateViewController(withIdentifier: "HDSSL_commentVC") as! HDSSL_commentVC
                commentvc.exhibition_id = self.order?.goodsID
                self.navigationController?.pushViewController(commentvc, animated: true)
            }
            
        }
    }
    //点击底部按钮
    @IBAction func action_tapBottom(_ sender: UIButton) {
        if order?.status == 1 {  //1待支付
            
            //去支付
            
        }else if order?.status == 2 {  //2已完成
            
            if order?.cateID == 1 { //课程
                //立即学习
                let storyBoard = UIStoryboard.init(name: "RootB", bundle: Bundle.main)
                let vc: HDLY_CourseList_VC = storyBoard.instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
                vc.courseId = String.init(format: "%d", order!.goodsID ?? 0)
                self.navigationController?.pushViewController(vc, animated: true)

            }else { //展览门票
                //进入导览
                let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
                vc.museum_id = order?.goodsID ?? 0
                vc.titleName = order?.title ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
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
