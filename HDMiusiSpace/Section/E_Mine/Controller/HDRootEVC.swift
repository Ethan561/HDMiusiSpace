//
//  HDRootEVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootEVC: HDItemBaseVC {

    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var signatureL: UILabel!
    @IBOutlet weak var loginView: UIView!
    
    let declare:HDDeclare = HDDeclare.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = kTopHeight
        avatarImgV.layer.cornerRadius = 30
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshUserInfo()
    }
    
    
    func refreshUserInfo() {
        if declare.loginStatus == .kLogin_Status_Login {
            //已登录
            userInfoView.isHidden  = false
            loginView.isHidden = true
            nameL.text = declare.nickname
            signatureL.text = declare.sign
            if declare.avatar != nil {
                avatarImgV.kf.setImage(with: URL.init(string: declare.avatar!), placeholder: UIImage.init(named: "user_img1"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }else {
            //未登录
            userInfoView.isHidden  = true
            loginView.isHidden = false
        }
    }
    

    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.pushToLoginVC(vc: self)
    }
    
    
    @IBAction func showUserInfoAction(_ sender: UIButton) {
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
