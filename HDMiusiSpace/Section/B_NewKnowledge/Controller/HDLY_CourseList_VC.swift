//
//  HDLY_CourseList_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/14.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_VC: HDItemBaseVC, SPPageMenuDelegate, UIScrollViewDelegate, ChapterListPlayDelegate{
    
    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    var infoModel: CourseDetail?
    var isMp3Course = false
    var showLeaveMsg = false

    var kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    
    var courseId:String?
    
    lazy var controlView:ZFPlayerControlView = {
        let controlV = ZFPlayerControlView.init()
        controlV.fastViewAnimated = true
        return controlV
    }()
    
    lazy var player:ZFPlayerController =  {
        let playerC = ZFPlayerController.init(playerManager: ZFAVPlayerManager(), containerView: self.containerView)
        return playerC
    }()
    
    let titleArray:Array = ["章节", "详情", "问答", "留言"]
    
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x: 20, y: 0, width: ScreenWidth-40, height: 60), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.setItems(titleArray, selectedItemIndex: 0)
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 18)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.clear
        page.backgroundColor = UIColor.white
        page.permutationWay = SPPageMenuPermutationWay.notScrollEqualWidths
        page.bridgeScrollView = self.contentScrollView
        
        return page
    }()
    
    lazy var contentScrollView: UIScrollView =  {
        let scrollView = UIScrollView.init()
        scrollView.frame  = CGRect.zero
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        
        return scrollView
    }()
    
    var childVCScrollView: UIScrollView?
    let courseListTopH = (kStatusBarHeight+24+60+ScreenWidth*9/16.0)
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    let uploadVM = HDLY_RootCVM()
    var listPlayModel: ChapterList?
    var currentPlayTime: TimeInterval = 0
    var isStatusBarHidden = false//是否隐藏状态栏
    var shareView: HDLY_ShareView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        statusBarHCons.constant = 44
        //
        self.player.controlView = self.controlView
        self.contentScrollView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-courseListTopH)
        contentView.addSubview(contentScrollView)
        menuView.addSubview(self.pageMenu)
        
        setupPlayer()
        
        dataRequest()
        addContentSubViewsWithArr(titleArr: titleArray)
        bindViewModel()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player.isViewControllerDisappear = false
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.isViewControllerDisappear = true
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return self.isStatusBarHidden
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
        
    }
    
    private func setupPlayer() {
        // 设置退到后台继续播放
        self.player.pauseWhenAppResignActive = false
        
        weak var _self = self
        self.player.orientationWillChange = { (player,isFullScreen) -> (Void) in
            _self?.isStatusBarHidden = isFullScreen
            _self?.setNeedsStatusBarAppearanceUpdate()
        }
        
        // 播放完自动播放下一个
        self.player.playerDidToEnd = { (asset) -> () in
            
        }
        
        self.player.playerPlayStateChanged = { (asset,state) -> () in
            if state == ZFPlayerPlaybackState.playStatePaused {
                _self?.uploadRecordActions()
            }
            else if state == ZFPlayerPlaybackState.playStatePlayStopped {
                _self?.uploadRecordActions()
            }
        }
        
        self.player.playerPlayTimeChanged = { (asset,currentTime,duration) -> () in
            LOG("===== currentTime: \(currentTime),===== duration:  \(duration)")
            _self?.currentPlayTime = currentTime
        }
    }
    
    func uploadRecordActions() {
        guard let model = self.listPlayModel else {
            return
        }
        
        let token:String? = HDDeclare.shared.api_token
        if token != nil {
            let time = HDLY_AudioPlayer.shared.formatPlayTime(seconds: currentPlayTime)
            uploadVM.uploadCourseRecordsRequest(api_token: token!, chapter_id: model.chapter_id, study_time: time, self)
            
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
    
    
    @IBAction func playClick(_ sender: UIButton) {
        
        guard let course = infoModel?.data else {
            return
        }
        HDFloatingButtonManager.manager.floatingBtnView.closeAction()

        if isMp3Course {
            if course.video.isEmpty == false && course.video.contains(".mp3") {
                self.player.assetURL = NSURL.init(string: course.video)! as URL
                self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
                self.controlView.coverImageHidden = false
            }
        }else {
            if course.video.isEmpty == false && course.video.contains(".mp4") {
                self.player.assetURL = NSURL.init(string: course.video)! as URL
                self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
            }
        }
    }
    
    // ChapterListPlayDelegate
    func playWithCurrentPlayUrl(_ model: ChapterList) {
        
        HDFloatingButtonManager.manager.floatingBtnView.closeAction()
        listPlayModel = model
        let video = model.video
        if video.isEmpty == false && video.contains(".mp3") {
            self.player.assetURL = NSURL.init(string: video)! as URL
            self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
            self.controlView.coverImageHidden = false
        }
        else if video.isEmpty == false && video.contains(".mp4") {
            self.player.assetURL = NSURL.init(string: video)! as URL
            self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
        }
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
            let model:CourseDetail = try! jsonDecoder.decode(CourseDetail.self, from: result)
            self.infoModel = model
            
            if self.infoModel?.data.fileType == 1 {
                //1是MP3;2是MP4
                self.isMp3Course = true
            }else {
                self.isMp3Course = false
            }
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
            }else {
            }
            if self.infoModel != nil {
                self.kVideoCover = self.infoModel!.data.img
                if self.infoModel?.data.isFavorite == 1 {
                    self.likeBtn.setImage(UIImage.init(named: "Star_red"), for: UIControlState.normal)
                }else {
                    self.likeBtn.setImage(UIImage.init(named: "Star_white"), for: UIControlState.normal)
                }
            }
            
        }) { (errorCode, msg) in
  
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
}


