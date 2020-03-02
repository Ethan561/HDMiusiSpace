//
//  HDRootEVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDRootEVC: HDItemBaseVC {
    @IBOutlet weak var dynamicLabel: UILabel!
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!    
    @IBOutlet weak var myTableView: UITableView!
    private var user = UserDynamic()
    private var myDynamics = [MyDynamic]()
    private var courses =  [MyCollectCourseModel]()
    let declare:HDDeclare = HDDeclare.shared
    
    var tabHeader = HDLY_MineHome_Header()
    var iconTitleStrings = [NSAttributedString]()
    var starTitleStrings = [NSAttributedString]()
    
    private var take = 10
    private var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        
        dynamicLabel.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(LoginSuccess(noti:)), name: NSNotification.Name.init(rawValue: "LoginSuccess"), object: nil)
        navbarCons.constant = kTopHeight
        myTableView.estimatedRowHeight = 0
        myTableView.estimatedSectionHeaderHeight = 0
        myTableView.estimatedSectionFooterHeight = 0
        setupViews()
        addRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if declare.loginStatus == .kLogin_Status_Login {
            skip = 0
            getMyDynamicList()
            getUserInfo()
            getMyStudyCourses()
        } else {
            //未登录
            self.myTableView.es.removeRefreshFooter()
            self.myTableView.es.removeRefreshHeader()
            dynamicLabel.isHidden = true
            tabHeader.userInfoView.isHidden  = true
            tabHeader.loginView.isHidden = false
            tabHeader.avatarImgV.image = UIImage.init(named: "wd_img_tx")
            tabHeader.followNumberLabel.text = "0"
            tabHeader.collectNumberLabel.text = "0"
            tabHeader.cardNumberLabel.text = "0"
            tabHeader.foorprintNumberLabel.text = "0"
            tabHeader.foorprintNumberLabel.removeBadge()
            msgBtn.removeBadge()
            self.user = UserDynamic()
            self.myDynamics.removeAll()
            self.courses.removeAll()
            self.myTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HDFloatingButtonManager.manager.showFloatingBtn = true
        if  HDFloatingButtonManager.manager.state == .paused {
//            HDFloatingButtonManager.manager.floatingBtnView.showType = .FloatingButtonPause
            HDFloatingButtonManager.manager.floatingBtnView.show = true
        }
    }
    
    @objc func LoginSuccess(noti:Notification) {
        skip = 0
        addRefresh()
        refresh()
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tabHeader = HDLY_MineHome_Header.createViewFromNib() as! HDLY_MineHome_Header
        tabHeader.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 180)
        tabHeader.delegate = self
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 180))
        v.addSubview(tabHeader)
        myTableView.tableHeaderView = v
        tabHeader.headerBtn.addTarget(self, action: #selector(showUserInfoAction), for: UIControl.Event.touchUpInside)
        
        myTableView.separatorStyle = .none
        myTableView.backgroundColor = UIColor.white
        
    }

    func refreshUserInfo() {
        if declare.loginStatus == .kLogin_Status_Login {
            let indexPath = IndexPath(row: 3, section: 0)
            self.myTableView.reloadRows(at: [indexPath], with: .none)
            //已登录
            tabHeader.userInfoView.isHidden  = false
            tabHeader.loginView.isHidden = true
            tabHeader.nameL.text = user.nickname
            tabHeader.signatureL.text = user.profile
            if declare.avatar != nil {
                tabHeader.avatarImgV.kf.setImage(with: URL.init(string: user.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            tabHeader.followNumberLabel.text = "\(user.focus_num)"
            tabHeader.collectNumberLabel.text = "\(user.favorite_num)"
            tabHeader.cardNumberLabel.text = "\(user.daycard_num)"
            tabHeader.foorprintNumberLabel.text = "\(user.footprint_num)"
            if user.is_new_msg != 0 {
                msgBtn.showBadge()
            } else {
                msgBtn.removeBadge()
            }
            if user.is_new_footprint != 0 {
                tabHeader.foorprintNumberLabel.showBadge()
            } else {
                tabHeader.foorprintNumberLabel.removeBadge()
            }
            
        } else {
//            //未登录
            self.myTableView.es.removeRefreshFooter()
            self.myTableView.es.removeRefreshHeader()
            dynamicLabel.isHidden = true
            tabHeader.userInfoView.isHidden  = true
            tabHeader.loginView.isHidden = false
            tabHeader.avatarImgV.image = UIImage.init(named: "wd_img_tx")
            tabHeader.followNumberLabel.text = "0"
            tabHeader.collectNumberLabel.text = "0"
            tabHeader.cardNumberLabel.text = "0"
            tabHeader.foorprintNumberLabel.text = "0"
            msgBtn.removeBadge()
            tabHeader.foorprintNumberLabel.removeBadge()
            self.user = UserDynamic()
            self.myDynamics.removeAll()
            self.courses.removeAll()
            self.myTableView.reloadData()
        }
    }
    
    @objc func showUserInfoAction(_ sender: UIButton) {
        if declare.loginStatus == .kLogin_Status_Login {
            self.performSegue(withIdentifier: "PushTo_HDLY_UserInfo_VC_Line", sender: nil)
        } else {
            self.pushToLoginVC(vc: self)
        }
    }
    
    @IBAction func pushToSettingVC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_Setting_VC_Line", sender: nil)
    }
    
    @IBAction func pushToNotiMsgVC(_ sender: UIButton) {
        
    }
    
    func addRefresh() {
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
//        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
//        self.myTableView.es.addPullToRefresh(animator: header) { [weak self] in
//            self?.refresh()
//        }
        self.myTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.myTableView.refreshIdentifier = String.init(describing: self)
        self.myTableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        self.myDynamics.removeAll()
        getMyDynamicList()
    }
    
    private func loadMore() {
        skip = skip + take
        getMyDynamicList()
    }
    
    
}

extension HDRootEVC {
    func getUserInfo() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyDynamicIndex(api_token: declare.api_token ?? ""), cache: false, showHud: false , success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" 获取用户信息： \(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            do {
                let model:UserDynamicModel = try jsonDecoder.decode(UserDynamicModel.self, from: result)
                self.user = model.data!
                if self.user.sex == 1 {
                    self.declare.gender = "男"
                }
                if self.user.sex == 2 {
                    self.declare.gender = "女"
                }
                self.refreshUserInfo()
            } catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            if errorCode != nil && errorCode! == Status_Code_ErrorToken {
               self.declare.loginStatus = Login_Status.kLogin_Status_Logout
                self.refreshUserInfo()
            }
        }
    }
    
    func getMyDynamicList() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyDynamicList(api_token: HDDeclare.shared.api_token ?? "", skip: skip, take: take), cache: false, showHud: false , success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                var model:DynamicData = try jsonDecoder.decode(DynamicData.self, from: result)
                if self.skip != 0 || model.data.first?.commentID != self.myDynamics.first?.commentID {
                    if self.skip == 0 && model.data.first?.commentID != self.myDynamics.first?.commentID {
                        self.myDynamics =  [MyDynamic]()
                        self.iconTitleStrings = [NSAttributedString]()
                        self.starTitleStrings = [NSAttributedString]()
                    }
                    // 将字符串转换为富文本字符串，比较耗时，提前转换
                    for i in 0..<model.data.count {
                        let m = model.data[i]
                        let height = m.comment?.getContentHeight(font: UIFont.systemFont(ofSize: 14.0), width: ScreenWidth - 80)
                        model.data[i].height = Int(height!)
                        let infoModel = m.exhibitionInfo
                        let iconTitleString: NSMutableAttributedString = NSMutableAttributedString.init()
                        infoModel?.iconList?.forEach({ (icon) in
                            let urlStr = NSURL(string: icon)
                            let data = NSData(contentsOf: urlStr! as URL)
                            let image = UIImage(data: data! as Data)
                            let attach = NSTextAttachment()
                            let width = image!.size.width * 16 / image!.size.height
                            attach.bounds = CGRect.init(x: 2, y: 0, width: width, height: 16)
                            attach.image = image
                            let imgStr = NSAttributedString.init(attachment: attach)
                            iconTitleString.append(imgStr)
                            iconTitleString.append(NSAttributedString.init(string: " "))
                        })
                        self.iconTitleStrings.append(iconTitleString)
                        let star: Float! = Float(infoModel?.star ?? "0")
                        var imgStr = ""
                        if star == 0 {
                            imgStr = ""
                        }else if star < 2 {
                            imgStr = "exhibitionCmt_1_5"
                        }else if star >= 2 && star < 4 {
                            imgStr = "exhibitionCmt_2_5"
                        }else if star >= 4 && star < 6 {
                            imgStr = "exhibitionCmt_3_5"
                        }else if star >= 6 && star < 8 {
                            imgStr = "exhibitionCmt_4_5"
                        }else if star >= 8 {
                            imgStr = "exhibitionCmt_5_5"
                        }
                        let starTitleString: NSMutableAttributedString = NSMutableAttributedString.init()
                        let starImg = UIImage.init(named: imgStr)
                        let attach = NSTextAttachment()
                        attach.bounds = CGRect.init(x: 2, y: 0, width: 12, height: 12)
                        attach.image = starImg
                        let starimgStr = NSAttributedString.init(attachment: attach)
                        starTitleString.append(starimgStr)
                        starTitleString.append(NSAttributedString.init(string: " "))
                        starTitleString.append(NSAttributedString.init(string: infoModel?.star ?? "0"))
                        self.starTitleStrings.append(starTitleString) 
                    }
                    var indexPaths = [IndexPath]()
                    for j in 0..<model.data.count {
                        let indexPath = NSIndexPath.init(row: self.myDynamics.count + j, section: 1)
                        indexPaths.append(indexPath as IndexPath)
                    }
                    
                    self.myDynamics.append(contentsOf: model.data)
                    if self.skip > 0 {
                        self.myTableView.beginUpdates()
                       self.myTableView.insertRows(at: indexPaths, with: .fade)
                        self.myTableView.endUpdates()
                    } else {
                        self.myTableView.reloadData()
                    }
                    
                    self.myTableView.es.stopLoadingMore()
                    self.myTableView.es.stopPullToRefresh()
                    if model.data.count == 0 {
                        self.myTableView.es.noticeNoMoreData()
                    }
                }
                
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            if errorCode != nil && errorCode! == Status_Code_ErrorToken {
                self.declare.loginStatus = Login_Status.kLogin_Status_Logout
                self.refreshUserInfo()
            }
        }
    }
    
    func getMyStudyCourses() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyStudyCourses(api_token: HDDeclare.shared.api_token ?? "", skip: 0, take: 100), cache: false, showHud: false , success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:MyCollectCourseData = try jsonDecoder.decode(MyCollectCourseData.self, from: result)
                self.courses = model.data
                let indexPath = IndexPath(row: 4, section: 0)
                self.myTableView.reloadRows(at: [indexPath], with: .none)
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
            
        }) { (errorCode, msg) in
            if errorCode != nil && errorCode! == Status_Code_ErrorToken {
                self.declare.loginStatus = Login_Status.kLogin_Status_Logout
                self.refreshUserInfo()
            }
        }
    }
}


