//
//  HDSSL_StrategyDetialVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2019/1/2.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_StrategyDetialVC: HDItemBaseVC {

    var reloadFlag = true
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var commentBgView: UIView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var likeNumL: UILabel!
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    //
//    var infoModel: TopicModelData?
    var commentModels = [TopicCommentList]()
    var topic_id:String?
    var commentText = ""
    var shareView: HDLY_ShareView?
    var currentRow : Int?
    var htmls = [Int:[NSAttributedString]]()
    
    //MVVM
    let viewModel: TopicDetailViewModel = TopicDetailViewModel()
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    let exViewModel: HDSSL_ExDetailVM = HDSSL_ExDetailVM()
    var strategyid:Int?
    var strategyModel: HD_strategyModel?
    
    var loadingView: HDLoadingView?
    lazy var commentView: HDZQ_CommentActionView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_CommentActionView", owner: nil, options: nil)?.last as? HDZQ_CommentActionView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tmp?.delegate = self
        return tmp!
    }()
    
    var webViewH:CGFloat = 0
    var keyboardTextField : KeyboardTextField!
    var focusBtn: UIButton!
    
    override func loadView() {
        super.loadView()
        setupCommentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myTableView.separatorStyle = .none
        commentBgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        textBgView.layer.cornerRadius = 19
        setupBarBtn()
        
        //MVVM
        bindViewModel()
        loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
        loadingView?.frame = self.view.bounds
        view.addSubview(loadingView!)
        refreshAction()//获取详情数据
        requestComments(skip: 0, take: 10)//获取评论
        weak var weakS = self
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithBlock {
            weakS?.refreshAction()
        }
    }
    deinit {
        print("released###############")
    }
    
    //MARK:-获取攻略详情数据
    @objc func refreshAction() {
        if strategyid != nil {
            
            exViewModel.request_getStrategyData(strategyId: strategyid!, vc: self)
            
        }
    }
    //MARK:-获取评论
    @objc func requestComments(skip:Int,take:Int) {
        if strategyid != nil {
            
            viewModel.requestCommentList(cate_id: 5, id: strategyid!, skip: skip, take: take, vc: self)
            
        }
    }
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        exViewModel.strategyData.bind { (model) in
            weakSelf?.showViewData(model)
            
        }
        
        //评论
        viewModel.commentModels.bind { (models) in
            var comments = models
            weakSelf!.htmls.removeAll()
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
                weakSelf?.htmls.updateValue(hms, forKey: i)
                comments[i].height = comments[i].height
            }
            weakSelf?.commentModels = comments
            weakSelf?.myTableView.reloadData()
            
            
        }
        //空数据
        viewModel.showEmptyView.bind() { (show) in
            if show {
                weakSelf?.myTableView.ly_showEmptyView()
            }else {
                weakSelf?.myTableView.ly_hideEmptyView()
            }
        }
        
        //评论
        publicViewModel.commentSuccess.bind { (flag) in
            weakSelf?.keyboardTextField.textView.text = " "
            weakSelf?.keyboardTextField.textView.deleteBackward()
            weakSelf?.closeKeyBoardView()
            //            weakSelf?.refreshAction()
            weakSelf?.requestComments(skip: 0, take: 10)
        }
        //点赞
        publicViewModel.likeModel.bind { (model) in
            weakSelf?.likeNumL.text = model.like_num?.string
            if model.is_like?.int == 0 {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControlState.normal)
            }else {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControlState.normal)
            }
        }
        //收藏
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControlState.normal)
            } else {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControlState.normal)
            }
        }
        //报错
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
                weakSelf?.requestComments(skip: 0, take: 10)
            }
        }
    }
    
    //MARK:-显示数据
    func showViewData(_ model: HD_strategyModel) {
//        guard let model = viewModel.topicDetail.value.data else {
//            return
//        }
        
        self.strategyModel = model
        self.myTableView.reloadData()
        //点赞
        likeNumL.text = strategyModel!.likes!.string
        if ((strategyModel?.isLike) != nil) {
            if strategyModel!.isLike == 0 {
                likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControlState.normal)
            }else {
                likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControlState.normal)
            }
        }
        //收藏
        if ((strategyModel?.isFavorite) != nil) {
            if strategyModel!.isFavorite == 0 {
                collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControlState.normal)
            } else {
                collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControlState.normal)
            }
        }
    }
    //评论
    @IBAction func commentBtnAction(_ sender: UIButton) {
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        keyboardTextField.placeholderLabel.text = "写下你的评论吧"
        keyboardTextField.type = 0
        showKeyBoardView()
    }
    //点赞
    @IBAction func likeBtnAction(_ sender: UIButton) {
        if let idnum = strategyModel?.strategyID {
            
            publicViewModel.doLikeRequest(id: "\(idnum)", cate_id: "10", self)
            
        }
    }
    //收藏
    @IBAction func collectionBtnAction(_ sender: UIButton) {
        if let idnum = strategyModel?.strategyID {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            
            publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: "\(idnum)", cate_id: "9", self)
            
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
}
extension HDSSL_StrategyDetialVC:UITableViewDelegate,UITableViewDataSource {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if  strategyModel?.title != nil {
                let height = strategyModel!.title!.getContentHeight(font: UIFont.init(name: "PingFangSC-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20), width: ScreenWidth-40)
                return height+16
            }
            return 60
        }
        
