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
    @IBOutlet weak var tryListenL: UILabel!
    //
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    @IBOutlet weak var backBtn  : UIButton!
    @IBOutlet weak var navShadowImgV: UIImageView!
    @IBOutlet weak var navBgView : UIView!      //导航栏背景
    @IBOutlet weak var topImgV: UIImageView!
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    var infoModel: CourseModel?
    var isMp3Course = false
    var orderTipView: HDLY_CreateOrderTipView?
    var isStatusBarHidden = false//是否隐藏状态栏
    var isFromTeacherCenter = false

//    var kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    var kVideoCover = ""

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
    var loadingView: HDLoadingView?
    var webViewH:CGFloat = 0
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
    var shareView: HDLY_ShareView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        //statusBarHCons.constant = kStatusBarHeight+24
        myTableView.separatorStyle = .none
        buyBtn.layer.cornerRadius = 27
        listenBgView.configShadow(cornerRadius: 25, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        setupvideoPlayer()
        self.bottomHCons.constant = 0
        self.listenBgView.isHidden = true
        bindViewModel()
        if audioPlayer.state == .playing {
            HDFloatingButtonManager.manager.floatingBtnView.closeAction()
        }
        audioPlayer.showFloatingBtn = false
        navBgView.isHidden = true
        navBgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        likeBtn.setImage(UIImage.init(named: "Star_white"), for: .normal)
        likeBtn.setImage(UIImage.init(named: "Star_red"), for: .selected)
        loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
        loadingView?.frame = self.view.bounds
        view.addSubview(loadingView!)
        dataRequest()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return self.isStatusBarHidden
    }
    
    private func setupvideoPlayer() {
        //
        self.videoPlayer.controlView = self.controlView
        // 设置退到后台继续播放
        self.videoPlayer.pauseWhenAppResignActive = false
        
        weak var _self = self
        self.videoPlayer.orientationWillChange = { (player,isFullScreen) -> (Void) in
            _self?.isStatusBarHidden = isFullScreen
            _self?.setNeedsStatusBarAppearanceUpdate()
        }
        
        // 播放完自动播放下一个
        self.videoPlayer.playerDidToEnd = { (asset) -> () in
            
        }
        self.videoPlayer.playerPlayStateChanged = { (asset,state) -> () in
            if ZFReachabilityManager.shared().isReachable == false {
                HDAlert.showAlertTipWith(type: .onlyText, text: "网络连接不可用")
            }
        }
        
    }
    
    @IBAction func playClick(_ sender: UIButton) {
        guard let course = infoModel?.data else {
            return
        }
        if ZFReachabilityManager.shared().isReachable == false {
            HDAlert.showAlertTipWith(type: .onlyText, text: "网络连接不可用")
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
    
    func autoPlayAction() {
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.orderTipView?.sureBlock = nil
                self.orderTipView?.removeFromSuperview()
            }
        }
        
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        //收藏
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.likeBtn.isSelected = false
            } else {
                weakSelf?.likeBtn.isSelected = true
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
                self.tryListenL.text = "试听"
            }else {
                self.isMp3Course = false
                self.tryListenL.text = "试学"
            }
            //self.autoPlayAction()
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    if self.infoModel!.data.yprice != nil {
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
                    }
                    self.listenBgView.isHidden = false

                }else {
                    self.buyBtn.setAttributedTitle(nil, for: .normal)
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
                self.topImgV.kf.setImage(with: URL.init(string: self.kVideoCover))
//                self.getWebHeight()
                self.myTableView.reloadData()
                if self.infoModel?.data.isFavorite == 1 {
                    self.likeBtn.isSelected = true
                }else {
                    self.likeBtn.isSelected = false
                }
            }
            
        }) { (errorCode, msg) in
            //self.loadingView?.removeFromSuperview()

            self.loadingView?.removeFromSuperview()
            self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.myTableView.ly_showEmptyView()
//            self.loadingView?.removeFromSuperview()
            //
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
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
                return 0.01
            }
            if buynotice.count < 3 {
                return 0.01
            }
            let textH = buynotice.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
            return textH + 80 + 15
        }
        else if indexPath.section == 3 {
            guard let recommendsList = infoModel?.data.recommendsList else {
                return 0.01
            }
            if recommendsList.count > 0 {
                return 220*ScreenWidth/375.0
            }
            return 0.01
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
                    focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: focusBtn.size), for: .normal)
                    
                }else {
                    focusBtn.setTitle("+关注", for: .normal)
                    focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: focusBtn.size), for: .normal)

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
            if model?.buynotice.count ?? 0 > 3 {
                cell?.titleL.text = "购买须知"
                cell?.contentL.text = model?.buynotice
            }
            return cell!
        }
        else if indexPath.section == 3 {
            let cell = HDLY_CourseRecmd_Cell.getMyTableCell(tableV: tableView)
            if model?.recommendsList?.count ?? 0 > 0 {
                cell?.listArray = model?.recommendsList
            }
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 && isFromTeacherCenter == false {
            let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
            let vc: HDLY_TeachersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDLY_TeachersCenterVC") as! HDLY_TeachersCenterVC
            vc.type = 1
            vc.detailId = infoModel?.data.teacherID.int ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 1 {
            guard let recommendsMessage = infoModel?.data.recommendsMessage else {
                return
            }
            let  model  = recommendsMessage[indexPath.row]
            self.pushToOthersPersonalCenterVC(model.uid ?? 0)
        }

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
            feedbackChooseTip?.frame = CGRect.init(x: ScreenWidth-20-120, y: 90, width: 120, height: 100)
            feedbackChooseTip?.tapBtn1.setTitle("反馈", for: .normal)
            feedbackChooseTip?.tapBtn2.setTitle("报错", for: .normal)
            self.view.addSubview(feedbackChooseTip!)
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
            vc.parent_id = self.infoModel?.data.articleID.string
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
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

extension HDLY_CourseDes_VC: UMShareDelegate {
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        let tipView: HDLY_ShareView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        shareView = tipView
    }
    
    
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard let url  = self.infoModel?.data.share_url else {
            return
        }
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = url
        let shareObject = UMShareWebpageObject.shareObject(withTitle: self.infoModel?.data.title, descr: self.infoModel?.data.share_des, thumImage: thumbURL)
        
        //设置网页地址
        shareObject?.webpageUrl = self.infoModel?.data.img
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        weak var weakS = self
        
        
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { data, error in
            if error != nil {
                //UMSocialLog(error)
                LOG(error)
                weakS?.shareView?.alertWithShareError(error!)
            } else {
                if (data is UMSocialShareResponse) {
                    let resp = data as? UMSocialShareResponse
                    //分享结果消息
                    LOG(resp?.message)
                    //第三方原始返回的数据
                    print(resp?.originalResponse ?? 0)
                } else {
                    LOG(data)
                }
                HDAlert.showAlertTipWith(type: .onlyText, text: "分享成功")
                HDLY_ShareGrowth.shareGrowthRequest()
                weakS?.shareView?.removeFromSuperview()
            }
        }
        
        
    }
    

    
}

