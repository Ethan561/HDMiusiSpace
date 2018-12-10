//
//  HDLY_SafetyVerifi_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_SafetyVerifi_VC: HDItemBaseVC {
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var phoneL: UILabel!
    var segueType:String = "1"
    
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    var isFindPwd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全验证"
        loginBtn.layer.cornerRadius = 23
        
        let phone = HDDeclare.shared.phone
        if isFindPwd == true {
            self.title = "找回密码"
            phoneL.isHidden = true
            phoneView.isHidden = false
        }
        phoneL.text = HDDeclare.shared.phone
        guard let foot =  phone?.suffix(4) else { return }
        guard let head =  phone?.prefix(3) else { return }
        phoneL.text = String(head) + "····" + String(foot)
        
    }

    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if (phoneTF.text?.isEmpty)! || phoneTF.text == "" {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
            return
        }
        guard  Validate.phoneNum(phoneTF.text!).isRight  else {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入正确的手机号")
            return
        }
        
        if isFindPwd == false {
            self.performSegue(withIdentifier: "PushTo_HDLY_SafetyVerifiSms_VC_Line", sender: nil)
        }else {
            self.performSegue(withIdentifier: "PushTo_HDLY_SafetyVerifiSms_VC_Line", sender: phoneTF.text!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushTo_HDLY_SafetyVerifiSms_VC_Line" {
            let vc: HDLY_SafetyVerifiSms_VC = segue.destination as! HDLY_SafetyVerifiSms_VC
            vc.segueType = self.segueType
            vc.phone = HDDeclare.shared.phone
            if isFindPwd == true {
                let phone:String = phoneTF.text!
                vc.phone = phone
            }
        }
    }
    

}
