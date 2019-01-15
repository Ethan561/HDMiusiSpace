//
//  HDLY_SmsLogin_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_SmsLogin_VC: HDItemBaseVC, UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var smsBtn: UIButton!
    let declare:HDDeclare = HDDeclare.shared
    
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var wbBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    
    var seconds:Int32 = 59
    lazy var timer: Timer = { () ->Timer in
        let currTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        return currTimer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThridLogin()
        loginBtn.layer.cornerRadius = 23
        setupBarBtn()
        phoneTF.keyboardType = .numberPad
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        smsTF.keyboardType = .numberPad
        smsTF.returnKeyType = .done
        smsTF.delegate = self
        
    }
    
    func setupBarBtn() {
        let leftBarBtn = UIButton.init(type: UIButtonType.custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBarBtn.setImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
        leftBarBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        //
//        let rightBarBtn = UIButton.init(type: UIButtonType.custom)
//        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
//        rightBarBtn.setTitle("注册", for: .normal)
//        rightBarBtn.setTitleColor(UIColor.HexColor(0x4A4A4A), for: .normal)
//        
//        rightBarBtn.addTarget(self, action: #selector(pushToRegisterVC), for: UIControlEvents.touchUpInside)
//        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
//        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func pushToRegisterVC() {
        let vc = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Register_VC") as! HDItemBaseVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func protocolAction(_ sender: Any) {
        let vc = HDLY_WKWebVC()
        vc.titleName = "服务协议"
        vc.urlPath = "http://www.muspace.net/api/users/about_html/fwxy?p=i"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {

        let deviceno = HDLY_UserModel.shared.getDeviceNum()

        if phoneTF.text?.isEmpty == false && smsTF.text?.isEmpty == false {
            guard  Validate.phoneNum(phoneTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
                return
            }
//            guard  Validate.verifyNumber(smsTF.text!).isRight  else {
//                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的验证码")
//                return
//            }
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.usersLogin(username: phoneTF.text!, password: "", smscode: smsTF.text!, deviceno: deviceno), showHud: true, loadingVC: self , success: { (result) in
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0, execute: {
                    self.back()
                })
                
            }) { (errorCode, msg) in
                
            }
        }
    }
    
    @IBAction func getSmsAction(_ sender: UIButton) {
        if phoneTF.text?.isEmpty == false {
            guard  Validate.phoneNum(phoneTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
                return
            }
            HDLY_UserModel.shared.sendSmsForCheck(username: phoneTF.text!, vc: self)
            beginCount()
            if smsTF.canBecomeFirstResponder == true {
                smsTF.becomeFirstResponder()
            }
        }
    }
    
    
    func beginCount() {
        self.smsBtn.isUserInteractionEnabled = false
        self.timer.fireDate = Date.distantPast
    }
    
    @objc func minus () {
        if (self.seconds < 1) {
            self.endCount()
        } else {
            self.seconds -= 1
            self.smsBtn.setTitle("\(self.seconds)s", for: .normal)
        }
    }
    
    func endCount() {
        self.seconds = 59
        self.smsBtn.setTitle("获取验证码", for: .normal)
        self.smsBtn.isUserInteractionEnabled = true
        self.timer.fireDate = Date.distantFuture
    }
    
    //MARK: 三方登录
    func setupThridLogin() {
        if UMSocialManager.default().isInstall(UMSocialPlatformType.QQ) == false {
            qqBtn.isHidden = true
        }
        if UMSocialManager.default().isInstall(UMSocialPlatformType.wechatSession) == false {
            wxBtn.isHidden = true
        }
        if UMSocialManager.default().isInstall(UMSocialPlatformType.sina) == false {
            wbBtn.isHidden = true
        }
        
    }
    
    @IBAction func thridLoginAction(_ sender: UIButton) {
        let index = sender.tag - 100
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0, execute: {
                self.back()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" {
            loginBtn.backgroundColor = UIColor.HexColor(0xE8593E)
            loginBtn.isEnabled = true
        } else {
            if (textField.text?.count)! == 1 {
                loginBtn.backgroundColor = UIColor.HexColor(0xED755F)
                loginBtn.isEnabled = false
            }
        }
        
        return true
    }

}
