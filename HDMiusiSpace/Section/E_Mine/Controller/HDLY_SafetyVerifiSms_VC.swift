//
//  HDLY_SafetyVerifiSms_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_SafetyVerifiSms_VC: HDItemBaseVC, UITextFieldDelegate {

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tipL: UILabel!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    var segueType:String = "1"
    var phone: String?
    let declare:HDDeclare = HDDeclare.shared
    
    var seconds:Int32 = 59
    lazy var timer: Timer = { () ->Timer in
        let currTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        return currTimer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全验证"
        
        loginBtn.layer.cornerRadius = 23
        smsTF.keyboardType = .numberPad
        smsTF.returnKeyType = .done
        smsTF.delegate = self
        guard let foot =  phone?.suffix(4) else { return }
        guard let head =  phone?.prefix(3) else { return }
        if phone != nil {
            self.title = "找回密码"
            HDLY_UserModel.shared.sendSmsForCheck(username: phone!, vc: self)
            beginCount()
            tipL.text = "短信验证码已发送至" + String(head) + "····" + String(foot)
        } else if declare.phone != nil {
            HDLY_UserModel.shared.sendSmsForCheck(username: declare.phone!, vc: self)
            beginCount()
            tipL.text = "短信验证码已发送至" + String(head) + "····" + String(foot)
        }
        if smsTF.canBecomeFirstResponder == true {
            smsTF.becomeFirstResponder()
        }
    }
    
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if smsTF.text?.isEmpty == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请输入验证码")
            return
        }
        var username = ""
        if phone != nil {
            username = phone!
        } else if declare.phone != nil {
            username = declare.phone!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.usersVerify(username: username, smscode: smsTF.text!), showHud: true, loadingVC: self , success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" dic ： \(String(describing: dic))")
//            let dataDic: Dictionary<String,Any> = dic!["data"] as! Dictionary
            guard let apitoken = dic!["data"] as? String else { return }
//            self.declare.api_token = dataDic["api_token"] as? String
//            self.declare.nickname = dataDic["nickname"] as? String
            self.declare.api_token = apitoken
            self.declare.loginStatus = .kLogin_Status_Login
            let defaults = UserDefaults.standard
            defaults.setValue(self.declare.api_token, forKey: userInfoTokenKey)
            self.showChangeVC()
            
        }) { (errorCode, msg) in
            
        }

    }

    func showChangeVC() {
        if segueType == "1" {
            self.performSegue(withIdentifier: "PushTo_HDLY_ChangePwd_VC_Line", sender: nil)
        } else if segueType == "2" {
            self.performSegue(withIdentifier: "PushTo_HDLY_ChangePhone_VC_Line", sender: nil)
        }
    }
    
    
    @IBAction func getSmsAction(_ sender: UIButton) {
        if phone != nil {
            HDLY_UserModel.shared.sendSmsForCheck(username: phone!, vc: self)
            beginCount()
            tipL.text = "短信验证码已发送至" + phone!
            if smsTF.canBecomeFirstResponder == true {
                smsTF.becomeFirstResponder()
            }
        } else if declare.phone != nil {
            HDLY_UserModel.shared.sendSmsForCheck(username: declare.phone!, vc: self)
            beginCount()
            tipL.text = "短信验证码已发送至" + HDDeclare.shared.phone!
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
        self.smsBtn.setTitle("重新发送", for: .normal)
        self.smsBtn.isUserInteractionEnabled = true
        self.timer.fireDate = Date.distantFuture
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
