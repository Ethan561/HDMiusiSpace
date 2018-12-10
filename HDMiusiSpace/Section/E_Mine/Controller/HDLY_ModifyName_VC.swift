//
//  HDLY_ModifyName_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ModifyName_VC: HDItemBaseVC {

    var showNicknameVIew = true
    
    @IBOutlet weak var signatureView: UIView!
    @IBOutlet weak var nicknameVIew: UIView!
    //
    @IBOutlet weak var signatureTextView: HDPlaceholderTextView!
    @IBOutlet weak var countL: UILabel!
    //
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    
    let declare:HDDeclare = HDDeclare.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showNicknameVIew == true {
            self.title = "昵称修改"
            nameTF.text = declare.nickname
            nicknameVIew.isHidden = false
            signatureView.isHidden = true
        }else {
            self.title = "个人简介"
            signatureTextView.text = declare.profile
            nicknameVIew.isHidden = true
            signatureView.isHidden = false
            signatureTextView.delegate = self
            countL.text = "\(declare.sign?.count ?? 0)/30"
        }
        
        setupBarBtn()
    }
    
    func setupBarBtn() {
        //
        let rightBarBtn = UIButton.init(type: UIButtonType.custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBarBtn.setTitle("保存", for: .normal)
        rightBarBtn.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(modifyUserInfoRequest), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func modifyUserInfoRequest() {
        if showNicknameVIew == true {
            if nameTF.text?.isEmpty == false {
                if (nameTF.text?.count)! > 8 && (nameTF.text?.count)! < 4 {
                    HDAlert.showAlertTipWith(type: .onlyText, text: "请输入4-8个字符")
                } else {
                    modifyNicknameRequest()
                }
            }
        }else {
            if signatureTextView.text.isEmpty == false {
                if signatureTextView.text.count > 30 {
                    HDAlert.showAlertTipWith(type: .onlyText, text: "请输入少于30个字符")
                } else {
                    modifyProfileRequest()
                }
                
            }
        }
    }
    
    func modifyNicknameRequest() {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .modifyNickname(api_token: declare.api_token!, nickname: nameTF.text!), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let nickname: String = dic!["data"] as! String
            self.declare.nickname = nickname
            HDAlert.showAlertTipWith(type: .onlyText, text: "昵称更新成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                self.back()
            })
        }) { (errorCode, msg) in
            
        }
    }
    
    func modifyProfileRequest() {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .usersProfile(api_token: HDDeclare.shared.api_token!, profile: signatureTextView.text), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let sign: String = dic!["data"] as! String
            self.declare.sign = sign
            self.declare.profile = sign
            HDAlert.showAlertTipWith(type: .onlyText, text: "个人简介更新成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                self.back()
            })
        }) { (errorCode, msg) in
            
        }
    }
    
    @IBAction func clearBtnAction(_ sender: UIButton) {
        nameTF.text = ""
    }
    
    deinit {
        print("deinit")
    }
    
}


extension HDLY_ModifyName_VC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print( textView.text.count)
        countL.text = "\(textView.text.count)/30"
    }
}