// MARK:--- myTableView -----
extension HDRootEVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        if section == 1 {
            return myDynamics.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//会员
                return 0.01
            }else if index == 1 {//我的钱包
                return 60
            }else if index == 2 {//我的订单
                return 60
            }else if index == 3 {//我的课程
                return declare.loginStatus == .kLogin_Status_Login ? 60 : 0
            }else if index == 4 {//
                if declare.loginStatus == .kLogin_Status_Login {
                    if self.courses.count == 0 {
                        return 0
                    } else {
                        return 140
                    }
                } else {
                    return 0
                }
            }else if index == 5 {//我的动态
                return declare.loginStatus == .kLogin_Status_Login ? 60 : 0
            }
        }
        if section == 1 {
            return declare.loginStatus == .kLogin_Status_Login ? CGFloat(self.myDynamics[index].height + 175) : 0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//会员
//                let cell = HDLY_Membership_Cell.getMyTableCell(tableV: tableView)
//                return cell!
                return UITableViewCell()
            }else if index == 1 {//我的钱包
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "我的钱包"
                cell?.moreImgV.isHidden = false
                return cell!
            }else if index == 2 {//我的订单
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.moreImgV.isHidden = false
                cell?.nameL.text = "我的订单"
                return cell!
            }else if index == 3 {//我的课程
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.isHidden = declare.loginStatus == .kLogin_Status_Login ? false : true
                cell?.moreImgV.isHidden = false
                cell?.nameL.text = "我的课程"
                return cell!
            }else if index == 4 {//
                let cell = HDLY_MineCourse_Cell.getMyTableCell(tableV: tableView)
                cell?.delegate = self
                cell?.isHidden = declare.loginStatus == .kLogin_Status_Login ? false : true
                if self.courses.count > 0 {
                   cell?.listArray = self.courses
                }
                return cell!
            }else if index == 5 {//我的动态
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.isHidden = declare.loginStatus == .kLogin_Status_Login ? false : true
                cell?.bottomLine.isHidden = true
                cell?.moreImgV.isHidden = true
                cell?.nameL.text = "我的动态"
                return cell!
            }
        }
        if section == 1 {
            let model = myDynamics[indexPath.row]
            let cell = HDLY_MyDynamicCell.getMyTableCell(tableV: tableView)
            cell?.isHidden = declare.loginStatus == .kLogin_Status_Login ? false : true
            cell?.avaImgV.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.timeL.text = model.createdAt
            cell?.nameL.text = model.nickname
            cell?.contentL.text = model.comment
            cell?.commentId = model.commentID!
            cell?.cateID = model.cateID!
            cell?.deletaBtn.isHidden = true
            cell?.deletaBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if let ip = self?.myTableView.indexPath(for: cell!) {
                    self?.deleteCommentId(commentId: model.commentID!, index: ip.row)
                }
            })
            cell?.delegate = self
            cell?.index = indexPath.row
            if model.cateID == 10 {
                cell?.detailId = model.topicInfo?.articleID ?? 0
                cell?.titleLTopCons.constant = 10
                cell?.desView.isHidden = false
                guard let infoM = model.exhibitionInfo else { return cell!}
                if infoM.img != nil {
                    cell?.imgV.kf.setImage(with: URL.init(string: infoM.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                }
                cell?.titleL.text = infoM.title
                cell?.locL.text = infoM.address
//                cell?.des1L.attributedText = iconTitleStrings[indexPath.row]
                let star: Float! = Float(infoM.star ?? "0")
                if star == 0 {
                    cell?.des1L.text = "暂无评分"
                    cell?.des2L.isHidden = true
                } else {
                    cell?.des2L.isHidden = false
                    cell?.des1L.text = "缪斯评分"
                    cell?.des2L.text = String(star)
                }
                cell?.imageType.kf.setImage(with: URL.init(string: (infoM.iconList?.first ?? "")), placeholder: UIImage.grayImage(sourceImageV: cell!.imageType))
            } else {
                cell?.titleLTopCons.constant = 16
                cell?.desView.isHidden = true
                //1资讯，2轻听随看,4精选专题,5攻略,  10展览
                if  model.cateID == 1 {
                    if let newsInfo = model.newsInfo {
                        if newsInfo.img != nil {
                            cell?.imgV.kf.setImage(with: URL.init(string: newsInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                        }
                        cell?.titleL.text = newsInfo.title
                        cell?.locL.text = String.init(format: "%@|%@", newsInfo.keywords!,newsInfo.platTitle!)
                    }
                    cell?.detailId = model.newsInfo?.articleID ?? 0
                }
                else if  model.cateID == 2 {
                    if let listenInfo = model.listenInfo {
                        if listenInfo.img != nil {
                            cell?.imgV.kf.setImage(with: URL.init(string: listenInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                        }
                        cell?.titleL.text = listenInfo.title
                        cell?.locL.text = String.init(format: "%d人听过", listenInfo.listening!)
                        cell?.detailId = model.listenInfo?.articleID ?? 0
                    }
                }
                else if  model.cateID == 4 {
                    if let topicInfo = model.topicInfo {
                        if topicInfo.img != nil {
                            cell?.imgV.kf.setImage(with: URL.init(string: topicInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                        }
                        cell?.titleL.text = topicInfo.title
                        cell?.locL.text = "精选专题"
                        cell?.detailId = model.topicInfo?.articleID ?? 0
                    }
                }
                else if  model.cateID == 5 {
                    if let strategyInfo = model.strategyInfo {
                        if strategyInfo.img != nil {
                            cell?.imgV.kf.setImage(with: URL.init(string: strategyInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                        }
                        cell?.titleL.text = strategyInfo.title
                        cell?.locL.text = ""
                       cell?.detailId = model.strategyInfo?.articleID ?? 0
                    }

                }
            }
            
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if declare.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                self.performSegue(withIdentifier: "PushTo_HDSSL_MyWalletVC_Line", sender: nil)
            }
            else if indexPath.row == 2 {
                self.performSegue(withIdentifier: "PushTo_HDSSL_MyOrderVC_Line", sender: nil)
            }
            else if indexPath.row == 3 {
                self.performSegue(withIdentifier: "PushTo_HDZQ_MyCoursesVC", sender: nil)
            }
        }
    }
    
    // 开始滑动，将当前显示cell的deleteBtn隐藏
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == myTableView {
            let cells = myTableView.visibleCells
            cells.forEach { (cell) in
                if cell.isKind(of: HDLY_MyDynamicCell.self) {
                    let c = cell as! HDLY_MyDynamicCell
                    if !c.deletaBtn.isHidden {
                        c.deletaBtn.isHidden = true
                        return
                    }
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == myTableView {
            if scrollView.contentOffset.y > 655 {
                dynamicLabel.isHidden = false
            } else {
                dynamicLabel.isHidden = true
            }
        }
    }
    
}

extension HDRootEVC:HDLY_MineCourse_Cell_Delegate {
    func didSelectItemAt(_ model: MyCollectCourseModel, _ cell: HDLY_MineCourse_Cell) {
//        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//        vc.courseId = String(model.classId)
//        self.navigationController?.pushViewController(vc, animated: true)
        let courseId = String(model.classId) ?? "0"
        self.pushCourseListWithBuyInfo(courseId: courseId, vc: self)
    }
}

extension HDRootEVC: HDLY_MineHome_Header_Delegate {
    func pushToMyDetails(type: Int) {
        if declare.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        switch type {
        case 0:
            self.performSegue(withIdentifier: "PushTo_HDZQ_MyFollowVC", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "PushTo_HDZQ_MyFCollectVC", sender: nil)
        case 2:
             self.performSegue(withIdentifier: "PushToHDZQ_DayCardVC", sender: nil)
        case 3:
            self.performSegue(withIdentifier: "PushToFootPrintVC", sender: nil)
        default:
            break
        }
    }
}

extension HDRootEVC: HDLY_MyDynamicCellDelegate {
    func pushToDetailArticle(cateId: Int, detailId: Int) {
        if cateId == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld",detailId)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cateId == 2 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            vc.listen_id = String.init(detailId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cateId == 4 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(detailId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cateId == 5 {
            let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_StrategyDetialVC") as! HDSSL_StrategyDetialVC
            vc.strategyid = detailId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if cateId == 10 {
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            vc.exhibition_id = detailId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteCommentId(commentId: Int, index:Int) {
        
        let deleteView:HDZQ_DynamicDeleteView = HDZQ_DynamicDeleteView.createViewFromNib() as! HDZQ_DynamicDeleteView
        deleteView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        deleteView.sureBlock = {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .deleteCommentReply(api_token: HDDeclare.shared.api_token ?? "",comment_id:commentId), cache: false, showHud: false , success: { (result) in
                let indexPath = NSIndexPath.init(row: index, section: 1)
                self.myTableView.beginUpdates()
                self.myDynamics.remove(at: index)
                self.starTitleStrings.remove(at: index)
                self.iconTitleStrings.remove(at: index)
                self.myTableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
                self.myTableView.endUpdates()
            }) { (errorCode, msg) in
                
            }
        }
        kWindow?.addSubview(deleteView)
    }
    
    
}
