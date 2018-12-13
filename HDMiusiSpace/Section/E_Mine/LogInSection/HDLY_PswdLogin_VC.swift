//
//  HDLY_PswdLogin_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_PswdLogin_VC: HDItemBaseVC,UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var weiboBtn: UIButton!
    let declare:HDDeclare = HDDeclare.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号密码登录"
        loginBtn.layer.cornerRadius = 23
        setupBarBtn()
        phoneTF.keyboardType = .numberPad
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        pwdTF.returnKeyType = .done
        pwdTF.delegate = self
        setupThridLogin()
    }
    
    func setupBarBtn() {
        //
        let rightBarBtn = UIButton.init(type: UIButtonType.custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBarBtn.setTitle("注册", for: .normal)
        rightBarBtn.setTitleColor(UIColor.HexColor(0x4A4A4A), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(pushToRegisterVC), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func pushToRegisterVC() {
        let vc = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Register_VC") as! HDItemBaseVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()

        if phoneTF.text?.isEmpty == false && pwdTF.text?.isEmpty == false {
            guard  Validate.phoneNum(phoneTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
                return
            }
            guard  Validate.password(pwdTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的密码")
                return
            }
            
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.usersLogin(username: phoneTF.text!, password: pwdTF.text!, smscode: "", deviceno: deviceno), showHud: true, loadingVC: self , success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                let dataDic: Dictionary<String,Any> = dic!["data"] as! Dictionary
                self.declare.api_token = dataDic["api_token"] as? String
                self.declare.uid      = dataDic["uid"] as? Int
                self.declare.phone    = dataDic["phone"] as? String
                self.declare.email    = dataDic["email"] as? String
                self.declare.nickname = dataDic["nickname"] as? String
                
                let avatarStr = dataDic["avatar"] as? String == nil ? "" : dataDic["avatar"] as? String
                self.declare.avatar = HDDeclare.IP_Request_Header() + avatarStr!
                let arr:Array<String> = dataDic["tags"] as! Array<String>
                if arr.count > 0 {
                    let tags = NSSet.init(array: arr)
                    JPUSHService.setTags(tags as? Set<String>, completion: nil, seq: 1)
                }
                self.declare.loginStatus = .kLogin_Status_Login
                //
                let defaults = UserDefaults.standard
                defaults.setValue(self.declare.api_token, forKey: userInfoTokenKey)
                HDLY_UserModel.shared.requestUserInfo()
                HDAlert.showAlertTipWith(type: .onlyText, text: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    self.backToRootEVC()
                })
                
            }) { (errorCode, msg) in
                
            }
        }
    }
    
    func backToRootEVC() {
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: HDRootEVC.self) {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func forgetPwdBAction(_ sender: UIButton) {
        let desVC = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SafetyVerifi_VC") as! HDLY_SafetyVerifi_VC
        desVC.segueType = "1"
        desVC.isFindPwd = true
        self.navigationController?.pushViewController(desVC, animated: true)
    }
    
    @IBAction func smsLoginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupThridLogin() {
        if UMSocialManager.default().isInstall(UMSocialPlatformType.QQ) == false {
            qqBtn.isHidden = true
        }
        if UMSocialManager.default().isInstall(UMSocialPlatformType.wechatSession) == false {
            wxBtn.isHidden = true
        }
        if UMSocialManager.default().isInstall(UMSocialPlatformType.sina) == false {
            weiboBtn.isHidden = true
        }
        
    }
    
    @IBAction func thridLoginAction(_ sender: UIButton) {
        let index = sender.tag - 200
        if index == 1 {//微信
            self.getAuthWithUserInfoWithType(type: .wechatSession)
        }
        else if index == 2 {//QQ
            self.getAuthWithUserInfoWithType(type: .QQ)
        }
        else if index == 3 {//微博
            self.getAuthWithUserInfoWithType(type: .sina)
        }
    }
    
    func getAuthWithUserInfoWithType(type: UMSocialPlatformType) {
        
        var from = "qq"
        if type == .wechatSession {
            from = "wx"
        }else if type == .sina {
            from = "wb"
        }
        
        UMSocialManager.default().getUserInfo(with: type, currentViewController: self) { (result, error) in
            if error != nil {
                LOG("\(String(describing: error?.localizedDescription))")
            }else {
                let resp:UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                LOG("name:\(resp.name)")
                LOG("uid:\(resp.uid)")
                LOG("iconurl:\(resp.iconurl)")
                //
                self.thirdLoginRequestWithInfo(resp: resp, from: from)
            }
        }
    }
    
    
    func thirdLoginRequestWithInfo(resp:UMSocialUserInfoResponse, from: String) {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        let openid   = resp.uid!
        let b_nickname = resp.name!
        let b_avatar = resp.iconurl ?? ""
        let params: [String: Any] = ["openid": openid,
                                     "b_from": from,
                                     "b_nickname": b_nickname,
                                     "b_avatar": b_avatar,
                                     "deviceno": deviceno,
                                     ]
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.register_bind(params: params), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" dic ： \(String(describing: dic))")
            let dataDic: Dictionary<String,Any> = dic!["data"] as! Dictionary
            self.declare.api_token = dataDic["api_token"] as? String
            self.declare.uid      = dataDic["uid"] as? Int
            self.declare.phone    = dataDic["phone"] as? String
            self.declare.email    = dataDic["email"] as? String
            self.declare.nickname = dataDic["nickname"] as? String
            self.declare.isVip  =  dataDic["nickname"] as? Int
            let avatarStr = dataDic["avatar"] as? String == nil ? "" : dataDic["avatar"] as? String
            self.declare.avatar = HDDeclare.IP_Request_Header() + avatarStr!
            let arr:Array<String> = dataDic["tags"] as! Array<String>
            if arr.count > 0 {
                let tags = NSSet.init(array: arr)
                JPUSHService.setTags(tags as? Set<String>, completion: nil, seq: 1)
            }
            
            self.declare.loginStatus = .kLogin_Status_Login
            //
            let defaults = UserDefaults.standard
            defaults.setValue(self.declare.api_token, forKey: userInfoTokenKey)
            HDLY_UserModel.shared.requestUserInfo()
            HDAlert.showAlertTipWith(type: .onlyText, text: "登录成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
//                self.back()
                self.navigationController?.popToRootViewController(animated: true)
            })
            
        }) { (errorCode, msg) in
            HDAlert.showAlertTipWith(type: HDAlertType.error, text: msg)
            if errorCode == 422 {
                let vc = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_ThirdBindPhoneVC") as! HDZQ_ThirdBindPhoneVC
                vc.params = params
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
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
