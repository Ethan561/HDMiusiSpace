//
//  HDLY_Register_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Register_VC: HDItemBaseVC,UITextFieldDelegate {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var smsBtn: UIButton!
    var seconds:Int32 = 59
    lazy var timer: Timer = { () ->Timer in
        let currTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.minus), userInfo: nil, repeats: true)
        return currTimer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "快速注册"
        loginBtn.layer.cornerRadius = 23
//        loginBtn.isEnabled = false
        phoneTF.keyboardType = .emailAddress
        phoneTF.returnKeyType = .done
        phoneTF.delegate = self
        smsTF.keyboardType = .numberPad
        smsTF.returnKeyType = .done
        smsTF.delegate = self
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        if phoneTF.text?.isEmpty == false  {
            guard  Validate.phoneNum(phoneTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
                return
            }
            guard  Validate.verifyNumber(smsTF.text!).isRight  else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的验证码")
                return
            }
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.register(username: phoneTF.text ?? "", smscode: smsTF.text ?? "", deviceno: HDDeclare.shared.deviceno ?? ""), showHud: true, loadingVC: self , success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                let dataDic: Dictionary<String,Any> = dic!["data"] as! Dictionary
                let arr:Array<String> = dataDic["tags"] as! Array<String>
                if arr.count > 0 {
                    let tags = NSSet.init(array: arr)
                    JPUSHService.setTags(tags as? Set<String>, completion: nil, seq: 1)
                }
                HDDeclare.shared.saveUserMessage(myDic: dataDic as NSDictionary)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    self.back()
                })
                
            }) { (errorCode, msg) in
                
            }
        } else {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入您的手机号")
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
        } else {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入您的手机号")
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
    
    @IBAction func agreeProtocolAction(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
//            loginBtn.isEnabled = true
//            loginBtn.backgroundColor = UIColor.HexColor(0xE8593E)
//        } else {
//            loginBtn.isEnabled = false
//            loginBtn.backgroundColor = UIColor.HexColor(0x9B9B9B)
//        }
    }
    
    @IBAction func showProtocolDetailAction(_ sender: Any) {
        let vc = HDLY_WKWebVC()
        vc.titleName = "服务协议"
        vc.urlPath = "http://www.muspace.net/api/users/about_html/fwxy?p=i"
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
}
