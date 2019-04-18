//
//  HDZQ_PrivacyView.swift
//  HDDongBeiLieShi
//
//  Created by HD-XXZQ-iMac on 2018/10/12.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit


protocol PrivacyViewDelegate:NSObjectProtocol {
    func chickPrivacyURLLink()
    func chickRefuseBtn()
    func chickAgreeBtn()
}

class HDZQ_PrivacyView: UIView {


    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var mySubLabel: UILabel!
    //    @IBOutlet weak var lastTF: UITextView!
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var privacyTextView: UITextView!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    weak var delegate: PrivacyViewDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        myContentView.layer.masksToBounds = true
//        myContentView.layer.cornerRadius = 5.0
          myContentView.configShadow(cornerRadius: 5, shadowColor: UIColor.clear, shadowOpacity: 1, shadowRadius: 5, shadowOffset: CGSize.zero)
//        agreeBtn.setTitle(HDDeclare.getTranslate(str: "agree") , for: .normal)
//        agreeBtn.layer.borderColor = UIColor.HexColor(0xEEEEEE).cgColor
//        agreeBtn.layer.borderWidth = 0.5
//        refuseBtn.setTitle(HDDeclare.getTranslate(str: "disagree") , for: .normal)
//        refuseBtn.layer.borderColor = UIColor.HexColor(0xEEEEEE).cgColor
//        refuseBtn.layer.borderWidth = 0.5
        
        let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: "欢迎使用“缪斯空间”！我们非常重视您的个人信息和隐私保护。在您使用“缪斯空间”服务之前，请仔细阅读《缪斯空间隐私政策》，我们将严格按照经您同意的各项条款使用您的个人信息，以便为您提供更好的服务。 ", attributes: [ NSAttributedString.Key.backgroundColor : UIColor.clear, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0),NSAttributedString.Key.foregroundColor:UIColor.HexColor(0x666666)])
        
        attributedString.addAttribute(.link, value: "protocol://", range: (attributedString.string as NSString).range(of: "《缪斯空间隐私政策》"))

        privacyTextView.delegate = self
        privacyTextView.attributedText = attributedString
//        privacyTextView.linkTextAttributes = [NSMutableAttributedString.Key.foregroundColor:UIColor.HexColor(0x6DAAF8)]

        mySubLabel.text = "如您同意此政策，请点击“同意”并开始使用我们的产品和服务，我们尽全力保护您的个人信息安全。"
//        myTitleLabel.text = HDDeclare.getTranslate(str: "Privacy Policy")
//        myTitleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
//        lastTF.text = HDDeclare.getTranslate(str: "privateLast")
        
        
    }

    @IBAction func argeeAction(_ sender: Any) {
        if delegate != nil {
            delegate?.chickAgreeBtn()
            self.removeFromSuperview()
        }
    }
    @IBAction func refuseAction(_ sender: Any) {
        if delegate != nil {
            delegate?.chickRefuseBtn()
            self.removeFromSuperview()
        }
    }
}

extension HDZQ_PrivacyView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.scheme == "protocol" {
            if delegate != nil {
                delegate?.chickPrivacyURLLink()
            }
        }
        return true;
    }
    
}
