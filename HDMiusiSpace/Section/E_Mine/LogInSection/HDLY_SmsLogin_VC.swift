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
    
    var seconds:Int32 = 59
    lazy var timer: Timer = { () ->Timer in
        let currTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        return currTimer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if declare.deviceno == nil {
            HDLY_UserModel.shared.getDeviceNum()
            return
        }

        
        if phoneTF.text?.isEmpty == false && smsTF.text?.isEmpty == false {
            guard  Validate.phoneNum(phoneTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
                return
            }
//            guard  Validate.verifyNumber(smsTF.text!).isRight  else {
//                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的验证码")
//                return
//            }
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.usersLogin(username: phoneTF.text!, password: "", smscode: smsTF.text!, deviceno: declare.deviceno!), showHud: true, loadingVC: self , success: { (result) in
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
                
                self.declare.loginStatus = .kLogin_Status_Login
                //
                let defaults = UserDefaults.standard
                defaults.setValue(self.declare.api_token, forKey: userInfoTokenKey)
                
                HDAlert.showAlertTipWith(type: .onlyText, text: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
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
    
    @IBAction func thridLoginAction(_ sender: UIButton) {
        
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
    

}
