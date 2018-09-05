//
//  HDLY_Setting_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Setting_VC: HDItemBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let declare = HDDeclare.shared
        if declare.api_token != nil {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.userLogout(api_token: declare.api_token!), cache: false, showHud: false , success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG("\(String(describing: dic))")
                declare.removeUserMessage()
                declare.loginStatus = .kLogin_Status_Logout
                HDAlert.showAlertTipWith(type: .onlyText, text: "退出登录成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    self.back()
                })
            }) { (errorCode, msg) in
                
            }
        }else {
            declare.loginStatus = .kLogin_Status_Logout
        }
        
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
