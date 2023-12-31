//
//  HDLY_LeaveQuestion_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/24.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_LeaveQuestion_VC: HDItemBaseVC,UITextViewDelegate {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navHCons: NSLayoutConstraint!
    @IBOutlet weak var titleTextView: HDPlaceholderTextView!
    @IBOutlet weak var textView: HDPlaceholderTextView!
    
    var courseId: String?
    var textNum:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navHCons.constant = CGFloat(kTopHeight)
        
        textView.delegate = self
        textView.returnKeyType = .done
        titleTextView.delegate = self
        titleTextView.returnKeyType = .done
        
    }
    
    @IBAction func cancleBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commitBtnAction(_ sender: UIButton) {
        guard let idnum = self.courseId else {
            return
        }
        if titleTextView.text.isEmpty == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "标题不能为空")
            return
        } else if titleTextView.text.count < 10 {
            HDAlert.showAlertTipWith(type: .onlyText, text: "标题内容太少")
            return
        }
        if textView.text.isEmpty == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "描述不能为空")
            return
        } else if textView.text.count < 8 {
//            HDAlert.showAlertTipWith(type: .onlyText, text: "留言内容太少")
//            return
        }
        
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseQuestion(api_token: HDDeclare.shared.api_token!, id: idnum, title: titleTextView.text, content: textView.text), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            HDAlert.showAlertTipWith(type: .onlyText, text: "问题提交成功")
            self.textView.text = ""
            self.titleTextView.text = ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                self.navigationController?.popViewController(animated: true)
            })
            
        }) { (errorCode, msg) in
            
        }
        
    }
    
    
    //MARK: - TextViewDelegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.isEmpty == false {
            //获得已输出字数与正输入字母数
            let selectRange = textView.markedTextRange
            //获取高亮部分 － 如果有联想词则解包成功
            if let selectRange = selectRange {
                let position =  textView.position(from: (selectRange.start), offset: 0)
                if (position != nil) {
                    return
                }
            }
            
            let textContent = textView.text
            let textNum = textContent?.count
            
            //截取200个字
            if textNum! > TOTAL_NUM {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: TOTAL_NUM)
                let str = textContent?.substring(to: index!)
                textView.text = str
            }
        }
        
        self.textNum = textView.text.count
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

