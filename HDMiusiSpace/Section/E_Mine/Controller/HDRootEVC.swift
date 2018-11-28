//
//  HDRootEVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootEVC: HDItemBaseVC {

    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!    
    @IBOutlet weak var myTableView: UITableView!
    
    private var user = UserModel()
    
    let declare:HDDeclare = HDDeclare.shared
    
    var tabHeader = HDLY_MineHome_Header()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = kTopHeight
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        refreshUserInfo()
        getUserInfo()
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
            //已登录
            tabHeader.userInfoView.isHidden  = false
            tabHeader.loginView.isHidden = true
            tabHeader.nameL.text = declare.nickname
            tabHeader.signatureL.text = declare.profile
            if declare.avatar != nil {
                tabHeader.avatarImgV.kf.setImage(with: URL.init(string: declare.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            tabHeader.followNumberLabel.text = "\(user.focus_num)"
            tabHeader.collectNumberLabel.text = "\(user.favorite_num)"
            tabHeader.cardNumberLabel.text = "\(user.daycard_num)"
            tabHeader.foorprintNumberLabel.text = "\(user.footprint_num)"
        } else {
            //未登录
            tabHeader.userInfoView.isHidden  = true
            tabHeader.loginView.isHidden = false
            tabHeader.avatarImgV.image = UIImage.init(named: "wd_img_tx")
            tabHeader.followNumberLabel.text = "0"
            tabHeader.collectNumberLabel.text = "0"
            tabHeader.cardNumberLabel.text = "0"
            tabHeader.foorprintNumberLabel.text = "0"
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
}

extension HDRootEVC {
    func getUserInfo() {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.getUserInfo(api_token: declare.api_token ?? ""), cache: false, showHud: false , success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" 获取用户信息： \(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            guard let model:UserData = try? jsonDecoder.decode(UserData.self, from: result) else { return }
            self.user = model.data ?? UserModel()
            self.declare.isVip = self.user.is_vip
            self.declare.isBindWeibo = self.user.bind_wb
            self.declare.isBindWechat = self.user.bind_wx
            self.declare.weiboName = self.user.wb_nickname
            self.declare.wechatName = self.user.wx_nickname
            self.declare.isBindQQ = self.user.bind_qq
            self.declare.QQName = self.user.qq_nickname
            self.declare.profile = self.user.profile
            self.declare.labStr = self.user.label_str
            self.declare.avatar = self.user.avatar
            self.declare.nickname = self.user.nickname
            LOG(self.user.label_str)
            if self.user.sex == 1 {
                self.declare.gender = "男"
            }
            if self.user.sex == 2 {
                self.declare.gender = "女"
            }
            self.refreshUserInfo()
        }) { (errorCode, msg) in
            self.declare.loginStatus = Login_Status.kLogin_Status_Logout
            self.refreshUserInfo()
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
            return 3
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
                return 60
            }else if index == 4 {//
                return 140 * ScreenWidth/375.0

            }else if index == 5 {//我的动态
                return 60
            }
        }
        if section == 1 {
            return 100
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
                cell?.bottomLine.isHidden = true
                cell?.nameL.text = "我的课程"
                return cell!
            }else if index == 4 {//
                let cell = HDLY_MineCourse_Cell.getMyTableCell(tableV: tableView)

                return cell!
            }else if index == 5 {//我的动态
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.bottomLine.isHidden = true
                cell?.moreImgV.isHidden = true
                cell?.nameL.text = "我的动态"
                return cell!
            }
        }
        if section == 1 {
            let cell = HDLY_MyDynamicCell.getMyTableCell(tableV: tableView)
            
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension HDRootEVC: HDLY_MineHome_Header_Delegate {
    func pushToMyDetails(type: Int) {
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

