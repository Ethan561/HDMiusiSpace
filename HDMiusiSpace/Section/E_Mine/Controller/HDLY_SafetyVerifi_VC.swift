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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全验证"
        loginBtn.layer.cornerRadius = 23
        phoneL.text = HDDeclare.shared.phone
    }

    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_SafetyVerifiSms_VC_Line", sender: nil)
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
        }
    }
    

}
