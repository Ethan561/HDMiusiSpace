//
//  HDLY_CourseList_SubVC3.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_SubVC3: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var leaveMsgView: UIView!
    @IBOutlet weak var leaveMsgBgV: UIView!
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    var orderTipView: HDLY_CreateOrderTipView?
    var infoModel: CourseQuestion?
    var courseId: String?
    var player = HDLY_AudioPlayer.shared
    var playingIndex: String?
    
    //
    var loadingView: HDLoadingView?
    var webViewH:CGFloat = 0
    var isNeedBuyCourse = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyBtn.layer.cornerRadius = 27
        buyBtn.isHidden = true
        leaveMsgBgV.layer.cornerRadius = 19
        player.showFloatingBtn = false
        player.delegate = self
        //
        bottomHCons.constant = 56
        bottomView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
        loadingView?.frame = self.view.bounds
        view.addSubview(loadingView!)
        dataRequest()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name: NSNotification.Name.init(rawValue: "HDLYCourseDesVC_NeedRefresh_Noti"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlayerNoti(_:)), name: NSNotification.Name.init(rawValue: "TeacherReturn_PlayerNeedStop_Noti"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataRequest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stop()
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        buyGoodsAction()
    }
    
    @IBAction func questionBtnAction(_ sender: UIButton) {
        let vc:HDLY_LeaveQuestion_VC = HDLY_LeaveQuestion_VC.init()
        vc.courseId = self.courseId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseQuestionList(skip: "0", take: "100", api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:CourseQuestion = try jsonDecoder.decode(CourseQuestion.self, from: result)
                self.infoModel = model
                self.tableView.reloadData()
                if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                    if self.infoModel?.data.isBuy == 1 {//0未购买，1已购买
                        self.buyBtn.isHidden = true
                        self.leaveMsgView.isHidden = false
                        self.bottomHCons.constant = 56
                        self.isNeedBuyCourse = false
                    }else {
                        self.buyBtn.isHidden = false
                        self.leaveMsgView.isHidden = true
                        self.bottomHCons.constant = 74
                        self.isNeedBuyCourse = true
                    }
                }
                else {
                    self.buyBtn.isHidden = true
                    self.leaveMsgView.isHidden = false
                    self.bottomHCons.constant = 56
                    self.isNeedBuyCourse = false
                }
            }
            catch let error {
                LOG("\(error)")
                self.tableView.ly_endLoading()
            }

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
}

