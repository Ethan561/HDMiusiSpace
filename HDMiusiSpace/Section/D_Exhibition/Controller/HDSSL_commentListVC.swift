//
//  HDSSL_commentListVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh

class HDSSL_commentListVC: HDItemBaseVC {

    var listType: Int?  //1全部，2有图
    var exhibition_id: Int?
    private var take = 10
    private var skip = 0
    
    @IBOutlet weak var btn_all: UIButton!
    @IBOutlet weak var btn_pic: UIButton!
    @IBOutlet weak var dTableView: UITableView!
    
    var myModel        : ExComListModel? //data所有返回数据
    var allCommentCount: Int? //全部评论
    var picCommentCount: Int? //有图评论
    var currentSection : Int? //当前section
    var tapLikeType    : Int? //1点赞评论，2点赞评论回复
    var commentArray   :[ExCommentModel] = Array.init() //评论数组
    var keyboardTextField  : KeyboardTextField! //评论输入
    var currentCommentModel: ExCommentModel!  //当前回复评论对象
    var currentIndexPath   : IndexPath? //当前位置
    var commentText        : String = ""//评论内容
    var currentRow : Int? //当前手势cell
    
    //mvvm
    var viewModel: HDSSL_commentVM = HDSSL_commentVM()
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
    lazy var commentView: HDZQ_CommentActionView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_CommentActionView", owner: nil, options: nil)?.last as? HDZQ_CommentActionView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tmp?.delegate = self
        return tmp!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
        
        bindViewModel()
        
        setupCommentView()
        
        addRefresh() //刷新
        