        if section == 1 {
            guard let cmtNum = strategyModel?.commentList!.count else {
                return 0.01
            }
            if cmtNum > 0{
                return 50
            }
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let titleV:HDLY_ListenComment_Header = HDLY_ListenComment_Header.createViewFromNib() as! HDLY_ListenComment_Header
            titleV.titleL.numberOfLines = 0
            titleV.titleL.text = strategyModel?.title
            titleV.titleL.font = UIFont.init(name: "PingFangSC-Semibold", size: 20)
            titleV.titleL.textColor = UIColor.HexColor(0x333333)
            return titleV
        }
        
        if section == 1 {
            guard let cmtNum = strategyModel?.comments!.int else {
                return nil
            }
            if cmtNum > 0{
                let titleV:HDLY_ListenComment_Header = HDLY_ListenComment_Header.createViewFromNib() as! HDLY_ListenComment_Header
                titleV.titleL.text = "评论 （\(cmtNum)）"
                return titleV
            }
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
        
        if section == 1 {
            return commentModels.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                return webViewH
            }
            else{
                return 120
            }
            
        }
        
        if indexPath.section == 1 {
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
        let model = strategyModel
        let index = indexPath.row
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = model?.url else {
                    return cell!
                }
                if webViewH == 0 {
                  cell?.loadWebView(url)
                }
                cell?.webview.uiDelegate = self
                cell?.webview.navigationDelegate = self
                cell?.webview.frame.size.height = webViewH
                return cell!
            }
            
            if indexPath.row == 1 {
                let cell = HDLY_PlatformFoucsCell.getMyTableCell(tableV: tableView)
                if model?.img != nil {
                    cell?.imgV.kf.setImage(with: URL.init(string: model!.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                    cell?.titleL.text = model?.author
                    if model?.author != nil {
                        cell?.fromL.text = "本文章来自" + model!.author!
                    }
                    //隐藏关注按钮
                    cell?.focusBtn.isHidden = true
//                    cell?.focusBtn.addTarget(self, action: #selector(focusBtnAction), for: UIControlEvents.touchUpInside)
//                    focusBtn = cell?.focusBtn
//                    if model?.is_focus == 1 {
//                        focusBtn.setTitle("已关注", for: .normal)
//                    }else {
//                        focusBtn.setTitle("+关注", for: .normal)
//                    }
                    
                }
                return cell!
            }
            
            
        }
        
        else if indexPath.section ==  1 {
            let cell = HDLY_LeaveMsg_Cell.getMyTableCell(tableV: tableView)
            let commentModel = self.commentModels[index]
            cell?.uid = commentModel.uid
            cell?.commentId = commentModel.commentID
            cell?.avatarBtn.kf.setImage(with: URL.init(string: commentModel.avatar), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.contentL.text = commentModel.comment
            cell?.timeL.text = commentModel.createdAt
            cell?.nameL.text = commentModel.nickname
            cell?.likeBtn.setTitle(commentModel.likeNum.string, for: UIControlState.normal)
            cell?.htmls = self.htmls[indexPath.row]
            cell?.commentContent = commentModel.comment
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
                cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
            }else {
                cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
            }
            
            cell?.likeBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    self?.doLikeRequest(id: String(commentModel.commentID), cate_id: "5", success: { (result) in
                        if self?.commentModels[index].isLike == 0 {
                            self?.commentModels[index].isLike = 1
                            self?.commentModels[index].likeNum.int = (self?.commentModels[index].likeNum.int)! + 1
                            cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
                            cell?.likeBtn.setTitle(self?.commentModels[index].likeNum.string, for: .normal)
                        }else {
                            self?.commentModels[index].isLike = 0
                            self?.commentModels[index].likeNum.int = (self?.commentModels[index].likeNum.int)! - 1
                            cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
                            cell?.likeBtn.setTitle(self?.commentModels[index].likeNum.string, for: .normal)
                        }
                    }, failure: { (error, msg) in })
                }
            })
            
