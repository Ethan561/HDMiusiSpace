//
//  HDLY_ListenDetail_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_ListenDetail_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate{
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var commentBgView: UIView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var likeNumL: UILabel!
    
    @IBOutlet weak var rightBarBtn  : UIButton!
    @IBOutlet weak var backBtn  : UIButton!
    @IBOutlet weak var navShadowImgV: UIImageView!
    @IBOutlet weak var navBgView : UIView!      //导航栏背景
    
    var loadingView: HDLoadingView?
    var skip = 0
    var take = 10
    var cmtNum = 0
    var isAddedPlayNumber: Bool = false
    //
    var player = HDFloatingButtonManager.manager
    var webViewH:CGFloat = 0
    var infoModel: ListenDetail?
    var commentModels = [TopicCommentList]()
    var listen_id:String?
    var playerBtn: UIButton!
    var timeL: UILabel!
    var commentText = ""
    var shareView: HDLY_ShareView?
    var htmls = [Int:[NSAttributedString]]()
    //MVVM
    let viewModel: ListenDetailViewModel = ListenDetailViewModel()
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    let commentListViewModel: TopicDetailViewModel = TopicDetailViewModel()
    
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    lazy var commentView: HDZQ_CommentActionView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_CommentActionView", owner: nil, options: nil)?.last as? HDZQ_CommentActionView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tmp?.delegate = self
        return tmp!
    }()
    
    var keyboardTextField : KeyboardTextField!
    var focusBtn: UIButton!
    var isNeedRefresh = false
    
    override func loadView() {
        super.loadView()
        setupCommentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarHCons.constant = kStatusBarHeight
        self.hd_navigationBarHidden = true
        myTableView.separatorStyle = .none
        myTableView.estimatedRowHeight = 0
        myTableView.estimatedSectionHeaderHeight = 0
        myTableView.estimatedSectionFooterHeight = 0
        player.delegate = self
        commentBgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        textBgView.layer.cornerRadius = 19
        addRefresh()
        //MVVM
        bindViewModel()
        
        refreshAction()
        self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
        player.showFloatingBtn = false
        navBgView.isHidden = true
        navBgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerInterruptionPauseNoti(noti:)), name: NSNotification.Name(rawValue: "AVPlayerInterruptionPauseNoti"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HDFloatingButtonManager.manager.floatingBtnView.show = false
        if isNeedRefresh == true && HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            refreshAction()
            isNeedRefresh = false
        }else {
            isNeedRefresh = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let headerH = ScreenWidth*210/375.0
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: headerH)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func addRefresh() {
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.myTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.myTableView.refreshIdentifier = String.init(describing: self)
        self.myTableView.expiredTimeInterval = 20.0
    }
    
    private func loadMore() {
        skip = skip + take
        requestComments(skip: skip, take: take)
    }
    
    @objc func refreshAction() {
        if listen_id != nil {
            loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
            loadingView?.frame = self.view.bounds
            view.addSubview(loadingView!)
            viewModel.dataRequestWithListenID(listenID: listen_id!, self)
        }
    }
    
    @objc func requestComments(skip:Int,take:Int) {
        if listen_id != nil {
            commentListViewModel.requestCommentList(cate_id: 2, id: Int(listen_id!)!, skip: skip, take: take, vc: self)
        }
    }
    
    //MVVM
    
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.listenDetail.bind { (_) in
            weakSelf?.showViewData()
        }
        viewModel.showEmptyView.bind() { (show) in
            if show {
                weakSelf?.loadingView?.removeFromSuperview()
                weakSelf?.myTableView.ly_showEmptyView()
            }else {
                weakSelf?.myTableView.ly_hideEmptyView()
            }
        }
        
        commentListViewModel.commentModels.bind { (models) in
            var comments = models
            if weakSelf?.skip == 0 {
                weakSelf?.htmls.removeAll()
            }
            for i in 0..<comments.count {
                var hms = [NSAttributedString]()
                for j in 0..<comments[i].list.count {
                    let str = "\(comments[i].list[j].uNickname)：\(comments[i].list[j].comment)"
                    var attrStr: NSAttributedString? = nil
                    if let anEncoding = str.data(using: .unicode) {
                        attrStr = try? NSAttributedString(data: anEncoding, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    }
                    hms.append(attrStr!)
                    let textH = attrStr!.getAttributeContentHeight(width: ScreenWidth - 90)
                    comments[i].list[j].height = Int(textH + 5)
                    comments[i].height = comments[i].height + comments[i].list[j].height
                    if j == 0 {
                        comments[i].topHeight = comments[i].list[j].height
                    }
                    if j == 1 {
                        comments[i].topHeight = comments[i].topHeight + comments[i].list[j].height
                    }
                }
                if weakSelf?.skip == 0 {
                    weakSelf?.htmls.updateValue(hms, forKey: i)
                } else {
                    weakSelf!.htmls.updateValue(hms, forKey: i + (weakSelf?.commentModels.count)!)
                }
                comments[i].height = comments[i].height
            }
            if weakSelf?.skip == 0 {
                weakSelf?.commentModels = comments
            } else {
                var indexPaths = [IndexPath]()
                for j in 0..<comments.count {
                    let indexPath = NSIndexPath.init(row: (weakSelf?.commentModels.count)! + j, section: 1)
                    indexPaths.append(indexPath as IndexPath)
                }
                weakSelf?.commentModels.append(contentsOf: comments)
                weakSelf?.myTableView.beginUpdates()
                weakSelf?.myTableView.insertRows(at: indexPaths, with: .fade)
                weakSelf?.myTableView.endUpdates()
            }
            
            weakSelf?.myTableView.es.stopLoadingMore()
            weakSelf?.myTableView.es.stopPullToRefresh()
            if comments.count == 0 {
                if weakSelf?.skip != 0 {
                    weakSelf?.myTableView.es.noticeNoMoreData()
                } else {
                    weakSelf?.myTableView.es.removeRefreshFooter()
                }
            }
            weakSelf?.myTableView.reloadData()
        }
        
        //评论
        publicViewModel.commentSuccess.bind { (flag) in
            weakSelf?.keyboardTextField.textView.text = " "
            weakSelf?.keyboardTextField.textView.deleteBackward()
            weakSelf?.closeKeyBoardView()
            weakSelf?.cmtNum = (weakSelf?.cmtNum)! + 1
            weakSelf?.skip = 0
            weakSelf?.requestComments(skip: 0, take: 100)
        }
        //
        publicViewModel.likeModel.bind { (model) in
            weakSelf?.likeNumL.text = model.like_num?.string
            if model.is_like?.int == 0 {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControl.State.normal)
            }else {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControl.State.normal)
            }
        }
        
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControl.State.normal)
            } else {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControl.State.normal)
            }
        }
        publicViewModel.isFocus.bind { (flag) in
            weakSelf?.showFocusView(flag)
        }
        
        publicViewModel.reportErrorModel.bind { [weak self] (model) in
            var strs = [String]()
            var reportType = [Int]()
            model.data?.optionList.forEach({ (m) in
                strs.append(m.optionTitle)
                reportType.append(m.optionID)
            })
            self?.commentView.dataArr = strs
            self?.commentView.reportType = reportType
            self?.commentView.tableHeightConstraint.constant = CGFloat(50 * strs.count)
            self?.commentView.type = 1
            self?.commentView.tableView.reloadData()
        }
        
        //删除评论
        publicViewModel.deleteCommentReplySuccess.bind { (ret) in
            //
            if ret == true {
                 weakSelf?.skip = 0
                weakSelf?.cmtNum = (weakSelf?.cmtNum)! - 1
                weakSelf?.requestComments(skip: 0, take: 100)
            }
        }
    }
    
    func showViewData() {
        let model = viewModel.listenDetail.value
        // 计算总高度 保存到模型中去
        self.infoModel = model
        HDFloatingButtonManager.manager.listenID = model.listenID?.string ?? ""
        HDFloatingButtonManager.manager.iconUrl = model.icon ?? ""
        if let cmtNum = infoModel?.comments {
            self.cmtNum = cmtNum
        }
        if infoModel?.img != nil {
            self.imgV.kf.setImage(with: URL.init(string: infoModel!.img!), placeholder: UIImage.grayImage(sourceImageV: self.imgV), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if self.infoModel?.voice != nil && (self.infoModel?.voice?.contains("http://"))! {
            if player.url != self.infoModel?.voice {
                player.stop()
            }
        }

//        self.getWebHeight()
        self.myTableView.reloadData()
        //点赞
        likeNumL.text = infoModel?.likes?.string
        if ((infoModel?.isLike) != nil) {
            if infoModel!.isLike == 0 {
                likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControl.State.normal)
            } else {
                likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControl.State.normal)
            }
        }
        //收藏
        if ((infoModel?.isFavorite) != nil) {
            if infoModel!.isFavorite == 0 {
                collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControl.State.normal)
            } else {
                collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControl.State.normal)
            }
        }
        addPlayNumber()

    }
    
    func showFocusView(_ isFocus: Bool) {
        if isFocus {
            infoModel?.isFocus = 1
            focusBtn.setTitle("已关注", for: .normal)
            self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.focusBtn.size), for: .normal)
            

        }else {
            infoModel?.isFocus = 0
            focusBtn.setTitle("+关注", for: .normal)
            self.focusBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.focusBtn.size), for: .normal)
            

        }
    }
    
    @IBAction func errorBtnAction(_ sender: UIButton) {
        guard let win = kWindow else {
            return
        }
        let  tipView = HDLY_FeedbackChoose_View.createViewFromNib()
        feedbackChooseTip = tipView as? HDLY_FeedbackChoose_View
        feedbackChooseTip?.frame = win.bounds
        feedbackChooseTip?.tapBtn1.setTitle("分享", for: .normal)
        feedbackChooseTip?.tapBtn2.setTitle("报错", for: .normal)
        win.addSubview(feedbackChooseTip!)
        showFeedbackChooseTip = true
        weak var weakS = self
        feedbackChooseTip?.tapBlock = { (index) in
            weakS?.feedbackChooseAction(index: index)
        }
    }
    
    func closeFeedbackChooseTip() {
        feedbackChooseTip?.tapBlock = nil
        feedbackChooseTip?.removeFromSuperview()
        showFeedbackChooseTip = false
    }
    
    func feedbackChooseAction(index: Int) {
        if index == 1 {
            //分享
            shareBtnAction()
            closeFeedbackChooseTip()

        }else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            //报错
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
            vc.articleID = infoModel?.listenID?.string
            vc.typeID = "2"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }
    }
    
    @IBAction func commentBtnAction(_ sender: UIButton) {
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            isNeedRefresh = true
            return
        }
        keyboardTextField.placeholderLabel.text = "写下你的评论吧"
        keyboardTextField.type = 0
        showKeyBoardView()
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.listenID?.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                isNeedRefresh = true

                return
            }
            publicViewModel.doLikeRequest(id: idnum, cate_id: "4", self)
        }
    }
    
    @IBAction func collectionBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.listenID?.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                isNeedRefresh = true

                return
            }
            publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "4", self)
        }
    }
    
    @objc func focusBtnAction()  {
        if let idnum = infoModel?.teacherID?.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                isNeedRefresh = true

                return
            }
            publicViewModel.doFocusRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "2", self)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_ListenDetail_VC : HDFloatingButtonManager_AudioPlayer_Delegate {
    
    @objc  func playOrPauseAction(_ sender: UIButton) {
        if self.infoModel?.voice != nil && (self.infoModel?.voice?.contains("http://"))! {
            if ZFReachabilityManager.shared().isReachable == false {
                HDAlert.showAlertTipWith(type: .onlyText, text: "网络连接不可用")
            }
            var voicePath = self.infoModel!.voice!
            if voicePath.contains("m4a") {
                voicePath = self.infoModel!.voice!.replacingOccurrences(of: "m4a", with: "wav")
            }
            //
            if player.state == .playing {
                player.pause()
                playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControl.State.normal)
            } else {
                if player.state == .paused {
                    player.play()
                    if isAddedPlayNumber == false {
                        //addPlayNumber()
                        isAddedPlayNumber = true
                    }
                }else {
                    //let url = "http://47.105.71.75/uploadfiles/mp3/20180905/201809051500582729.mp3"
                    
                    player.play(file: Music.init(name: "", url:URL.init(string: voicePath)!))
                    player.url = self.infoModel!.voice!
                    //播放数量加一
                    //addPlayNumber()
                }
                playerBtn.setImage(UIImage.init(named: "icon_pause_white"), for: UIControl.State.normal)
            }
        }
    }
    //MARK:--- 播放数量加1
    func addPlayNumber(){
        if isAddedPlayNumber == false {
            if self.infoModel?.listenID?.string != nil {
                viewModel.listenedNumAdd(listenID: self.infoModel!.listenID!.string)
            }
            isAddedPlayNumber = true
        }
    }
    // === HDLY_AudioPlayer_Delegate ===
    
    func finishPlaying() {
        playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControl.State.normal)
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
        timeL.text = "\(currentTime)/\(totalTime)"
