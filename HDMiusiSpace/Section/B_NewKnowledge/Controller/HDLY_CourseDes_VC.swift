//
//  HDLY_CourseDes_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/14.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseDes_VC: HDItemBaseVC ,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate {

    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listenBgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    var courseId:String?
    @IBOutlet weak var timeL: UILabel!
    var focusBtn: UIButton!

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    var infoModel: CourseModel?
    var isMp3Course = false
    var orderTipView: HDLY_CreateOrderTipView?
    
    
    var kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    
    lazy var controlView:ZFPlayerControlView = {
        let controlV = ZFPlayerControlView.init()
        controlV.fastViewAnimated = true
        return controlV
    }()
    
    let audioPlayer = HDLY_AudioPlayer.shared
    lazy var videoPlayer:ZFPlayerController =  {
        let playerC = ZFPlayerController.init(playerManager: ZFAVPlayerManager(), containerView: self.containerView)
        return playerC
    }()
    
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    var webViewH:CGFloat = 0
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        //statusBarHCons.constant = kStatusBarHeight+24
        myTableView.separatorStyle = .none
        buyBtn.layer.cornerRadius = 27
        listenBgView.configShadow(cornerRadius: 25, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        //
        self.videoPlayer.controlView = self.controlView
        // 设置退到后台继续播放
        self.videoPlayer.pauseWhenAppResignActive = false
        
        weak var _self = self
        self.videoPlayer.orientationWillChange = { (player,isFullScreen) -> (Void) in
            _self?.setNeedsStatusBarAppearanceUpdate()
        }
        
        // 播放完自动播放下一个
        self.videoPlayer.playerDidToEnd = { (asset) -> () in
            
        }
        dataRequest()
        self.bottomHCons.constant = 0
        self.listenBgView.isHidden = true
        bindViewModel()
        if audioPlayer.state == .playing {
            HDFloatingButtonManager.manager.floatingBtnView.closeAction()
        }
        audioPlayer.showFloatingBtn = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.videoPlayer.isViewControllerDisappear = false
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.videoPlayer.isViewControllerDisappear = true
        UIApplication.shared.statusBarStyle = .default
        audioPlayer.stop()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func playClick(_ sender: UIButton) {
        guard let course = infoModel?.data else {
            return
        }
        
        HDFloatingButtonManager.manager.floatingBtnView.closeAction()
        if isMp3Course {
            audioPlayOrPauseAction()
        }else {
            if course.video.isEmpty == false && course.video.contains(".mp4") {
                self.videoPlayer.assetURL = NSURL.init(string: course.video)! as URL
                self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
            }
        }
    }
    
    @IBAction func listenBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_CourseList_VC_line", sender: self.courseId)
    }
    
    @IBAction func bugBtnAction(_ sender: UIButton) {
//        HDLY_IAPStore.shared.requestProducts(nil)
//        
//        return
        if  self.infoModel?.data  != nil {
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
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
    
            }else {
                self.performSegue(withIdentifier: "PushTo_HDLY_CourseList_VC_line", sender: self.courseId)
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
        tipView.priceL.text = String.init(format: "￥%@", model.price?.string ?? "")
        tipView.spaceCoinL.text = model.spaceMoney
        tipView.sureBtn.setTitle("支付\(model.price!.int)空间币", for: .normal)
        
        weak var _self = self
        tipView.sureBlock = {
            _self?.orderBuyAction()
        }
        
    }
    
    func orderBuyAction() {
        guard let goodId = self.infoModel?.data.articleID.int else {
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
        }
        
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        //收藏
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "Star_white"), for: UIControlState.normal)
            } else {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "Star_red"), for: UIControlState.normal)
            }
        }
        
        //获取订单支付信息
        publicViewModel.orderBuyInfo.bind { (model) in
            weakSelf?.showOrderTipView(model)
        }
        
        //生成订单并支付
        publicViewModel.orderResultInfo.bind { (model) in
            weakSelf?.showPaymentResult(model)
        }
        
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        if self.infoModel?.data.articleID.string != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: infoModel!.data.articleID.string, cate_id: "3", self)
        }
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func errorBtnAction(_ sender: UIButton) {
        tapErrorBtnAction()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseInfo(api_token: token, id: idnum), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseModel = try! jsonDecoder.decode(CourseModel.self, from: result)
            self.infoModel = model
            if self.infoModel?.data.fileType == 1 {
                //1是MP3;2是MP4
                self.isMp3Course = true
                self.audioPlayer.delegate = self
                
            }else {
                self.isMp3Course = false
            }
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    self.buyBtn.setTitle("原价¥\(self.infoModel!.data.price.string)", for: .normal)
                    self.listenBgView.isHidden = false

                }else {
                    self.buyBtn.setTitle("立即学习", for: .normal)
                    self.listenBgView.isHidden = true
                }
            }else {
                self.buyBtn.setTitle("立即学习", for: .normal)
                self.listenBgView.isHidden = true
            }
            self.bottomHCons.constant = 74
            if self.infoModel != nil {
                self.kVideoCover = self.infoModel!.data.img
                self.getWebHeight()
                if self.infoModel?.data.isFavorite == 1 {
                    self.likeBtn.setImage(UIImage.init(named: "Star_red"), for: UIControlState.normal)
                }else {
                    self.likeBtn.setImage(UIImage.init(named: "Star_white"), for: UIControlState.normal)
                }
            }
            
        }) { (errorCode, msg) in
            self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.myTableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    func getWebHeight() {
        guard let url = self.infoModel?.data.url else {
            return
        }
        self.testWebV.delegate = self
        self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }
    
    
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushTo_HDLY_CourseList_VC_line" {
            guard let idnum:String = sender as? String else {
                return
            }
            let vc:HDLY_CourseList_VC = segue.destination as! HDLY_CourseList_VC
            vc.courseId = idnum
        }
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_CourseDes_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0.01
            }
            if count > 0 {
                return 120
            }
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return nil
            }
            if count > 0 {
                let header = HDLY_CourseComment_Header.createViewFromNib() as! HDLY_CourseComment_Header
                header.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: UIControlEvents.touchUpInside)
                header.titleL.text = "精选留言"
                
                return header
            }
        }
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0.01
            }
            if count > 0 {
                return 60
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return nil
            }
            if count > 0 {
                return HDLY_CourseComment_Footer.createViewFromNib() as! HDLY_CourseComment_Footer
            }
        }
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0
            }
            return count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if index == 0 {
                return 182*ScreenWidth/375.0
            }else if index == 1 {
                return webViewH
            }else if index == 2 {
                if infoModel?.data.teacherContent != nil {
                    let textH = infoModel?.data.teacherContent.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
                    return textH! + 145 + 10
                }
                return 140
            }
        }
        else if indexPath.section == 1 {
            guard let recommendsMessage = infoModel?.data.recommendsMessage else {
                return 0.01
            }
            let  model  = recommendsMessage[index]
            if model.content != nil {
                let textH = model.content!.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-125)
                return textH + 50
            }
            return 0.01
        }
        else if indexPath.section == 2 {
            guard let buynotice = infoModel?.data.buynotice else {
                return 80
            }
            let textH = buynotice.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
            return textH + 80 + 15
        }
        else if indexPath.section == 3 {
            return 220*ScreenWidth/375.0
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = infoModel?.data
        
        if indexPath.section == 0 {
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
                }else {
                    focusBtn.setTitle("+关注", for: .normal)
                }
                
                return cell!
            }
            else if index == 1 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = self.infoModel?.data.url else {
                    return cell!
                }
                cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                return cell!
            }
            else if index == 2 {
                let cell = HDLY_CourseTeacher_Cell.getMyTableCell(tableV: tableView)
                if model?.timg != nil {
                    cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.timg)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell?.nameL.text = model?.teacherName
                cell?.desL.text = model?.teacherTitle
                cell?.introduceL.text = model?.teacherContent
                return cell!
            }
        }
        else if indexPath.section == 1 {
            let cell = HDLY_CourseComment_Cell.getMyTableCell(tableV: tableView)
            guard let recommendsMessage = infoModel?.data.recommendsMessage else {
                return cell!
            }
            let  model  = recommendsMessage[index]
            cell?.contentL.text = model.content
            cell?.nameL.text = model.nickname
            if model.avatar != nil {
                cell?.avaImgV.kf.setImage(with: URL.init(string:(model.avatar)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            return cell!
        }
        else if indexPath.section == 2 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
            cell?.titleL.text = "购买须知"
            cell?.contentL.text = model?.buynotice
            
            return cell!
        }
        else if indexPath.section == 3 {
            let cell = HDLY_CourseRecmd_Cell.getMyTableCell(tableV: tableView)
            cell?.listArray = model?.recommendsList
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HDLY_CourseDes_VC {
 
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView == self.testWebV) {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("\(webViewH)")
        }
        self.myTableView.reloadData()
    }
    
}


extension HDLY_CourseDes_VC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
        vc.courseId = self.courseId
        vc.showLeaveMsg = true
        self.navigationController?.pushViewController(vc, animated: true)
        
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
                }else {
                    self.infoModel!.data.isFocus  = 0
                    self.focusBtn.setTitle("+关注", for: .normal)
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
}


