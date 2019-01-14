//
//  HDLY_CourseList_SubVC2.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_CourseList_SubVC2: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var focusBtn: UIButton!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    var orderTipView: HDLY_CreateOrderTipView?
    //
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    var webViewH:CGFloat = 0
    
    var infoModel: CourseDetail?
    var courseId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        buyBtn.layer.cornerRadius = 27
        tableView.dataSource = self
        tableView.delegate = self
        dataRequest()
        self.bottomHCons.constant = 0
        bindViewModel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataRequest()
    }
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseInfo(api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseDetail = try! jsonDecoder.decode(CourseDetail.self, from: result)
            self.infoModel = model
            
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    guard let price = self.infoModel!.data.price else {return}
                    let priceString = NSMutableAttributedString.init(string: "原价¥\(self.infoModel!.data.yprice!)")
                    let ypriceAttribute =
                        [NSAttributedStringKey.foregroundColor : UIColor.HexColor(0xFFD0BB),//颜色
                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),//字体
                            NSAttributedStringKey.strikethroughStyle: NSNumber.init(value: 1)//删除线
                            ] as [NSAttributedStringKey : Any]
                    priceString.addAttributes(ypriceAttribute, range: NSRange(location: 0, length: priceString.length))
                    //
                    let vipPriceString = NSMutableAttributedString.init(string: "会员价¥\(self.infoModel!.data.price!) ")
                    let vipPriceAttribute =
                        [NSAttributedStringKey.foregroundColor : UIColor.white,//颜色
                            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),//字体
                            ] as [NSAttributedStringKey : Any]
                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
                    vipPriceString.append(priceString)
                    self.buyBtn.setAttributedTitle(vipPriceString, for: .normal)
                    self.bottomHCons.constant = 74
                }else {
                    self.bottomHCons.constant = 0
                    self.bottomView.isHidden = true
                }
            }else {
                self.bottomHCons.constant = 0
                self.bottomView.isHidden = true
            }
            self.getWebHeight()
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        buyGoodsAction()
    }
}


extension HDLY_CourseList_SubVC2 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index == 0 {
            return 182*ScreenWidth/375.0
        }else if index == 1 {
            return webViewH
        }else if index == 2 {
            return 145*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = infoModel?.data
        if index == 0 {
            let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
            if model?.timg != nil {
                cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.timg)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.titleL.text = model?.title
            cell?.nameL.text = model?.teacherName
            cell?.desL.text = model?.teacherTitle
            cell?.focusBtn.addTarget(self, action: #selector(focusBtnAction), for: UIControlEvents.touchUpInside)
            focusBtn = cell?.focusBtn
            if model?.isFocus == 1 {
                focusBtn.setTitle("已关注", for: .normal)
                 self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.focusBtn.size), for: .normal)
            }else {
                focusBtn.setTitle("+关注", for: .normal)
                 self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.focusBtn.size), for: .normal)
            }
            
            return cell!
        }
        else if index == 1 {
            let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
            guard let url = self.infoModel?.data.url else {
                return cell!
            }
            cell?.loadWebView(url)
            return cell!
        }
        else if index == 2 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
            cell?.contentL.text = model?.buynotice
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            pushToPlatCenter()
        }
    }
    
    func pushToPlatCenter() {
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDLY_TeachersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDLY_TeachersCenterVC") as! HDLY_TeachersCenterVC
        vc.type = 1
        vc.detailId = infoModel?.data.teacherID.int ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ---- WKNavigationDelegate ----

extension HDLY_CourseList_SubVC2: UIWebViewDelegate {
    
    func getWebHeight() {
        guard let url = self.infoModel?.data.url else {
            return
        }
        self.testWebV.delegate = self
        self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView == self.testWebV) {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("\(webViewH)")
        }
        self.tableView.reloadData()
    }
    
    @objc func focusBtnAction()  {
        if let idnum = infoModel?.data.teacherID.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            doFocusRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "2")
        }
    }
    
    //关注
    func doFocusRequest(api_token: String, id: String, cate_id: String)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 1 {
                    self.infoModel!.data.isFocus = 1
                    self.focusBtn.setTitle("已关注", for: .normal)
                     self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.focusBtn.size), for: .normal)
                }else {
                    self.infoModel!.data.isFocus  = 0
                    self.focusBtn.setTitle("+关注", for: .normal)
                     self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.focusBtn.size), for: .normal)
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
}

extension  HDLY_CourseList_SubVC2{
    func buyGoodsAction() {
        if  self.infoModel?.data  != nil {
            if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self.pushToLoginVC(vc: self)
                    return
                }
                //获取订单信息
                guard let goodId = self.infoModel?.data.articleID.int else {
                    return
                }
                publicViewModel.orderGetBuyInfoRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: goodId, self)
                return
                
            }
        }
    }
    
    //显示支付弹窗
    func showOrderTipView( _ model: OrderBuyInfoData) {
        let tipView: HDLY_CreateOrderTipView = HDLY_CreateOrderTipView.createViewFromNib() as! HDLY_CreateOrderTipView
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        win.addSubview(tipView)
        orderTipView = tipView
        
        tipView.titleL.text = model.title
        if model.price != nil {
            tipView.priceL.text = "¥\(model.price!)"
            tipView.spaceCoinL.text = model.spaceMoney
            tipView.sureBtn.setTitle("支付\(model.price!)空间币", for: .normal)
        }
        weak var _self = self
        tipView.sureBlock = {
            _self?.orderBuyAction(model)
        }
        
    }
    
    func orderBuyAction( _ model: OrderBuyInfoData) {
        guard let goodId = self.infoModel?.data.articleID.int else {
            return
        }
        if Float(model.spaceMoney!) ?? 0 < Float(model.price!) ?? 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.pushToMyWalletVC()
                self.orderTipView?.removeFromSuperview()
            }
            return
        }
        publicViewModel.createOrderRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: goodId, pay_type: 1, self)
        
    }
    
    //显示支付结果
    func showPaymentResult(_ model: OrderResultData) {
        guard let result = model.isNeedPay else {
            return
        }
        if result == 2 {
            orderTipView?.successView.isHidden = false
            self.dataRequest()
        }
        
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //获取订单支付信息
        publicViewModel.orderBuyInfo.bind { (model) in
            weakSelf?.showOrderTipView(model)
        }
        
        //生成订单并支付
        publicViewModel.orderResultInfo.bind { (model) in
            weakSelf?.showPaymentResult(model)
        }
        
    }
}