//      LOG(" progress: \(progress)")
    }
    
    
    @objc func avplayerInterruptionPauseNoti(noti:Notification) {
        player.pause()
        playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControl.State.normal)
    }
    
}

extension HDLY_ListenDetail_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard (infoModel?.comments) != nil else {
            return 0.01
        }
        if  section == 1{
            return 50
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let titleV:HDLY_ListenComment_Header = HDLY_ListenComment_Header.createViewFromNib() as! HDLY_ListenComment_Header
            titleV.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50)
            titleV.titleL.text = "评论"
            return titleV
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
        if section == 1 {
            if commentModels.count == 0 { return 1 }
            return commentModels.count
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if index == 0 {
                //标题显示完整，自适应高度
                if infoModel == nil {
                    return 180*ScreenWidth/375.0
                }else {
                    let size = infoModel?.title!.getLabSize(font: UIFont.systemFont(ofSize: 22), width: ScreenWidth - 40)
                    return (170 + (size?.height)!)*(ScreenWidth-40)/375.0
                }
            }
            else if index == 1 {
                if infoModel?.is_voice == 0 {
                    return 0.01
                }
                return 95
            }
            else if index == 2 {
                return webViewH
            }
        }else {
            if commentModels.count == 0 { return 150 }
            let commentModel = commentModels[index]
            let textH = commentModel.comment.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-85)
            var subCommentsH = 0
            if commentModel.list.count < 3 {
                subCommentsH = commentModel.height + 60
            } else {
                if commentModel.showAll {
                    subCommentsH = commentModel.height + 50
                } else {
                    subCommentsH = commentModel.topHeight + 70
                }
            }
            return textH + 60 + CGFloat(subCommentsH)
            
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = infoModel
        let index = indexPath.row
        if indexPath.section == 0 {
            if index == 0 {
                let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
                if model?.teacherImg != nil {
                    cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.teacherImg!)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell?.titleL.text = model?.title
                cell?.nameL.text = model?.teacherName
                cell?.desL.text = model?.teacherTitle
                cell?.focusBtn.addTarget(self, action: #selector(focusBtnAction), for: UIControl.Event.touchUpInside)
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
                if infoModel?.is_voice == 0 {
                    return UITableViewCell.init()
                }
                let cell = HDLY_ListenPlayer_Cell.getMyTableCell(tableV: tableView)
                playerBtn = cell?.playerBtn
                timeL = cell?.timeL
                //
                playerBtn.addTarget(self, action: #selector(playOrPauseAction(_:)), for: UIControl.Event.touchUpInside)
                if player.state == .playing {
                    playerBtn.setImage(UIImage.init(named: "icon_pause_white"), for: UIControl.State.normal)
                } else {
                    playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControl.State.normal)
                    if player.state != .paused {
                        cell?.timeL.text = infoModel?.timelong?.string
                    }
                }
                return cell!
            }
            else if index == 2 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = self.infoModel?.url else {
                    return cell!
                }
                if webViewH == 0 {
                    cell?.loadWebView(url)
                }
                cell?.webview.frame.size.height = webViewH
                cell?.webview.navigationDelegate = self
                return cell!
            }
        } else {
            if commentModels.count == 0 {
                let cell = HDSSL_noCommentCell.getMyTableCell(tableV: tableView) as HDSSL_noCommentCell
                cell.bottomLineView.isHidden = true
                return cell
            }
            let cell = HDLY_LeaveMsg_Cell.getMyTableCell(tableV: tableView)
            if model?.commentList != nil {
                let commentModel = self.commentModels[index]
                
                cell?.avatarBtn.kf.setImage(with: URL.init(string: commentModel.avatar), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                
                cell?.contentL.text = commentModel.comment
                cell?.timeL.text = commentModel.createdAt
                cell?.nameL.text = commentModel.nickname
                cell?.htmls = self.htmls[indexPath.row]
                cell?.uid = commentModel.uid
                cell?.commentId = commentModel.commentID
                cell?.commentContent = commentModel.comment
                cell?.likeBtn.setTitle(commentModel.likeNum.string, for: UIControl.State.normal)
                if commentModel.list.count > 0 {
                    cell?.subContainerView.isHidden = false
                    cell?.setupSubContainerView(subModel: commentModel, showAll: commentModel.showAll)
                    cell?.showMoreBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                        self?.commentModels[index].showAll = true
                        self?.myTableView.reloadRows(at: [indexPath], with: .none)
                    })
                } else {
                    cell?.subContainerView.isHidden = true
                }
                if commentModel.isLike == 0 {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControl.State.normal)
                }else {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControl.State.normal)
                }
                
                cell?.likeBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                    if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                        self?.pushToLoginVC(vc: self!)
                        self?.isNeedRefresh = true

                    } else {
                        self?.doLikeRequest(id: String(commentModel.commentID), cate_id: "5", success: { (result) in
                            if self?.commentModels[index].isLike == 0 {
                                self?.commentModels[index].isLike = 1
                                self?.commentModels[index].likeNum.int = (self?.commentModels[index].likeNum.int)! + 1
                                cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControl.State.normal)
                                cell?.likeBtn.setTitle(self?.commentModels[index].likeNum.string, for: .normal)
                            }else {
                                self?.commentModels[index].isLike = 0
                                self?.commentModels[index].likeNum.int = (self?.commentModels[index].likeNum.int)! - 1
                                cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControl.State.normal)
                                cell?.likeBtn.setTitle(self?.commentModels[index].likeNum.string, for: .normal)
                            }
                        }, failure: { (error, msg) in })
                    }
                })
                
                cell?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                    if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                        self?.pushToLoginVC(vc: self!)
                        self?.isNeedRefresh = true
                    } else {
                        self?.pushToOthersPersonalCenterVC(commentModel.uid)
                    }
                })
                
                // 单击回复
                cell?.tapPress = { [weak self] (commentId) in
                    self?.keyboardTextField.textView.text = " "
                    self?.keyboardTextField.textView.deleteBackward()
                    self?.keyboardTextField.placeholderLabel.text = "回复@\(commentModel.nickname)"
                    self?.keyboardTextField.returnID = commentModel.commentID
                    self?.keyboardTextField.type = 1
                    self?.showKeyBoardView()
                    
                }
                
                cell?.longPress  = { [weak self] (commentId,comment) in
                    
                    if commentModel.commentID == commentId{
                        //长按评论
                        self?.commentView.type = 0
                        self?.commentView.model = commentModel
                        self?.commentView.commentContent = comment
                        if commentModel.uid == HDDeclare.shared.uid {
                            self?.commentView.dataArr = ["复制","举报","删除"]
                        }else{
                            self?.commentView.dataArr = ["复制","举报"]
                        }
                    }else{
                        //长按回复
                        self?.commentView.type = 0
                        self?.commentView.model = commentModel
                        self?.commentView.commentContent = comment
                        self?.commentView.dataArr = ["复制","举报"]
                        
                        let returnArr = commentModel.list
                        if returnArr.count > 0{
                            for returnModel in returnArr {
                                if returnModel.uid == HDDeclare.shared.uid && returnModel.commentID == commentId{
                                    //自己的回复，模型转换
                                    let model1 = TopicCommentList.init(uid: returnModel.uid, comment: returnModel.comment, likeNum: commentModel.likeNum, createdAt: "", commentID: returnModel.commentID, avatar: "", nickname: returnModel.uNickname, isLike: 0, list: [], showAll: true, height: 44, topHeight: 64)
                                    self?.commentView.model = model1
                                    self?.commentView.commentContent = returnModel.comment
                                    self?.commentView.dataArr = ["复制","举报","删除"]
                                    break
                                }
                            }
                        }
                        
                        
                    }
                    
                    
                    self?.commentView.tableHeightConstraint.constant = CGFloat((self?.commentView.dataArr.count)!*50)
                    self?.commentView.tableView.reloadData()
                    kWindow?.addSubview((self?.commentView)!)
                }
                
                
                cell?.answer  = { [weak self] (commentId,nickname) in
                    self?.keyboardTextField.textView.text = " "
                    self?.keyboardTextField.textView.deleteBackward()
                    self?.keyboardTextField.placeholderLabel.text = "回复@\(nickname)"
                    self?.keyboardTextField.returnID = commentId
                    self?.keyboardTextField.type = 1
                    self?.showKeyBoardView()
                }
            }
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            self.pushToPlatCenter()
        }
    }
}

