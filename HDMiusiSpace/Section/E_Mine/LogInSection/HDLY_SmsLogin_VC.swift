//
//  HDLY_SmsLogin_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import AuthenticationServices

class HDLY_SmsLogin_VC: HDItemBaseVC, UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var smsBtn: UIButton!
    let declare:HDDeclare = HDDeclare.shared
    
    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var wbBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!    
    @IBOutlet weak var thirdView: UIStackView!
    var seconds:Int32 = 59
    lazy var timer: Timer = { () ->Timer in
        let currTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        return currTimer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        setupThridLogin()
        loginBtn.layer.cornerRadius = 23
        self.hd_navigationBarHidden = true
        //        setupBarBtn()
        phoneTF.keyboardType = .numberPad
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        smsTF.keyboardType = .numberPad
        smsTF.returnKeyType = .done
        smsTF.delegate = self
        
        configUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
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
        // 检测是否安装了QQ
        if UIApplication.shared.canOpenURL(URL.init(string: "mqq://")!) == false {
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
            if textField == phoneTF {
                if smsTF.text != "" {
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
    
}


extension HDLY_SmsLogin_VC {
    
    func configUI()  {
        if #available(iOS 13.0, *) {
            let appleIDBtn = ASAuthorizationAppleIDButton.init(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
            appleIDBtn.cornerRadius = 17.5
            appleIDBtn.frame = CGRect.init(x: 15, y:0, width: 35, height: 35)
            appleIDBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            let imgV = UIButton()
            imgV.addSubview(appleIDBtn)
            imgV.backgroundColor = UIColor.clear
            self.thirdView.addArrangedSubview(imgV)
        } else {
//            let appleIDBtn = UIButton.init(type: .custom)
//            appleIDBtn.layer.cornerRadius = 17.5
////            appleIDBtn.frame = CGRect.init(x: 0, y:0, width: 65, height: 65)
//            appleIDBtn.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//            //            appleIDBtn.setTitle("Sign in with Apple", for: .normal)
//            appleIDBtn.setImage(UIImage.init(named: "apple1"), for: .normal)
//            self.thirdView.addArrangedSubview(appleIDBtn)
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

extension HDLY_SmsLogin_VC : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let user = appleIDCredential.user // 授权的用户唯一标识
//            let fullName = appleIDCredential.fullName // 授权的用户名称
//            let email = appleIDCredential.email // 授权的用户邮箱
            let identityToken = appleIDCredential.identityToken // 授权用户的JWT凭证
//            let authorizationCode = appleIDCredential.authorizationCode // 授权码
            let str = String(data:identityToken!, encoding: String.Encoding.utf8)!
//            let auth = String(data:authorizationCode!, encoding: String.Encoding.utf8)!
            

                   let array = user.components(separatedBy:".")
                   print("字符串转数组:\(array)")
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
                
            }) { (errorCode, msg) in
                HDAlert.showAlertTipWith(type: HDAlertType.error, text: msg)
            }
            
            
        }
//        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//                let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                        message: message,
//                                                        preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                self.present(alertController, animated: true, completion: nil)
//            }
//        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension HDLY_SmsLogin_VC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
