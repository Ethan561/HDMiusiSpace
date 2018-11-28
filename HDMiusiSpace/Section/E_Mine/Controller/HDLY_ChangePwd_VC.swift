//
//  HDLY_ChangePwd_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ChangePwd_VC: HDItemBaseVC, UITextFieldDelegate {
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pwdTF: UITextField!
    
    let declare:HDDeclare = HDDeclare.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        loginBtn.layer.cornerRadius = 23
        pwdTF.returnKeyType = .done
        pwdTF.delegate = self
        
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if pwdTF.text?.isEmpty == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请输入新密码")
            return
        }
        if HDDeclare.shared.api_token != nil {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .usersPassword(api_token: HDDeclare.shared.api_token!, password: pwdTF.text!), showHud: true, loadingVC: self , success: { (result) in
                
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                guard let dataDic: Dictionary<String,Any> = dic!["data"] as? Dictionary else { return }
                self.declare.api_token = dataDic["api_token"] as? String
                self.declare.loginStatus = .kLogin_Status_Login
                let defaults = UserDefaults.standard
                defaults.setValue(self.declare.api_token, forKey: userInfoTokenKey)
                
                HDAlert.showAlertTipWith(type: .onlyText, text: "密码修改成功")
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    for vc in self.navigationController!.viewControllers {
                        if vc.isKind(of: HDLY_AccountBind_VC.self) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                        else if vc.isKind(of: HDLY_PswdLogin_VC.self) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                })
            }) { (errorCode, msg) in
                
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