extension HDLY_ListenDetail_VC: HDZQ_CommentActionDelegate {
    func commentActionSelected(type: Int, index: Int, model: TopicCommentList, comment: String, reportType: Int?) {
        if type == 0 {
            if index == 0 {
                let paste = UIPasteboard.general
                paste.string = comment
                HDAlert.showAlertTipWith(type: .onlyText, text: "已复制到剪贴板")
                self.commentView.removeFromSuperview()
             } else if index == 1 {
                print("举报")
                publicViewModel.getErrorContent(commentId: model.commentID)
                
            }else if index == 2 {
                print("删除")
                self.commentView.removeFromSuperview()
                let deleteView:HDZQ_DynamicDeleteView = HDZQ_DynamicDeleteView.createViewFromNib() as! HDZQ_DynamicDeleteView
                deleteView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                deleteView.sureBlock = {
                    //删除评论
                    self.publicViewModel.deleteCommentReply(api_token: HDDeclare.shared.api_token ?? "", comment_id: model.commentID,self)
                }
                
                kWindow?.addSubview(deleteView)
               
            }
        } else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.commentView.removeFromSuperview()
                self.pushToLoginVC(vc: self)
                isNeedRefresh = true

                return
            }
            publicViewModel.reportCommentContent(api_token: HDDeclare.shared.api_token ?? "", option_id_str:String(reportType!) , comment_id: model.commentID,content: self.commentView.dataArr[index])
            self.commentView.removeFromSuperview()
        }
    }
}

