//
//  HDLY_ListenDetail_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_ListenDetail_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate{
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    var reloadFlag = true
    @IBOutlet weak var commentBgView: UIView!
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var likeNumL: UILabel!
    //
    var player = HDLY_AudioPlayer.shared
    var webView = WKWebView()
    var webViewH:CGFloat = 0
    var infoModel: ListenDetail?
    var listen_id:String?
    var playerBtn: UIButton!
    var timeL: UILabel!
    var commentText = ""
    //MVVM
    let viewModel: ListenDetailViewModel = ListenDetailViewModel()
    
    lazy var testWebV: WKWebView = {
        let webV = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.navigationDelegate = self
        return webV
    }()
    
    var keyboardTextField : KeyboardTextField!
    var focusBtn: UIButton!
    
    override func loadView() {
        super.loadView()
        setupCommentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarHCons.constant = kStatusBarHeight+24
        self.hd_navigationBarHidden = true
        myTableView.separatorStyle = .none
        player.delegate = self
        
        commentBgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        textBgView.layer.cornerRadius = 19
        
        //MVVM
        bindViewModel()
        if listen_id != nil {
            viewModel.dataRequestWithListenID(listenID: listen_id!, self)
        }
    }

    //MVVM
    
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.listenDetail.bind { (_) in
            weakSelf?.showViewData()
        }
        //评论
        viewModel.commentSuccess.bind { (flag) in
            weakSelf?.closeKeyBoardView()
        }
        //
        viewModel.likeModel.bind { (model) in
            weakSelf?.likeNumL.text = model.like_num?.string
            if model.is_like?.int == 0 {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_default"), for: UIControlState.normal)
            }else {
                weakSelf?.likeBtn.setImage(UIImage.init(named: "icon_like_pressed"), for: UIControlState.normal)
            }
        }
        
        viewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_gray"), for: UIControlState.normal)
            } else {
                weakSelf?.collectionBtn.setImage(UIImage.init(named: "xz_star_red"), for: UIControlState.normal)
            }
        }
        viewModel.isFocus.bind { (flag) in
            weakSelf?.showFocusView(flag)
        }
    }
    
    func showViewData() {
        self.infoModel = viewModel.listenDetail.value
        if infoModel?.img != nil {
            self.imgV.kf.setImage(with: URL.init(string: infoModel!.img!), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.getWebHeight()
        //点赞
        likeNumL.text = infoModel?.likes?.string
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
    
    func showFocusView(_ isFocus: Bool) {
        if isFocus {
            infoModel?.isFocus = 1
            focusBtn.setTitle("已关注", for: .normal)
        }else {
            infoModel?.isFocus = 0
            focusBtn.setTitle("+关注", for: .normal)
        }
    }
    
    func getWebHeight() {
        guard let url = self.infoModel?.url else {
            return
        }
        self.testWebV.load(URLRequest.init(url: URL.init(string: url)!))
        self.myTableView.reloadData()
    }
    

    
    @IBAction func commentBtnAction(_ sender: UIButton) {
        showKeyBoardView()
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.listenID?.string {
            viewModel.doLikeRequest(api_token: TestToken, deviceno: "", id: idnum, cate_id: "4", self)
        }
    }
    
    @IBAction func collectionBtnAction(_ sender: UIButton) {
        if let idnum = infoModel?.listenID?.string {
            viewModel.doFavoriteRequest(api_token: TestToken, id: idnum, cate_id: "4", self)
        }
    }
    
    @objc func focusBtnAction()  {
        if let idnum = infoModel?.teacherID?.string {
            viewModel.doFocusRequest(api_token: TestToken, id: idnum, cate_id: "2", self)
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

extension HDLY_ListenDetail_VC : HDLY_AudioPlayer_Delegate {
    
    @objc  func playOrPauseAction(_ sender: UIButton) {
        if self.infoModel?.voice != nil && (self.infoModel?.voice?.contains(".mp3"))! {
            //
            if player.state == .playing {
                player.pause()
                playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControlState.normal)
            } else {
                if player.state == .paused {
                    player.play()
                }else {
                    player.play(file: Music.init(name: "", url:URL.init(string: self.infoModel!.voice!)!))
                }
                playerBtn.setImage(UIImage.init(named: "icon_pause_white"), for: UIControlState.normal)
            }
        }
    }
    
    // === HDLY_AudioPlayer_Delegate ===
    
    func finishPlaying() {
        playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControlState.normal)
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
        timeL.text = "\(currentTime)/\(totalTime)"
//      LOG(" progress: \(progress)")
    }
    
}

extension HDLY_ListenDetail_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let cmtNum = infoModel?.comments else {
            return 0.01
        }
        if cmtNum > 0 && section == 1{
            return 50
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cmtNum = infoModel?.comments else {
            return nil
        }
        if cmtNum > 0 && section == 1{
            let titleV:HDLY_ListenComment_Header = HDLY_ListenComment_Header.createViewFromNib() as! HDLY_ListenComment_Header
            titleV.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50)
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
            if  let commentList = infoModel?.commentList {
                return commentList.count
            }
            return 0
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if index == 0 {
                return 182*ScreenWidth/375.0
            }
            else if index == 1 {
                return 95
            }
            else if index == 2 {
                return webViewH
            }
        }else {
            if infoModel?.commentList != nil {
                guard let commentModel = infoModel?.commentList![index] else {
                    return  0.01
                }
                if let text = commentModel.comment {
                    let textH = text.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-85)
                    return textH + 90
                }
            }
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
                    cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.teacherImg!)!), placeholder: UIImage.init(named: "teacher_img"), options: nil, progressBlock: nil, completionHandler: nil)
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
                let cell = HDLY_ListenPlayer_Cell.getMyTableCell(tableV: tableView)
                playerBtn = cell?.playerBtn
                timeL = cell?.timeL
                //
                playerBtn.addTarget(self, action: #selector(playOrPauseAction(_:)), for: UIControlEvents.touchUpInside)
                if player.state == .playing {
                    playerBtn.setImage(UIImage.init(named: "icon_pause_white"), for: UIControlState.normal)
                } else {
                    playerBtn.setImage(UIImage.init(named: "icon_paly_white"), for: UIControlState.normal)
                }
                return cell!
            }
            else if index == 2 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                self.webView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height:CGFloat(webViewH))
                cell?.addSubview(webView)
                guard let url = self.infoModel?.url else {
                    return cell!
                }
                if reloadFlag == true {
                    self.webView.load(URLRequest.init(url: URL.init(string: url)!))
                }
                
                return cell!
            }
        } else {
            let cell = HDLY_LeaveMsg_Cell.getMyTableCell(tableV: tableView)
            if model?.commentList != nil {
                guard let commentModel = model?.commentList![index] else {
                    return  cell!
                }
                if commentModel.avatar != nil {
                    cell?.avaImgV.kf.setImage(with: URL.init(string: commentModel.avatar!), placeholder: UIImage.init(named: "user_img2"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell?.contentL.text = commentModel.comment
                cell?.timeL.text = commentModel.createdAt
                cell?.likeBtn.setTitle(commentModel.likeNum?.string, for: UIControlState.normal)
                if commentModel.isLike == 0 {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
                }else {
                    cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
                }
            }
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}

//MARK: ---- WKNavigationDelegate ----

extension HDLY_ListenDetail_VC {
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("_____完成加载_____")
        //禁止长按手势操作
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        //js方法获取高度
        webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)") { (result, error) in
            let height = result
            self.webViewH = CGFloat(height as! Float)
            self.myTableView.reloadData()
            if self.webViewH > 10 {
                self.reloadFlag = false
            }
        }
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
    }
    
}

//MARK: ---- 评论 ----
extension HDLY_ListenDetail_VC : KeyboardTextFieldDelegate {
    
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
        keyboardTextField.textView.text = ""
        keyboardTextField.hide()
        keyboardTextField.isHidden = true
    }
    
    //MARK: ==== KeyboardTextFieldDelegate ====
    func keyboardTextFieldPressReturnButton(_ keyboardTextField: KeyboardTextField) {
       commentText =  keyboardTextField.textView.text
        if commentText.isEmpty == false && infoModel?.listenID != nil {
            viewModel.commentCommitRequest(api_token: TestToken, comment: commentText, id: "\(infoModel!.listenID!)", return_id: "0", cate_id: "2", self)
        }
    }
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField :KeyboardTextField) {
        commentText =  keyboardTextField.textView.text
        if commentText.isEmpty == false && infoModel?.listenID != nil {
            viewModel.commentCommitRequest(api_token: TestToken, comment: commentText, id: "\(infoModel!.listenID!)", return_id: "0", cate_id: "2", self)
        }
    }
    
    func keyboardTextField(_ keyboardTextField :KeyboardTextField , didChangeText text:String) {

    }
    
}








