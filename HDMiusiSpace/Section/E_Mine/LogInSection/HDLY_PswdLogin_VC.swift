//
//  HDLY_PswdLogin_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import AuthenticationServices

class HDLY_PswdLogin_VC: HDItemBaseVC,UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var weiboBtn: UIButton!
    @IBOutlet weak var thirdView: UIStackView!
    let declare:HDDeclare = HDDeclare.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号密码登录"
        self.isShowNavShadowLayer = false
        loginBtn.layer.cornerRadius = 23
        //        setupBarBtn()
        phoneTF.keyboardType = .numberPad
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        pwdTF.returnKeyType = .done
        pwdTF.delegate = self
        configUI()
        setupThridLogin()
    }
    
    func setupBarBtn() {
        //
        let rightBarBtn = UIButton.init(type: UIButton.ButtonType.custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBarBtn.setTitle("注册", for: .normal)
        rightBarBtn.setTitleColor(UIColor.HexColor(0x4A4A4A), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(pushToRegisterVC), for: UIControl.Event.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func pushToRegisterVC() {
        let vc = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Register_VC") as! HDItemBaseVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        LOG("deviceno: \(deviceno)")
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0, execute: {
                    //                    self.backToRootEVC()
                    //                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: false)
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
        if UIApplication.shared.canOpenURL(URL.init(string: "mqq://")!) == false {
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
//                LOG("name:\(resp.name)")
//                LOG("uid:\(resp.uid)")
//                LOG("iconurl:\(resp.iconurl)")
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
        let unionid = resp.unionId ?? ""
        
        let params: [String: Any] = ["openid": openid,
                                     "b_from": from,
                                     "unionid": unionid,
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
            self.declare.isVip  =  dataDic["is_vip"] as? Int
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
                //                self.back()
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
                //                self.navigationController?.popToRootViewController(animated: true)
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
            if textField == phoneTF {
                if pwdTF.text != "" {
                    loginBtn.backgroundColor = UIColor.HexColor(0xE8593E)
                    loginBtn.isEnabled = true
                }
            } else {
                if phoneTF.text != "" {
                    loginBtn.backgroundColor = UIColor.HexColor(0xE8593E)
                    loginBtn.isEnabled = true
                }
            }
        } else {
            if (textField.text?.count)! == 1 {
                loginBtn.backgroundColor = UIColor.HexColor(0xED755F)
                loginBtn.isEnabled = false
            }
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension HDLY_PswdLogin_VC {
    
    func configUI()  {
        if #available(iOS 13.0, *) {
            let appleIDBtn = ASAuthorizationAppleIDButton.init(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
            appleIDBtn.cornerRadius = 17.5
            appleIDBtn.frame = CGRect.init(x: 15, y:0, width: 35, height: 35)
            appleIDBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            let imgV = UIButton()
            imgV.addSubview(appleIDBtn)
            imgV.backgroundColor = UIColor.clear
            self.thirdView.addArrangedSubview(imgV)
        } else {
        }
    }
    @objc func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            // 创建新的AppleID 授权请求\
            let appleIDRequest = appleIDProvider.createRequest()
            appleIDRequest.requestedScopes = [.fullName, .email]
            // 在用户授权期间请求的联系信息
            //            appleIDRequest.requestedScopes =  [email] @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController.init(authorizationRequests: [appleIDRequest])
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self;
            
            authorizationController.presentationContextProvider = self
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
        }else{
            // 处理不支持系统版本
            //                   NSLog(@"该系统版本不可用Apple登录");
        }
    }
}

extension HDLY_PswdLogin_VC : ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = appleIDCredential.user // 授权的用户唯一标识
            let identityToken = appleIDCredential.identityToken // 授权用户的JWT凭证
            let str = String(data:identityToken!, encoding: String.Encoding.utf8)!
            let array = user.components(separatedBy:".")
            let name = array[1]
            let index = name.index(name.startIndex, offsetBy:6)//获取字符d的索引
            let nickname = String(name[..<index])
            HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .checkApple(userId: user, identityToken: str), showHud: true, loadingVC: self, success: { (result) in
                
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                let deviceno = HDLY_UserModel.shared.getDeviceNum()
                let params: [String: Any] = ["openid": user,
                                             "b_from": "apple",
                                             "deviceno": deviceno,
                                             "b_nickname": "apple用户\(nickname)",
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
                    self.declare.isVip  =  dataDic["is_vip"] as? Int
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
                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    
                }) { (errorCode, msg) in
                    HDAlert.showAlertTipWith(type: HDAlertType.error, text: msg)
                    if errorCode == 422 {
                        let vc = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_ThirdBindPhoneVC") as! HDZQ_ThirdBindPhoneVC
                        vc.params = params
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                
            }) { (errorCode, msg) in
                HDAlert.showAlertTipWith(type: HDAlertType.error, text: msg)
            }
            
            
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension HDLY_PswdLogin_VC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