            cell?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    self?.pushToOthersPersonalCenterVC(commentModel.uid)
                }
            })
            
            // 单击回复
            cell?.tapPress = { [weak self] (commentId) in
                self?.currentRow = indexPath.row
                self?.keyboardTextField.textView.text = " "
                self?.keyboardTextField.textView.deleteBackward()
                self?.keyboardTextField.placeholderLabel.text = "回复@\(commentModel.nickname)"
                self?.keyboardTextField.returnID = commentModel.commentID
                self?.keyboardTextField.type = 1
                self?.showKeyBoardView()
                
            }
            // 长按复制与举报
            cell?.longPress  = { [weak self] (commentId,comment) in
                
                //                self?.commentView.dataArr = ["复制","举报"]
                //                self?.commentView.tableHeightConstraint.constant = CGFloat(100)
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
                            if returnModel.uid == HDDeclare.shared.uid {
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
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
extension HDSSL_StrategyDetialVC: HDZQ_CommentActionDelegate {
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
                //删除评论
                publicViewModel.deleteCommentReply(api_token: HDDeclare.shared.api_token ?? "", comment_id: model.commentID,self)
                
            }
        } else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.commentView.removeFromSuperview()
                self.pushToLoginVC(vc: self)
                return
            }
            publicViewModel.reportCommentContent(api_token: HDDeclare.shared.api_token ?? "", option_id_str:String(reportType!) , comment_id: model.commentID,content: self.commentView.dataArr[index])
        }
    }
    
}


//MARK: ---- WebView Delegate ----

extension HDSSL_StrategyDetialVC: WKNavigationDelegate,WKUIDelegate {
    
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
//MARK: ---- 评论 ----
extension HDSSL_StrategyDetialVC : KeyboardTextFieldDelegate {
    
    func setupCommentView() {
        keyboardTextField = HDLY_KeyboardView(point: CGPoint(x: 0, y: 0), width: self.view.bounds.size.width)
        keyboardTextField.delegate = self
        keyboardTextField.isLeftButtonHidden = true
        keyboardTextField.isRightButtonHidden = false
        keyboardTextField.rightButton.setTitle("发布", for: UIControlState.normal)
        keyboardTextField.rightButton.setTitleColor(UIColor.HexColor(0x999999), for: UIControlState.normal)
        keyboardTextField.rightButton.backgroundColor = UIColor.clear
        keyboardTextField.placeholderLabel.text = "发回复"
        keyboardTextField.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleTopMargin]
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
    //发送评论
    func sendCommentContent(_ keyboardTextField: KeyboardTextField) {
        commentText =  keyboardTextField.textView.text
        if commentText.isEmpty == false && strategyModel?.strategyID != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            
            if keyboardTextField.type == 0 {
                //评论
                publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: "\(strategyModel!.strategyID!)", return_id: "0", cate_id: "5", self)
                
            } else {
                //回复评论
                publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: "\(strategyModel!.strategyID!)", return_id: String(keyboardTextField.returnID!), cate_id: "5", self)
                
            }
            
        }
    }
    
    func keyboardTextField(_ keyboardTextField :KeyboardTextField , didChangeText text:String) {
        
    }
    
}
extension HDSSL_StrategyDetialVC {
    
    func setupBarBtn() {
        //
        let rightBarBtn = UIButton.init(type: UIButtonType.custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBarBtn.setImage(UIImage.init(named: "xz_icon_more_black_default"), for: .normal)
        rightBarBtn.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(tapRightBarBtnAction(_:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func tapRightBarBtnAction(_ sender: UIButton) {
        if showFeedbackChooseTip == false {
            let  tipView = HDLY_FeedbackChoose_View.createViewFromNib()
            feedbackChooseTip = tipView as? HDLY_FeedbackChoose_View
            feedbackChooseTip?.frame = CGRect.init(x: ScreenWidth-20-120, y: 10, width: 120, height: 100)
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
            vc.articleID = "\(strategyModel!.strategyID!)"
            vc.typeID = "10"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }
    }
    
}


extension HDSSL_StrategyDetialVC: UMShareDelegate {
    
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
        
        guard let url  = self.strategyModel?.shareURL else {
            return
        }
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = self.strategyModel?.img
        let shareObject = UMShareWebpageObject.shareObject(withTitle: self.strategyModel?.title, descr: self.strategyModel?.share_des, thumImage: thumbURL)
        
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

extension HDSSL_StrategyDetialVC {
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
