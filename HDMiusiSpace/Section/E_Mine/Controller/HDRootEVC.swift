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
        refreshUserInfo()
//        var  params = ["p":"i", "api_token": HDDeclare.shared.api_token ?? "",
//                       "study_time":"02:00",
//                                 "chapter_id":"13"]
//        let signKey =  HDDeclare.getSignKey(params)
//        let dic2 = ["Sign": signKey]
//        params.merge(dic2, uniquingKeysWith: { $1 })
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
            tabHeader.signatureL.text = declare.sign
            if declare.avatar != nil {
                tabHeader.avatarImgV.kf.setImage(with: URL.init(string: declare.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        } else {
            //未登录
            tabHeader.userInfoView.isHidden  = true
            tabHeader.loginView.isHidden = false
            tabHeader.avatarImgV.image = UIImage.init(named: "wd_img_tx")
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK:--- myTableView -----
extension HDRootEVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    //header
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    //footer
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.01
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    
    //row
    
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
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: "PushTo_HDZQ_MyCoursesVC", sender: nil)
        }
    }
    
}

extension HDRootEVC: HDLY_MineHome_Header_Delegate {
    func pushToMyDetails(type: Int) {
        switch type {
        case 0:
            print(1)
            self.performSegue(withIdentifier: "PushTo_HDZQ_MyFollowVC", sender: nil)
        case 1:
            print(2)
            self.performSegue(withIdentifier: "PushTo_HDZQ_MyFCollectVC", sender: nil)
        case 2:
            print(3)
             self.performSegue(withIdentifier: "PushToHDZQ_DayCardVC", sender: nil)
        case 3:
            print(4)
        default:
            break
        }
    }
    
    
}