extension HDLY_ListenDetail_VC {
    func pushToPlatCenter() {
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDLY_TeachersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDLY_TeachersCenterVC") as! HDLY_TeachersCenterVC
        vc.type = 1
        vc.detailId = infoModel?.teacherID?.int ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HDLY_ListenDetail_VC: UIScrollViewDelegate {
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //LOG("*****:HDLY_ListenDetail_VC:\(scrollView.contentOffset.y)")
        if self.myTableView == scrollView {
            //滚动时刷新webview
            for view in self.myTableView.visibleCells {
                if view.isKind(of: HDLY_CourseWeb_Cell.self) {
                    let cell = view as! HDLY_CourseWeb_Cell
                    cell.webview.setNeedsLayout()
                }
            }
        }
        
        //导航栏
        let offSetY = scrollView.contentOffset.y
        if offSetY >= kTableHeaderViewH1 {
            navBgView.isHidden = false
            navShadowImgV.isHidden = true
            backBtn.setImage(UIImage.init(named: "nav_back"), for: .normal)
            rightBarBtn.setImage(UIImage.init(named: "xz_icon_more_black_default"), for: .normal)
            
        } else {
            navBgView.isHidden = true
            navShadowImgV.isHidden = false
            backBtn.setImage(UIImage.init(named: "nav_back_white"), for: .normal)
            rightBarBtn.setImage(UIImage.init(named: "xz_icon_more_white_default"), for: .normal)
        }
        
    }
}

//MARK: ---- 评论 ----
extension HDLY_ListenDetail_VC : KeyboardTextFieldDelegate {
    