extension HDLY_CourseDes_VC: UIScrollViewDelegate {
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LOG("*****:HDLY_ListenDetail_VC:\(scrollView.contentOffset.y)")
//        if self.myTableView == scrollView {
//            //滚动时刷新webview
//            for view in self.myTableView.visibleCells {
//                if view.isKind(of: HDLY_CourseWeb_Cell.self) {
//                    let cell = view as! HDLY_CourseWeb_Cell
//                    cell.webview.setNeedsLayout()
//                }
//            }
//        }
        
        //导航栏
        let offSetY = scrollView.contentOffset.y
        if offSetY >= kTableHeaderViewH1 {
            navBgView.isHidden = false
            navShadowImgV.isHidden = true
            backBtn.setImage(UIImage.init(named: "nav_back"), for: .normal)
            errorBtn.setImage(UIImage.init(named: "xz_icon_more_black_default"), for: .normal)
            shareBtn.setImage(UIImage.init(named: "xz_icon_share_black_default"), for: .normal)
            if likeBtn.isSelected == false {
                likeBtn.setImage(UIImage.init(named: "Star_black"), for: .normal)
            }
        } else {
            navBgView.isHidden = true
            navShadowImgV.isHidden = false
            backBtn.setImage(UIImage.init(named: "nav_back_white"), for: .normal)
            errorBtn.setImage(UIImage.init(named: "xz_icon_more_white_default"), for: .normal)
            shareBtn.setImage(UIImage.init(named: "xz_icon_share_white_default"), for: .normal)
            if likeBtn.isSelected == false {
                likeBtn.setImage(UIImage.init(named: "Star_white"), for: .normal)
            }
        }
        
    }
}

extension HDLY_CourseDes_VC : WKNavigationDelegate,WKUIDelegate {
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
                self.myTableView.reloadData()
                self.loadingView?.removeFromSuperview()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingView?.removeFromSuperview()
        self.myTableView.ly_showEmptyView()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.loadingView?.removeFromSuperview()
        self.myTableView.ly_showEmptyView()
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
