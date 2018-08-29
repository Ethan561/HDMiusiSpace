//
//  HDLY_Register_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Register_VC: HDItemBaseVC {
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var smsTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn.layer.cornerRadius = 23
        HDLY_UserModel.shared.getDeviceNum()
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        
        if phoneTF.text?.isEmpty == false && smsTF.text?.isEmpty == false {
            
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.register(username: phoneTF.text!, smscode: smsTF.text!), showHud: true, loadingVC: self , success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                let dataDic: Dictionary<String,Any> = dic!["data"] as! Dictionary
                HDDeclare.shared.saveUserMessage(myDic: dataDic as NSDictionary)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    self.back()
                })
                
            }) { (errorCode, msg) in
                
            }
        }
    }
    
    @IBAction func getSmsAction(_ sender: UIButton) {

        if phoneTF.text?.isEmpty == false {
            HDLY_UserModel.shared.sendSmsForCheck(username: phoneTF.text!, vc: self)
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