    func setupCommentView() {
        keyboardTextField = HDLY_KeyboardView(point: CGPoint(x: 0, y: 0), width: self.view.bounds.size.width)
        keyboardTextField.delegate = self
        keyboardTextField.isLeftButtonHidden = true
        keyboardTextField.isRightButtonHidden = false
        keyboardTextField.rightButton.setTitle("发表", for: UIControl.State.normal)
        keyboardTextField.rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        keyboardTextField.rightButton.backgroundColor = UIColor.clear
        keyboardTextField.placeholderLabel.text = "发回复"
        keyboardTextField.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth , UIView.AutoresizingMask.flexibleTopMargin]
        self.view.addSubview(keyboardTextField)
        keyboardTextField.toFullyBottom()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.backgroundColor = UIColor.HexColor(0x000000, 0.3)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeKeyBoardView))
        view.addGestureRecognizer(tap)
        keyboardTextField.addAttachmentView(view)
        keyboardTextField.isHidden = true
    }
   
    //显示评论输入框界面
    func showKeyBoardView() {
        keyboardTextField.isHidden = false
        keyboardTextField.show()
    }
    
    //隐藏评论显示
    @objc func closeKeyBoardView() {
        keyboardTextField.hide()
        keyboardTextField.isHidden = true
    }
    
    //MARK: ==== KeyboardTextFieldDelegate ====
    func keyboardTextFieldPressReturnButton(_ keyboardTextField: KeyboardTextField) {
        sendCommentContent(keyboardTextField)
    }
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField :KeyboardTextField) {
        sendCommentContent(keyboardTextField)
    }
    
    func sendCommentContent(_ keyboardTextField: KeyboardTextField) {
        commentText =  keyboardTextField.textView.text
        if commentText == "" {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请输入评论内容")
        }
        if commentText.isEmpty == false && infoModel?.listenID != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                isNeedRefresh = true

                return
            }
            
            if keyboardTextField.type == 0 {
                publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: (infoModel?.listenID?.string)!, return_id: "0", cate_id: "2", self)
            } else {
                publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: (infoModel?.listenID?.string)!, return_id: String(keyboardTextField.returnID!), cate_id: "2", self)
            }
            
        }
    }
    
}


extension HDLY_ListenDetail_VC: UMShareDelegate {
    
    func shareBtnAction() {
        let tipView: HDLY_ShareView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        shareView = tipView
    }
    
    
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard let url  = self.infoModel?.share_url else {
            return
        }
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = self.infoModel?.img
        let shareObject = UMShareWebpageObject.shareObject(withTitle: self.infoModel?.title, descr: self.infoModel?.share_des, thumImage: thumbURL)
        
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

extension HDLY_ListenDetail_VC {
    func doLikeRequest( id: String, cate_id: String,success: @escaping((Data) -> Void), failure: ((Int?, String) ->Void)? )  {
        var token :String = ""
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doLikeRequest(id: id, cate_id: cate_id, api_token: token, deviceno: deviceno), showHud: true, loadingVC: self, success: { (result) in
            success(result)
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
        }) { (errorCode, msg) in
            failure!(errorCode,msg)
        }
    }
}

extension HDLY_ListenDetail_VC : WKNavigationDelegate {
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
                self.skip = 0
                self.requestComments(skip: 0, take: 10)
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
}
