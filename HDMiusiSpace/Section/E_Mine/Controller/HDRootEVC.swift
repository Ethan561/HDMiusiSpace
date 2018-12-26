//
//  HDRootEVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDRootEVC: HDItemBaseVC {
    @IBOutlet weak var msgBtn: UIButton!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!    
    @IBOutlet weak var myTableView: UITableView!
    private var user = UserDynamic()
    private var myDynamics = [MyDynamic]()
    private var courses =  [MyCollectCourseModel]()
    private var htmls =  [NSAttributedString]()
    let declare:HDDeclare = HDDeclare.shared
    
    var tabHeader = HDLY_MineHome_Header()
    
    private var take = 10
    private var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = kTopHeight
        setupViews()
        getMyDynamicList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if declare.loginStatus == .kLogin_Status_Login {
            addRefresh()
            getUserInfo()
            getMyStudyCourses()
        } else {
            //未登录
            self.myTableView.es.removeRefreshFooter()
            self.myTableView.es.removeRefreshHeader()
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
            self.htmls.removeAll()
            self.myTableView.reloadData()
        }
        
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tabHeader = HDLY_MineHome_Header.createViewFromNib() as! HDLY_MineHome_Header
        tabHeader.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 180)
        tabHeader.delegate = self
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 180))
        v.addSubview(tabHeader)
        myTableView.tableHeaderView = v
        tabHeader.loginBtn.addTarget(self, action: #selector(loginBtnAction), for: UIControlEvents.touchUpInside)
        tabHeader.userInfoBtn.addTarget(self, action: #selector(showUserInfoAction), for: UIControlEvents.touchUpInside)
        
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
            self.htmls.removeAll()
            self.myTableView.reloadData()
        }
    }
    
    @objc func loginBtnAction(_ sender: UIButton) {
        self.pushToLoginVC(vc: self)
    }
    
    
    @objc func showUserInfoAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_UserInfo_VC_Line", sender: nil)

    }
    
    @IBAction func pushToSettingVC(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_Setting_VC_Line", sender: nil)
    }
    
    @IBAction func pushToNotiMsgVC(_ sender: UIButton) {
        
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.myTableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
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
                // 将字符串转换为富文本字符串，比较耗时，提前转换
                for i in 0..<model.data.count {
                    let m = model.data[i]
                    var attrStr: NSAttributedString? = nil
                    if let anEncoding = m.comment!.data(using: .unicode) {
                        attrStr = try? NSAttributedString(data: anEncoding, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                        self.htmls.append(attrStr!)
                    }
                    let height = m.comment?.getContentHeight(font: UIFont.systemFont(ofSize: 14.0), width: ScreenWidth - 80)
                    model.data[i].height = Int(height!)
                }
                self.myDynamics.append(contentsOf: model.data)
                let indexSet = NSIndexSet(index: 1)
                self.myTableView.reloadSections(indexSet as IndexSet, with: .none)
                self.myTableView.es.stopLoadingMore()
                self.myTableView.es.stopPullToRefresh()
                if model.data.count < 10 {
                     self.myTableView.es.noticeNoMoreData()
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
                return 120
            }else if index == 1 {//我的钱包
                return 60
            }else if index == 2 {//我的订单
                return 60
            }else if index == 3 {//我的课程
                return declare.loginStatus == .kLogin_Status_Login ? 60 : 0
            }else if index == 4 {//
                return declare.loginStatus == .kLogin_Status_Login ? 140 : 0
            }else if index == 5 {//我的动态
                return declare.loginStatus == .kLogin_Status_Login ? 60 : 0
            }
        }
        if section == 1 {
            return declare.loginStatus == .kLogin_Status_Login ? CGFloat(self.myDynamics[index].height + 75) : 0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//会员
                let cell = HDLY_Membership_Cell.getMyTableCell(tableV: tableView)
                
                return cell!
            }else if index == 1 {//我的钱包
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "我的钱包"
                return cell!
            }else if index == 2 {//我的订单
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "我的订单"
                return cell!
            }else if index == 3 {//我的课程
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.isHidden = declare.loginStatus == .kLogin_Status_Login ? false : true
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
            cell?.contentL.attributedText = self.htmls[index]
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
    
}

extension HDRootEVC:HDLY_MineCourse_Cell_Delegate {
    func didSelectItemAt(_ model: MyCollectCourseModel, _ cell: HDLY_MineCourse_Cell) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        vc.courseId = String(model.classId)
        self.navigationController?.pushViewController(vc, animated: true)
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