extension HDLY_CourseDes_VC : HDLY_AudioPlayer_Delegate {
    
    func audioPlayOrPauseAction() {
        let course = infoModel!.data
        if course.video.isEmpty == false && course.video.contains(".mp3") {
            if audioPlayer.state == .playing {
                audioPlayer.pause()
                playBtn.setImage(UIImage.init(named: "xz_daoxue_play"), for: UIControlState.normal)
            } else {
                if audioPlayer.state == .paused {
                    audioPlayer.play()
                }else {
                    audioPlayer.play(file: Music.init(name: "", url:URL.init(string: course.video)!))
                }
                playBtn.setImage(UIImage.init(named: "xz_daoxue_pause"), for: UIControlState.normal)
            }
        }
    }
    
    // === HDLY_AudioPlayer_Delegate ===
    
    func finishPlaying() {
        playBtn.setImage(UIImage.init(named: "xz_daoxue_play"), for: UIControlState.normal)
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
        timeL.text = "\(currentTime)/\(totalTime)"
        //LOG(" progress: \(progress)")
    }
    
}

extension HDLY_CourseDes_VC {

    func tapErrorBtnAction() {
        if showFeedbackChooseTip == false {
            let  tipView = HDLY_FeedbackChoose_View.createViewFromNib()
            feedbackChooseTip = tipView as? HDLY_FeedbackChoose_View
            feedbackChooseTip?.frame = CGRect.init(x: ScreenWidth-20-120, y: 45, width: 120, height: 100)
            feedbackChooseTip?.tapBtn1.setTitle("反馈", for: .normal)
            feedbackChooseTip?.tapBtn2.setTitle("报错", for: .normal)
            self.topView.addSubview(feedbackChooseTip!)
            showFeedbackChooseTip = true
            weak var weakS = self
            feedbackChooseTip?.tapBlock = { (index) in
                weakS?.feedbackChooseAction(index: index)
            }
        } else {
            closeFeedbackChooseTip()
        }
    }
    
    func closeFeedbackChooseTip() {
        feedbackChooseTip?.tapBlock = nil
        feedbackChooseTip?.removeFromSuperview()
        showFeedbackChooseTip = false
    }
    
    func feedbackChooseAction(index: Int) {
        if index == 1 {
            //反馈
            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Feedback_VC") as! HDLY_Feedback_VC
            vc.typeID = "1"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }else {
            //报错
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
            if infoModel?.data.articleID.string != nil {
                vc.articleID = infoModel!.data.articleID.string
                vc.typeID = "1"
            }
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }
    }
    
}