extension HDLY_CourseList_SubVC3 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if infoModel?.data.list != nil {
            return infoModel!.data.list.count+1
        }
        return 1
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if infoModel?.data.isBuy == 1 {
                return 0.01
            }
            return 45
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            let titleH = secModel.title.getContentHeight(font: UIFont.init(name: "PingFangSC-Medium", size: 14)!, width: ScreenWidth-80)
            let contentH = secModel.content.getContentHeight(font: UIFont.init(name: "PingFangSC-Regular", size: 14)!, width: ScreenWidth-80)
            return titleH+contentH+108
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if infoModel?.data.isBuy == 1 {
                return nil
            }
            return HDLY_QuestionTip_Header.createViewFromNib() as! HDLY_QuestionTip_Header
        }
        if infoModel?.data.list != nil && section > 0{
            let index = section - 1
            let secModel = infoModel!.data.list[section-1]
            let header = HDLY_QuestionContent_Header.createViewFromNib() as!  HDLY_QuestionContent_Header
            header.questionL.text = secModel.title
            header.contentL.text = secModel.content
            header.timeL.text = secModel.createdAt
            header.likeBtn.setTitle(secModel.likes!.string, for: UIControlState.normal)
            header.nameL.text = secModel.nickname
            if secModel.avatar.isEmpty == false {
                header.avaImgV.kf.setImage(with: URL.init(string: secModel.avatar), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            if secModel.isLike?.int == 0 {
                header.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
            }else {
                header.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
            }
            header.avatarBtn.tag = section - 1
            header.avatarBtn.addTarget(self, action: #selector(pushPersonalCenter(_:)), for: .touchUpInside)

            header.likeBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    CoursePublicViewModel.doLikeRequest(id: "\(secModel.questionID)", cate_id: "8", vc: self!, success: { (result) in
                        if self?.infoModel!.data.list[index].isLike!.int == 0 {
                            self?.infoModel!.data.list[index].isLike!.int = 1
                            self?.infoModel!.data.list[index].likes!.int = (self?.infoModel!.data.list[index].likes!.int)! + 1
                            header.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
                            header.likeBtn.setTitle(self?.infoModel!.data.list[index].likes!.string, for: .normal)
                        }else {
                            self?.infoModel!.data.list[index].isLike!.int = 0
                            self?.infoModel!.data.list[index].likes!.int = (self?.infoModel!.data.list[index].likes!.int)! - 1
                            header.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
                            header.likeBtn.setTitle(self?.infoModel!.data.list[index].likes!.string, for: .normal)
                        }
                    }, failure: { (error, msg) in })
                }
            })
            
            return header
        }
        
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
        if section == 0 {
            return 2
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            if secModel.returnInfo.count > 0 {
                return secModel.returnInfo.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row

        if section == 0 {
            if row == 0 {
                if infoModel?.data.isBuy == 1 {
                    return 0.01
                }
                return webViewH
            }else {
                return 42
            }
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            if secModel.returnInfo.count > 0 {
                let returnInfo = secModel.returnInfo[row]
                if returnInfo.type == 1 {//1文字2语音
                    let contentH = secModel.content.getContentHeight(font: UIFont.init(name: "PingFangSC-Regular", size: 14)!, width: ScreenWidth-147)
                    return contentH + 108
                }else {
                    return  145
                }
            }
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
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
            }else if row == 1 {
                let cell = HDLY_QuestionNumTitle_Cell.getMyTableCell(tableV: tableView)
                if infoModel?.data != nil {
                    cell?.countL.text = "讲师共回答了\(infoModel!.data.answerNum)个问题"
                }
                if infoModel?.data.isBuy == 1 {
                    cell?.noticeBtn.addTarget(self, action: #selector(noticeBtnAction), for: UIControlEvents.touchUpInside)
                    cell?.noticeL.isHidden = false
                    cell?.noticeImgV.isHidden = false
                } else {
                    cell?.noticeL.isHidden = true
                    cell?.noticeImgV.isHidden = true
                }
                
                return cell!
            }
        }else {
            
            if infoModel?.data.list != nil && section > 0{
                let secModel = infoModel!.data.list[section-1]
                if secModel.returnInfo.count > 0 {
                    let returnInfo:QuestionReturnInfo = secModel.returnInfo[row]
                    if returnInfo.type == 1 {//1文字2语音
                        let cell = HDLY_AnswerText_Cell.getMyTableCell(tableV: tableView)
                        if returnInfo.teacherImg.isEmpty == false {
                            cell?.avaImgV.kf.setImage(with: URL.init(string: returnInfo.teacherImg), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                            cell?.nameL.text = returnInfo.teacherName
                            cell?.contentL.text = returnInfo.content
                            cell?.timeL.text = returnInfo.createdAt
                        }
                        return cell!
                    }else {
                        let cell = HDLY_AnswerAudio_Cell.getMyTableCell(tableV: tableView)
                        cell?.avaImgV.kf.setImage(with: URL.init(string: returnInfo.teacherImg), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                        cell?.nameL.text = returnInfo.teacherName
                        cell?.timeL.text = returnInfo.createdAt
                        if self.isNeedBuyCourse == true {
                            cell?.audioTimeL.text = String.init(format: "%@ 购课后可听", returnInfo.timeLong)

                        }else {
                            cell?.audioTimeL.text = returnInfo.timeLong
                        }
                        cell?.delegate = self
                        cell?.model = returnInfo
                        let currentIndex = "\(section)\(row)"
                        if playingIndex != nil {
                            if playingIndex! == currentIndex  {
                                cell?.startAnimating()
                            }else {
                                cell?.stopAnimating()
                            }
                        }
                        return cell!
                    }
                }
            }
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension HDLY_CourseList_SubVC3 : AnswerAudioDelegate {
    
    @objc func noticeBtnAction() {
        let tipView:HDLY_QuestionNoticeTip = HDLY_QuestionNoticeTip.createViewFromNib() as! HDLY_QuestionNoticeTip
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        win.addSubview(tipView)
        guard let url = self.infoModel?.data.url else {
            return
        }
        tipView.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
        
    }

    //点击用户头像
    @objc func pushPersonalCenter(_ sender: UIButton) {
        let index = sender.tag
        let secModel = infoModel!.data.list[index]
        self.pushToOthersPersonalCenterVC(secModel.uid)
        
    }
    
    //===== AnswerAudioDelegate =====
    func voiceBubbleStratOrStop(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo) {
        if self.isNeedBuyCourse == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "购课后可听")
            return
        }
        if model.video.isEmpty == true || model.video.contains("http://") == false {
            return
        }
        play(cell, model)
    }
    
    func play(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo) {
        let indexPath: IndexPath = self.tableView.indexPath(for: cell)!
        let indexStr = "\(indexPath.section)\(indexPath.row)"
        self.playingIndex = indexStr
        cell.startAnimating()
        
        var voicePath = model.video
        if voicePath.contains("m4a") {
            voicePath = model.video.replacingOccurrences(of: "m4a", with: "wav")
        }
        player.play(file: Music.init(name: "", url:URL.init(string: voicePath)!))
        player.url = model.video
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLYCourseListVC_VideoNeedStop_Noti"), object: nil)

    }
}

extension HDLY_CourseList_SubVC3 : HDLY_AudioPlayer_Delegate {
    
    @objc func stopPlayerNoti(_ noti: Notification) {
        player.stop()
        self.playingIndex = nil
        self.tableView.reloadData()
    }
        
    // === HDLY_AudioPlayer_Delegate ===
    func finishPlaying() {
       // playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControlState.normal)
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
       // timeL.text = "\(currentTime)/\(totalTime)"
        LOG(" progress: \(progress)")
    }
    
}

extension  HDLY_CourseList_SubVC3 {
    func buyGoodsAction() {
        if  self.infoModel?.data  != nil {
            if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self.pushToLoginVC(vc: self)
                    return
                }
                //获取订单信息
                guard let idnum = self.courseId else {
                    return
                }
                publicViewModel.orderGetBuyInfoRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: Int(idnum) ?? 0, self)
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
        guard let idnum = self.courseId else {
            return
        }
        if Float(model.spaceMoney!) ?? 0 < Float(model.price!) ?? 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.pushToMyWalletVC()
                self.orderTipView?.removeFromSuperview()
            }
            return
        }
        publicViewModel.createOrderRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: Int(idnum) ?? 0, pay_type: 1, self)
        
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

extension HDLY_CourseList_SubVC3 : WKNavigationDelegate,WKUIDelegate {
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
                if self.infoModel?.data.isBuy == 1 {
                      self.webViewH =  0.01
                }
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
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let arr = message.components(separatedBy: "#")
        print(message,arr)//
        if arr.count == 2 {
            let type = arr.first
            let articleId = arr.last
            self.didTapWebCard(Int(type!) ?? 0,Int(articleId!) ?? 0)
        }
        completionHandler()
    }
}
