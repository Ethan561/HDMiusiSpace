//
//  HDLY_TopicDetail_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_TopicDetail_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate {
    
    var fromRootAChoiceness = false
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
    var infoModel: TopicModelData?
    var topic_id:String?
    var commentText = ""
    
    //MVVM
    let viewModel: TopicDetailViewModel = TopicDetailViewModel()
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
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
        refreshAction()
        
        self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))

    }
    
    @objc func refreshAction() {
        
        if topic_id != nil {
            if fromRootAChoiceness == true {
                viewModel.dataRequestWithArticleID(article_id: topic_id!, self)
            }else {
                viewModel.dataRequestWithTopicID(listenID: topic_id!, self)
            }
        }
    }
    
    //MVVM
    
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.topicDetail.bind { (_) in
            weakSelf?.showViewData()
        }
        
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
        }
        //
        publicViewModel.likeModel.bind { (model) in
            weakSelf?.likeNumL.text = model.like_num?.string
            if model.is_like?.int == 0 {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControlState.normal)
            }else {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControlState.normal)
            }
        }
        
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControlState.normal)
            } else {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControlState.normal)
            }
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

        
    }
    
    func showViewData() {
        guard var model = viewModel.topicDetail.value.data else {
            return
        }
        
        // 计算总高度 保存到模型中去
        for i in 0..<model.commentList.count {
             for j in 0..<model.commentList[i].list.count {
                let str = "\(model.commentList[i].list[j].uNickname)：\(model.commentList[i].list[j].comment)"
                let textH = str.getContentHeight(font: UIFont.systemFont(ofSize: 12), width: ScreenWidth - 80)
                model.commentList[i].list[j].height = Int(textH > 20 ? textH + 5 : 20)
                model.commentList[i].height = model.commentList[i].height + model.commentList[i].list[j].height
                
                if j == 0 {
                    model.commentList[i].topHeight = model.commentList[i].list[j].height
                }
                if j == 1 {
                    model.commentList[i].topHeight = model.commentList[i].topHeight + model.commentList[i].list[j].height
                }
            }
            model.commentList[i].height = model.commentList[i].height
        }
        
        self.infoModel = model
        
        self.getWebHeight()
        //点赞
        likeNumL.text = infoModel!.likes.string
        if ((infoModel?.isLike) != nil) {
            if infoModel!.isLike == 0 {
                likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControlState.normal)
            }else {
                likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControlState.normal)
            }
        }
        //收藏
        if ((infoModel?.isFavorite) != nil) {
            if infoModel!.isFavorite == 0 {
                collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControlState.normal)
            } else {
                collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControlState.normal)
            }
        }
    }
        
    @IBAction func commentBtnAction(_ sender: UIButton) {
        keyboardTextField.placeholderLabel.text = "写下你的评论吧"
        keyboardTextField.type = 0
        showKeyBoardView()
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.articleID.string {
            if fromRootAChoiceness == true {
                publicViewModel.doLikeRequest(id: idnum, cate_id: "2", self)
            }else {
                publicViewModel.doLikeRequest(id: idnum, cate_id: "9", self)
            }
        }
    }
    
    @IBAction func collectionBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.articleID.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            if fromRootAChoiceness == true {
                publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "2", self)
            }else {
                publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "6", self)
            }
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