        //请求数据
        viewModel.request_getExhibitionCommentList(type: listType!, skip: 0, take: 10, exhibitionID: self.exhibition_id!, vc: self)
    }
    
    func loadMyViews() {
        self.title = "全部评论"
        dTableView.delegate = self
        dTableView.dataSource = self
        
        reloadButtonState()
    }
    func reloadButtonState() {
        if listType == 1 {
            btn_all.backgroundColor = UIColor.HexColor(0xE8C4AE)
            btn_all.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
            btn_pic.backgroundColor = UIColor.lightGray
            btn_pic.setTitleColor(UIColor.black, for: .normal)
        }else{
            btn_pic.backgroundColor = UIColor.HexColor(0xE8C4AE)
            btn_pic.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
            btn_all.backgroundColor = UIColor.lightGray
            btn_all.setTitleColor(UIColor.black, for: .normal)
        }
    }
    //
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.exComListModel.bind { (model) in
            weakSelf?.dealMyDatas(model)
        }
        //评论
        viewModel.commentSuccess.bind { (flag) in
            
            weakSelf?.closeKeyBoardView()
        }
        //点赞
        publicViewModel.likeModel.bind { (model) in
            
            let m : LikeModel = model
            
            if weakSelf?.tapLikeType == 1 {
                var mode = weakSelf?.commentArray[(weakSelf?.currentSection!)!]
                
                mode!.isLike = m.is_like?.int
                mode!.likeNum = m.like_num
                
                weakSelf?.commentArray.remove(at: (weakSelf?.currentSection!)!)
                weakSelf?.commentArray.insert(mode!, at: (weakSelf?.currentSection!)!)
                
                //刷新点赞按钮
                weakSelf?.dTableView.reloadRows(at: [IndexPath.init(row: 0, section: (weakSelf?.currentSection!)!)], with: .automatic)
            }else {
                var mode = weakSelf?.commentArray[(weakSelf?.currentIndexPath?.section)!]
                var reply = mode?.commentList![((weakSelf?.currentIndexPath?.row)! - 1)]
                reply?.isLike = m.is_like?.int
                reply?.likeNum = m.like_num
                
                mode?.commentList?.remove(at: ((weakSelf?.currentIndexPath?.row)! - 1))
                mode?.commentList?.insert(reply!, at: ((weakSelf?.currentIndexPath?.row)! - 1))
                
                weakSelf?.commentArray.remove(at: (weakSelf?.currentIndexPath?.section)!)
                weakSelf?.commentArray.insert(mode!, at: (weakSelf?.currentIndexPath?.section)!)
                
                //刷新点赞按钮
                weakSelf?.dTableView.reloadRows(at: [IndexPath.init(row: ((weakSelf?.currentIndexPath?.row)!), section: (weakSelf?.currentIndexPath?.section)!)], with: .fade)
            }
            
            
        }
        
        //举报
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
        publicViewModel.deleteCommentSuccess.bind { (ret) in
            //
            if ret == true {
                weakSelf?.refreListByNow()
            }
        }
        //删除回复
        publicViewModel.deleteCommentReplySuccess.bind { (ret) in
            //
            if ret == true {
                weakSelf?.refreListByNow()
            }
        }
    }
    //MARK: ---处理数据
    func dealMyDatas(_ model:ExComListModel) -> Void {
        //
        self.myModel = model
        self.allCommentCount = model.total
        self.picCommentCount = model.imgNum
        
        refreshTableView(model)
        
        btn_all.setTitle(String.init(format: "全部(%d)", allCommentCount ?? 0), for: .normal)
        btn_pic.setTitle(String.init(format: "有图(%d)", picCommentCount ?? 0), for: .normal)
     
    }
    //MARK: ---刷新列表
    func refreshTableView(_ model:ExComListModel) {
        if model.list!.count > 0 {
            if skip == 0 {
                self.commentArray.removeAll()
                self.myModel = nil
            }
            self.myModel = model
            self.commentArray += model.list!
            
            self.dTableView.es.stopPullToRefresh()
            self.dTableView.es.stopLoadingMore()
        }else{
            if skip == 0 {
                self.commentArray.removeAll()
                self.myModel = nil
            }
            self.dTableView.es.noticeNoMoreData()
        }
        
        self.calculateCellHeight()
        
        self.dTableView.reloadData()
        
        if self.commentArray.count == 0 {
            self.dTableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.dTableView.ly_showEmptyView()
        }
        
    }
    //MARK: --计算cell高度
    func calculateCellHeight(){
        var arr :[ExCommentModel]? = Array.init()
        
        for var model in self.commentArray {
            let comH = self.getCommentCellHeight(model)
            model.cellHeight = comH
            
            var arr1 :[ReplyCommentModel]? = Array.init()
            if (model.commentList?.count)! > 0 {
                for var reply in model.commentList! {
                    let comH = self.getReplyCommentCellHeight(reply)
                    reply.cellHeight = comH
                    
                    arr1?.append(reply)
                }
                model.commentList?.removeAll()
                model.commentList = arr1!
            }
            arr?.append(model)
        }
        self.commentArray.removeAll()
        self.commentArray = arr!
    }
    //MARK: ---切换列表
    @IBAction func action_tapButton(_ sender: UIButton) {
        print(sender.tag)
        
        skip = 0
        listType = sender.tag//类型
        reloadButtonState()
        //请求数据
        requestData()
    }
    //MARK: ---请求数据
    func requestData() {
        //请求数据
        viewModel.request_getExhibitionCommentList(type: listType!, skip: skip*10, take: take, exhibitionID: self.exhibition_id!, vc: self)
    }
    func refreListByNow(){
        //请求数据
        var skip1 :Int=1
        if skip > 0 {
            skip1 = skip
        }
        skip = 0
        viewModel.request_getExhibitionCommentList(type: listType!, skip: 0, take: skip1*10, exhibitionID: self.exhibition_id!, vc: self)
    }
    //MARK: ---添加刷新机制
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.dTableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.dTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.dTableView.refreshIdentifier = String.init(describing: self)
        self.dTableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        requestData()
    }
    
    private func loadMore() {
        skip += 1
        requestData()
    }
    //MARK: - 发表评论，跳页
    @IBAction func action_writeComment(_ sender: Any) {
        let commentvc = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_commentVC") as! HDSSL_commentVC
        commentvc.exhibition_id = self.exhibition_id
        self.navigationController?.pushViewController(commentvc, animated: true)
    }
    
    
    //MARK: - 显示评论图片大图
    func showCommentBigImgAt(_ cellLoc: Int,_ index: Int) {
        let model = self.commentArray[cellLoc]
        
        if model.imgList != nil {
            let vc = HD_SSL_BigImageVC.init()
            vc.imageArray = model.imgList
            vc.atIndex = index
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HDSSL_commentListVC: HDZQ_CommentActionDelegate {
    func commentActionSelected(type: Int, index: Int, model: TopicCommentList, comment: String, reportType: Int?) {
        //一级弹出框
        if type == 0 {
            if index == 0 {
                let paste = UIPasteboard.general
                paste.string = comment
                HDAlert.showAlertTipWith(type: .onlyText, text: "已复制到剪贴板")
                self.commentView.removeFromSuperview()
            } else  if index == 1{
                print("举报")
                //获取举报类别列表接口
                publicViewModel.getErrorContent(commentId: model.commentID)
                
            }else  if index == 2{
                print("删除")
                //删除自己评论接口
                self.commentView.removeFromSuperview()
                
                let deleteView:HDZQ_DynamicDeleteView = HDZQ_DynamicDeleteView.createViewFromNib() as! HDZQ_DynamicDeleteView
                deleteView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                deleteView.sureBlock = {
                    if model.showAll == true {
                        //借用showAll字断，true表示删除评论，false表示删除回复
                        self.publicViewModel.deleteComment(api_token: HDDeclare.shared.api_token ?? "", comment_id: model.commentID,self)
                    }else{
                        self.publicViewModel.deleteCommentReply(api_token: HDDeclare.shared.api_token ?? "", comment_id: model.commentID,self)
                    }   
                }
                kWindow?.addSubview(deleteView)
            }
        } else {
            //二级弹出列表
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.commentView.removeFromSuperview()
                self.pushToLoginVC(vc: self)
                return
            }
            self.commentView.removeFromSuperview()
            //调用举报接口
            publicViewModel.reportCommentContent(api_token: HDDeclare.shared.api_token ?? "", option_id_str:String(reportType!) , comment_id: model.commentID,content: self.commentView.dataArr[index])
        }
    }
    
    
}
extension HDSSL_commentListVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let model: ExCommentModel = self.commentArray[section]
        
        return (model.commentList?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.commentArray[indexPath.section]
        
        if indexPath.row == 0 {
            //评论
            return model.cellHeight!
        }
        else {
            //评论回复
            let replymodel = model.commentList![indexPath.row-1]
            return replymodel.cellHeight!
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.commentArray[indexPath.section]
        
        weak var weakSelf = self
        
        if indexPath.row == 0 {
            
            var cell = HDSSL_dCommentCell.getMyTableCell(tableV: tableView) as HDSSL_dCommentCell

            while (cell.contentView.subviews.last != nil) {
                cell.contentView.subviews.last!.removeFromSuperview()  //删除并进行重新分配
            }
            cell = HDSSL_dCommentCell.getMyTableCell(tableV: tableView) as HDSSL_dCommentCell
            
            cell.tag = indexPath.section
            cell.selectionStyle = .none
            cell.listModel = model
            cell.BlockTapImgItemFunc { (index,cellIndex) in
                print("点击第\(index)张图片，第\(cellIndex)个cell")
                weakSelf?.showCommentBigImgAt(cellIndex, index)
            }
            cell.BlockTapLikeFunc { (index) in
                print("点击喜欢按钮，位置\(index)")
                weakSelf?.likeTheComment(index)
            }
            cell.BlockTapCommentFunc { (index) in
                print("点击评论按钮，位置\(index)")
//                weakSelf?.replayTheComment(index)
                weakSelf?.currentRow = indexPath.section
                weakSelf?.keyboardTextField.textView.text = " "
                weakSelf?.keyboardTextField.textView.deleteBackward()
                weakSelf?.keyboardTextField.placeholderLabel.text = "回复@\(model.nickname!)"
                weakSelf?.keyboardTextField.returnID = 0
                weakSelf?.keyboardTextField.type = 1
                weakSelf?.showKeyBoardView()
            }
            //点击头像，进入个人中心
            cell.cell_portrialBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    self?.pushToOthersPersonalCenterVC(model.uid)
                }
            })
            // 单击回复
            cell.tapPress = { [weak self] (commentId) in
                self?.currentRow = indexPath.section
                self?.keyboardTextField.textView.text = " "
                self?.keyboardTextField.textView.deleteBackward()
                self?.keyboardTextField.placeholderLabel.text = "回复@\(model.nickname!)"
                self?.keyboardTextField.returnID = 0
                self?.keyboardTextField.type = 1
                self?.showKeyBoardView()
//                self?.replayTheComment(indexPath.row)
            }
            // 长按复制与举报
            cell.longPress  = { [weak self] (commentId,comment) in
                self?.commentView.type = 0
                //模型转换
                let model1 = TopicCommentList.init(uid: model.uid, comment: model.content!, likeNum: model.likeNum!, createdAt: model.commentDate!, commentID: model.commentID!, avatar: model.avatar!, nickname: model.nickname!, isLike: model.isLike!, list: [], showAll: true, height: 44, topHeight: 64)
                self?.commentView.model = model1
                
                self?.commentView.commentContent = comment
                if model.uid == HDDeclare.shared.uid {
                    self?.commentView.dataArr = ["复制","举报","删除"]
                }else{
                    self?.commentView.dataArr = ["复制","举报"]
                }
                
                self?.commentView.tableHeightConstraint.constant = CGFloat((self?.commentView.dataArr.count)!*50)
                self?.commentView.tableView.reloadData()
                kWindow?.addSubview((self?.commentView)!)
            }

            return cell
        } else {
            let modelreply = model.commentList![indexPath.row-1]
            
            var cell = HDSSL_commentReplyCell.getMyTableCell(tableV: tableView) as HDSSL_commentReplyCell
            while (cell.contentView.subviews.last != nil) {
                cell.contentView.subviews.last!.removeFromSuperview()  //删除并进行重新分配
            }
            cell = HDSSL_commentReplyCell.getMyTableCell(tableV: tableView) as HDSSL_commentReplyCell
            
            cell.indexpath = indexPath
            cell.myModel = modelreply
            cell.BlockTapLikeButtonFunc { (model,indexpath) in
                //点赞回复，调用接口
                weakSelf?.likeTheReplyComment(indexpath,model)
            }
            //点击头像，进入个人中心
            cell.cell_portrialBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    self?.pushToOthersPersonalCenterVC(modelreply.uid)
                }
            })
            // 单击回复
            cell.tapPress = { [weak self] (commentId) in
                self?.currentRow = indexPath.section
                self?.keyboardTextField.textView.text = " "
                self?.keyboardTextField.textView.deleteBackward()
                self?.keyboardTextField.placeholderLabel.text = "回复@\(modelreply.nickname!)"
                self?.keyboardTextField.returnID = modelreply.returnId
                self?.keyboardTextField.type = 1
                self?.showKeyBoardView()
//                self?.replayTheComment(indexPath.row)
            }
            // 长按复制与举报
            cell.longPress  = { [weak self] (commentId,comment) in
                self?.commentView.type = 0
                //模型转换
                let model1 = TopicCommentList.init(uid: modelreply.uid, comment: modelreply.content!, likeNum: modelreply.likeNum!, createdAt: modelreply.commentDate!, commentID: modelreply.returnId!, avatar: modelreply.avatar!, nickname: modelreply.nickname!, isLike: modelreply.isLike!, list: [], showAll: false, height: 44, topHeight: 64)
                self?.commentView.model = model1
                
                self?.commentView.commentContent = comment
                if modelreply.uid == HDDeclare.shared.uid {
                    //自己的回复可以进行删除操作
                    self?.commentView.dataArr = ["复制","举报","删除"]
                }else{
                    self?.commentView.dataArr = ["复制","举报"]
                }
                
                self?.commentView.tableHeightConstraint.constant = CGFloat((self?.commentView.dataArr.count)!*50)
                self?.commentView.tableView.reloadData()
                kWindow?.addSubview((self?.commentView)!)
            }
            return cell
        }
        
        
    }
    
    //MARK: --- 进入个人中心
    func goToUserCenter(_ model:ExCommentModel){
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
        } else {
            self.pushToOthersPersonalCenterVC(model.uid)
        }
    }
    //MARK: ---评论这个评论
    func replayTheComment(_ index:Int) -> Void {
        //
        currentCommentModel = self.commentArray[index]
        
        self.showKeyBoardView()
    }
    //MARK: ---点赞这个评论
    func likeTheComment(_ index:Int) -> Void {
        currentCommentModel = self.commentArray[index]
        
        currentSection = index
        tapLikeType = 1
        
        if currentCommentModel.commentID != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            //API--点赞
            publicViewModel.doLikeRequest(id: String.init(format: "%d", currentCommentModel.commentID!), cate_id: "6", self)
        }
        
    }
    //MARK: ---点赞这个评论回复
    func likeTheReplyComment(_ indexp: IndexPath,_ m: ReplyCommentModel) {
        //
        tapLikeType = 2
        currentIndexPath = indexp
        
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        //API--点赞
        publicViewModel.doLikeRequest(id: String.init(format: "%d", m.returnId!), cate_id: "5", self)
        
        
    }

    //MARK: ---获取评论cell的高度
    func getCommentCellHeight(_ model: ExCommentModel) -> CGFloat {
        let content = String.init(format: "%@", model.content!)
        
        let kkSpace: CGFloat = 10.0
        let kkWidth: CGFloat = CGFloat((UIScreen.main.bounds.width-55-20)/3.0)
        
        //头像、间距等高度
        let otherH = 48.0 + 30.0
        //文本
        let size = content.getLabSize(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth - 55)
        //图片
        var imgH: CGFloat? = 0.0
        if (model.imgList?.count)! > 0 {
            imgH = (kkSpace + kkWidth) * CGFloat(((model.imgList?.count)!-1)/3+1)
        }else {
            imgH = 20.0
        }
        
        return imgH! + size.height + CGFloat(otherH)
    }
    //MARK: ---获取评论回复cell高度
    func getReplyCommentCellHeight(_ model: ReplyCommentModel) -> CGFloat {
        let content = String.init(format: "%@", model.content!)
        
        //头像、间距等高度
        let otherH = 48.0 + 30.0
        //文本
        let size = content.getLabSize(font: UIFont.systemFont(ofSize: 11), width: ScreenWidth - 120)
        return size.height + CGFloat(otherH)
    }
}
//MARK: ---- 评论 ----
extension HDSSL_commentListVC : KeyboardTextFieldDelegate {
    //MARK: ---初始化评论视图
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
        keyboardTextField.textView.text = ""
        keyboardTextField.hide()
        keyboardTextField.isHidden = true
    }
    
    //MARK: ==== KeyboardTextFieldDelegate ====
    func keyboardTextFieldPressReturnButton(_ keyboardTextField: KeyboardTextField) {
        //回复文本
        self.replyCommentWith(keyboardTextField)
    }
    
    func keyboardTextFieldPressRightButton(_ keyboardTextField :KeyboardTextField) {
        //回复文本
        self.replyCommentWith(keyboardTextField)
        
    }
    //MARK: ---判断是否登陆
    func replyCommentWith(_ keyboardTextField: KeyboardTextField){
        commentText =  keyboardTextField.textView.text
        
        if commentText == "" {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请输入评论内容")
        }
        currentCommentModel = self.commentArray[currentRow!]
        
        if commentText.isEmpty == false && currentCommentModel.commentID != nil {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            if keyboardTextField.type == 0 {
                
            }else if keyboardTextField.type == 1{
                if keyboardTextField.returnID == 0 {
                    //API,发布评论回复
                    viewModel.request_replycommentWith(api_token: HDDeclare.shared.api_token!, comment: commentText, id: String.init(format: "%d", currentCommentModel.commentID!), return_id: "0", cate_id: "3", self)
                }else{
                    //发布回复的评论，盖楼
                    viewModel.request_replycommentWith(api_token: HDDeclare.shared.api_token!, comment: commentText, id: String.init(format: "%d", currentCommentModel.commentID!), return_id: String(keyboardTextField.returnID!), cate_id: "3", self)
                    
                }
            }
            
            
        }
    }
    
    func keyboardTextField(_ keyboardTextField :KeyboardTextField , didChangeText text:String) {
        
    }
    
}
