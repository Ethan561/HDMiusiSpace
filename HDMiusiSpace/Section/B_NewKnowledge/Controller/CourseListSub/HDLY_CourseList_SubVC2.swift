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
    var loadingView: HDLoadingView?
    var webViewH:CGFloat = 0
    
    var infoModel: CourseDetail?
    var courseId: String?
    var isFreeCourse = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        buyBtn.layer.cornerRadius = 27
        tableView.dataSource = self
        tableView.delegate = self
        loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
        loadingView?.frame = self.view.bounds
        view.addSubview(loadingView!)
        dataRequest()
        self.bottomHCons.constant = 0
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name: NSNotification.Name.init(rawValue: "HDLYCourseDesVC_NeedRefresh_Noti"), object: nil)

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
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseDetailInfo(api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseDetail = try! jsonDecoder.decode(CourseDetail.self, from: result)
            self.infoModel = model
            
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    guard let price = self.infoModel!.data.yprice else {return}
                    let priceString = NSMutableAttributedString.init(string: "原价¥\(self.infoModel!.data.yprice!)")
//                    let ypriceAttribute =
//                        [NSAttributedStringKey.foregroundColor : UIColor.HexColor(0xFFD0BB),//颜色
//                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),//字体
//                            NSAttributedStringKey.strikethroughStyle: NSNumber.init(value: 1)//删除线
//                            ] as [NSAttributedStringKey : Any]
//                    priceString.addAttributes(ypriceAttribute, range: NSRange(location: 0, length: priceString.length))
//                    //
//                    let vipPriceString = NSMutableAttributedString.init(string: "会员价¥\(self.infoModel!.data.price!) ")
//                    let vipPriceAttribute =
//                        [NSAttributedStringKey.foregroundColor : UIColor.white,//颜色
//                            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),//字体
//                            ] as [NSAttributedStringKey : Any]
//                    vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
//                    vipPriceString.append(priceString)
//                    self.buyBtn.setAttributedTitle(priceString, for: .normal)
                    self.buyBtn.setTitle("¥\(self.infoModel!.data.yprice!)", for: .normal)
                    self.buyBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                    self.bottomHCons.constant = 74
                }else {
                    self.bottomHCons.constant = 0
                    self.bottomView.isHidden = true
                }
                self.isFreeCourse = false
            }else {
                self.bottomHCons.constant = 0
                self.bottomView.isHidden = true
                self.isFreeCourse = true
            }
//            self.getWebHeight()
            self.tableView.reloadData()
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.loadingView?.removeFromSuperview()
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
            var content: String?
            if isFreeCourse == false {
                content = infoModel?.data.buynotice
                if self.infoModel?.data.isBuy == 1 {
                    return 0.01
                }
            }else {
                content = infoModel?.data.notice
            }
            guard let buynotice = content else {
                return 0.01
            }
            if buynotice.count < 1 {
                return 0.01
            }
            let textH = buynotice.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
            return textH + 80 + 15
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
            if webViewH == 0 {
              cell?.loadWebView(url)
            }
            cell?.webview.frame.size.height = webViewH
            cell?.webview.navigationDelegate = self
            cell?.webview.uiDelegate = self
            
            return cell!
        }
        else if index == 2 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
            if isFreeCourse == false {
                cell?.titleL.text = "购买须知"
                cell?.contentL.text = model?.buynotice
                if model?.buynotice.count ?? 0 < 1 {
                    cell?.titleL.text = ""
                    cell?.contentL.text = ""
                }
                cell?.titleL.isHidden = false
                if self.infoModel?.data.isBuy == 1 {
                    cell?.titleL.text = ""
                    cell?.contentL.text = ""
                    cell?.titleL.isHidden = true
                }
            }else {
                cell?.titleL.text = "学习须知"
                cell?.contentL.text = model?.notice
                if model?.notice?.count ?? 0 < 1 {
                    cell?.titleL.text = ""
                    cell?.contentL.text = ""
                }
            }
  
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

extension HDLY_CourseList_SubVC2 : WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        // 获取内容实际高度
        webView.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                print("webheight: \(webheight)")
            }
            DispatchQueue.main.async { [unowned self] in
                self.webViewH = CGFloat(webheight + 10)
                self.tableView.reloadData()
                self.loadingView?.removeFromSuperview()
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingView?.removeFromSuperview()
        self.tableView.ly_showEmptyView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loadingView?.removeFromSuperview()
        self.tableView.ly_showEmptyView()
    }
    
    //折叠、展开
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let arr = message.components(separatedBy: ",")
        let webheight = Double(arr.last ?? "0")
        print(message,arr)//展开是1 , 收起是2
        
        DispatchQueue.main.async { [unowned self] in
//            self.webview.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: CGFloat(webheight ?? 0))
            //            print("(webView.frame: \(webView.frame)")
            
            let model = FoldModel()
            model.isfolder = arr.first
            model.height = arr.last
            weak var weakSelf = self
            
//            self.delegate?.webViewFolderAction(model, self)
            
            //            if weakSelf?.blockRefreshHeight != nil {
            //                weakSelf?.blockRefreshHeight!(model)
            //
            //            }
        }
        completionHandler()
    }
    
}

//MARK:--滚动时刷新webView，内容显示完整
extension HDLY_CourseList_SubVC2: UIScrollViewDelegate {
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LOG("*****:HDLY_ListenDetail_VC:\(scrollView.contentOffset.y)")
        if self.tableView == scrollView {
            //滚动时刷新webview
            for view in self.tableView.visibleCells {
                if view.isKind(of: HDLY_CourseWeb_Cell.self) {
                    let cell = view as! HDLY_CourseWeb_Cell
                    cell.webview.setNeedsLayout()
                }
            }
        }
    }
}
    

extension HDLY_CourseList_SubVC2 {
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

extension  HDLY_CourseList_SubVC2 {
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
//            self.dataRequest()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLYCourseDesVC_NeedRefresh_Noti"), object: nil)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.orderTipView?.sureBlock = nil
                self.orderTipView?.removeFromSuperview()
            }
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