extension HDLY_TopicDetail_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if  infoModel?.title != nil {
                let height = infoModel!.title.getContentHeight(font: UIFont.init(name: "PingFangSC-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20), width: ScreenWidth-40)
                return height+16
            }
            return 60
        }
        if section == 1 {
            if infoModel?.recommendsList != nil {
                if infoModel!.recommendsList.count > 0 {
                    return 50
                }else {
                    return 0.01
                }
            }
        }
        if section == 2 {
            guard let cmtNum = infoModel?.commentList.count else {
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
            titleV.titleL.text = infoModel?.title
            titleV.titleL.font = UIFont.init(name: "PingFangSC-Semibold", size: 20)
            titleV.titleL.textColor = UIColor.HexColor(0x333333)
            return titleV
        }
        if section == 1 {
            if infoModel?.recommendsList != nil {
                if infoModel!.recommendsList.count > 0 {
                    let titleV:HDLY_ListenComment_Header = HDLY_ListenComment_Header.createViewFromNib() as! HDLY_ListenComment_Header
                    titleV.titleL.text = "延展阅读"
                    return titleV
                }else {
                    return nil
                }
            }
        }
        if section == 2 {
            guard let cmtNum = infoModel?.commentList.count else {
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
            if  let recommendsList = infoModel?.recommendsList {
                return recommendsList.count
            }
            return 0
        }
        if section == 2 {
            if  let commentList = infoModel?.commentList {
                return commentList.count
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if infoModel?.platform_icon != nil {
                    return 80
                }
                return 0.01
            }
            return webViewH
        }
        if indexPath.section == 1 {
            if infoModel?.recommendsList != nil {
                if infoModel!.recommendsList.count > 0 {
                    return 100
                }else {
                    return 0.01
                }
            }
            return 0.01
        }
        if indexPath.section == 2 {
            if infoModel?.commentList != nil {
                guard let commentModel = infoModel?.commentList[index] else {
                    return  0.01
                }
                let textH = commentModel.comment.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-85)
                var subCommentsH = 0
                
                if commentModel.list.count < 3 {
                    subCommentsH = commentModel.height + 30
                } else {
                    if commentModel.showAll {
                        subCommentsH = commentModel.height + 20
                    } else {
                      subCommentsH = commentModel.topHeight + 40
//                        subCommentsH = 90
                    }
                }
                return textH + 90 + CGFloat(subCommentsH)
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = infoModel
        let index = indexPath.row
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = HDLY_PlatformCell.getMyTableCell(tableV: tableView)
                if model?.platform_icon != nil {
                    cell?.imgV.kf.setImage(with: URL.init(string: model!.platform_icon!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                    cell?.titleL.text = model?.platform_title
                    cell?.timeL.text = model?.created_at
                }
                return cell!
            }
            let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
            guard let url = model?.url else {
                return cell!
            }
            cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
            return cell!
        }
        else if indexPath.section ==  1 {
            let cell = HDLY_TopicRecmd_Cell.getMyTableCell(tableV: tableView)
            if model?.recommendsList != nil {
                let model = model!.recommendsList[index]
                cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.titleL.text = model.title
                cell?.desL.text = "\(model.keywords)|\(model.plat_title)"
                cell?.commentBtn.setTitle(model.comments.string, for: .normal)
                cell?.likeBtn.setTitle(model.likes.string, for: .normal)
            }
            return cell!
        }
        else if indexPath.section ==  2 {
            let cell = HDLY_LeaveMsg_Cell.getMyTableCell(tableV: tableView)
            if model?.commentList != nil {
                guard let commentModel = model?.commentList[index] else {
                    return  cell!
                }
                cell?.commentId = commentModel.commentID
                cell?.avatarBtn.kf.setImage(with: URL.init(string: commentModel.avatar), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.contentL.text = commentModel.comment
                cell?.timeL.text = commentModel.createdAt
                cell?.nameL.text = commentModel.nickname
                cell?.likeBtn.setTitle(commentModel.likeNum.string, for: UIControlState.normal)
                if commentModel.list.count > 0 {
                    cell?.subContainerView.isHidden = false
                    cell?.setupSubContainerView(subModel: commentModel, showAll: commentModel.showAll)
                    cell?.showMoreBtn.addTouchUpInSideBtnAction({ (btn) in
                        self.infoModel?.commentList[index].showAll = true
                        self.myTableView.reloadRows(at: [indexPath], with: .none)
                    })
                } else {
                    cell?.subContainerView.isHidden = true
                }
                if commentModel.isLike == 0 {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
                }else {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
                }
                
                cell?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                    self?.pushToOthersPersonalCenterVC(commentModel.uid)
                })
                
                cell?.longPress  = { [weak self] (commentId) in
                    self?.commentView.type = 0
                    self?.commentView.model = commentModel
                    self?.commentView.dataArr = ["回复","复制","举报"]
                    self?.commentView.tableHeightConstraint.constant = CGFloat(150)
                    self?.commentView.tableView.reloadData()
                    self?.navigationController?.view.addSubview((self?.commentView)!)
                }
            }
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            let model = infoModel!.recommendsList[indexPath.row]
            vc.topic_id = "\(model.articleID)"
            vc.fromRootAChoiceness = self.fromRootAChoiceness
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDLY_TopicDetail_VC: HDZQ_CommentActionDelegate {
    func commentActionSelected(type: Int, index: Int, model: TopicCommentList, reportType: Int?) {
        if type == 0 {
            if index == 0 {
                print(model.nickname)
                keyboardTextField.textView.text = " "
                keyboardTextField.textView.deleteBackward()
                keyboardTextField.placeholderLabel.text = "回复@\(model.nickname)"
                keyboardTextField.returnID = model.commentID
                keyboardTextField.type = 1
                showKeyBoardView()
                self.commentView.removeFromSuperview()
            } else if index == 1 {
                let paste = UIPasteboard.general
                paste.string = model.comment
                HDAlert.showAlertTipWith(type: .onlyText, text: "已复制到剪贴板")
                self.commentView.removeFromSuperview()
            } else  {
                print("举报")
                publicViewModel.getErrorContent(commentId: model.commentID)
                
            }
        } else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            publicViewModel.reportCommentContent(api_token: HDDeclare.shared.api_token ?? "", option_id_str:String(reportType!) , comment_id: model.commentID)
        }
    }
}


//MARK: ---- WebView Delegate ----

extension HDLY_TopicDetail_VC: UIWebViewDelegate {

    func getWebHeight() {
        guard let url = self.infoModel?.url else {
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
        self.myTableView.reloadData()
    }
    
}

//MARK: ---- 评论 ----
extension HDLY_TopicDetail_VC : KeyboardTextFieldDelegate {
    
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
    
    func sendCommentContent(_ keyboardTextField: KeyboardTextField) {
        commentText =  keyboardTextField.textView.text
        if commentText.isEmpty == false && infoModel?.articleID != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            
            if keyboardTextField.type == 0 {
                if fromRootAChoiceness == true {
                    publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: infoModel!.articleID.string, return_id: "0", cate_id: "1", self)
                    
                }else {
                    publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: infoModel!.articleID.string, return_id: "0", cate_id: "4", self)
                }
            } else {   
                if fromRootAChoiceness == true {
                    publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: infoModel!.articleID.string, return_id: String(keyboardTextField.returnID!), cate_id: "1", self)
                    
                }else {
                    publicViewModel.commentCommitRequest(api_token: HDDeclare.shared.api_token!, comment: commentText, id: infoModel!.articleID.string, return_id: String(keyboardTextField.returnID!), cate_id: "4", self)
                }
            }

        }
    }
    
    func keyboardTextField(_ keyboardTextField :KeyboardTextField , didChangeText text:String) {
        
    }
    
}

extension HDLY_TopicDetail_VC {
    
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
            
        }else {
            //报错
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
            vc.articleID = infoModel?.articleID.string
            vc.typeID = "4"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }
    }
    
}

