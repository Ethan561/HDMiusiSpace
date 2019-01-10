//
//  HDLY_Feedback_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/30.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

let Feedback_TOTAL_NUM:Int = 500

class HDLY_Feedback_VC: HDItemBaseVC , UITextViewDelegate {

    @IBOutlet weak var textView: HDPlaceholderTextView!
    @IBOutlet weak var coutL: UILabel!
    
    var textNum: Int = 0
    var typeID: String? //操作类型0用户设置中心 1课程,2轻听随看,3看展,4资讯
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        textView.delegate = self
        textView.returnKeyType = .done
        setupBarBtn()
        textView.placeholder = "请填写意见和建议，我们将为您不断改进"
    }
    
    func setupBarBtn() {
        //
        let rightBarBtn = UIButton.init(type: UIButtonType.custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        rightBarBtn.setTitle("提交", for: .normal)
        rightBarBtn.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(commitBtnAction), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    

    @objc func commitBtnAction(_ sender: UIButton) {
        guard let idnum = self.typeID else {
            return
        }
        if textView.text.isEmpty == true {return}
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .sendFeedback(api_token: HDDeclare.shared.api_token!, cate_id: idnum, content: textView.text), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            HDAlert.showAlertTipWith(type: .onlyText, text: "提交成功")
            self.textView.text = ""
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
            
            //截取500个字
            if textNum! > Feedback_TOTAL_NUM {
                let index = textContent?.index((textContent?.startIndex)!, offsetBy: Feedback_TOTAL_NUM)
                let str = textContent?.substring(to: index!)
                textView.text = str
            }
        }
        
        self.textNum = textView.text.count
        self.coutL.text =  "\(self.textNum)/\(Feedback_TOTAL_NUM)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