// PageMenu
extension HDLY_CourseList_VC {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.contentScrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.contentScrollView.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
            switch i {
            case 0://
                let baseVC:HDLY_CourseList_SubVC1 = HDLY_CourseList_SubVC1.init()
                baseVC.courseId = self.courseId
                self.addChildViewController(baseVC)
                baseVC.delegate = self
                baseVC.view.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-courseListTopH)
                self.contentScrollView.addSubview(self.childViewControllers[0].view)
            case 1://
                let baseVC:HDLY_CourseList_SubVC2 = HDLY_CourseList_SubVC2.init()
                baseVC.courseId = self.courseId
                self.addChildViewController(baseVC)
            case 2://
                let baseVC:HDLY_CourseList_SubVC3 = HDLY_CourseList_SubVC3.init()
                baseVC.courseId = self.courseId
                self.addChildViewController(baseVC)
            case 3://
                let baseVC:HDLY_CourseList_SubVC4 = HDLY_CourseList_SubVC4.init()
                baseVC.courseId = self.courseId
                self.addChildViewController(baseVC)
            default: break
                
            }
        }
        if showLeaveMsg == true {
            self.pageMenu(self.pageMenu, itemSelectedFrom: 0, to: 3)
            self.pageMenu.selectedItemIndex = 2
        }
    }
    
    
    //MARK: ---- SPPageMenuDelegate -----
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        if self.childViewControllers.count == 0 {
            return
        }
        // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            self.contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }else {
            self.contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }
        let targetViewController:UIViewController = self.childViewControllers[toIndex]
        if targetViewController.isViewLoaded == true {
            return;
        }
        
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight-courseListTopH)
        self.contentScrollView.addSubview(targetViewController.view)
    }
}

extension HDLY_CourseList_VC {
    
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


extension HDLY_CourseList_VC: UMShareDelegate {
    
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
        
        guard let url  = self.infoModel?.data.url else {
            return
        }
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = url
        let shareObject = UMShareWebpageObject.shareObject(withTitle: self.infoModel?.data.title, descr: self.infoModel?.data.title, thumImage: thumbURL)
        
        //设置网页地址
        shareObject?.webpageUrl = url
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

