//
//  HD_LY_TipView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/14.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

enum HDAlertType {
    case success
    case error
    case warning
    case onlyText
}

class HD_LY_TipView: UIView {
    
    var backgroundView: UIView = UIView.init()
    var alertView: TipContentView?
    var alertType: HDAlertType = .success
    var tipText: String = ""

    //
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //
    convenience init(frame: CGRect, tipMsg: String, alertType: HDAlertType) {
        self.init(frame: frame)
        self.frame = (kKeyWindow?.bounds)!
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.1
        self.addSubview(backgroundView)
        
        self.alertType = alertType
        self.tipText = tipMsg
        //
        addContentView()
    }
    
    func addContentView() {
        if self.alertType != .onlyText {
            guard let alertV = TipContentView.createViewFromNib() as? TipContentView else {
                return
            }
            alertView = alertV
        }else {
            guard let alertV = Bundle.main.loadNibNamed("TipContentView", owner: self, options: nil)?.last as? TipContentView else {
                return
            }
            alertView = alertV
        }
        alertView!.bgView.layer.cornerRadius = 5
        alertView!.bgView.layer.masksToBounds = true
        
        switch alertType {
        case .success:
            alertView!.tipImgV.image = UIImage.init(named: "alert_success")
            let widthA = ScreenWidth*0.6
            let textH = tipText.getContentHeight(font: UIFont.systemFont(ofSize: 15), width: width*0.8)
            let hightA = textH + 135
            alertView!.frame = CGRect.init(x: 0, y: 0, width: widthA, height: hightA)
            alertView!.center = self.center
            alertView!.msgL.text = tipText
            self.addSubview(alertView!)
            
        case .error:
            alertView!.tipImgV.image = UIImage.init(named: "alert_error")
            let widthA = ScreenWidth*0.6
            let textH = tipText.getContentHeight(font: UIFont.systemFont(ofSize: 15), width: width*0.8)
            let hightA = textH + 135
            alertView!.frame = CGRect.init(x: 0, y: 0, width: widthA, height: hightA)
            alertView!.center = self.center
            alertView!.msgL.text = tipText
            self.addSubview(alertView!)
        case .warning:
            alertView!.tipImgV.image = UIImage.init(named: "alert_warning")
            let widthA = ScreenWidth*0.6
            let textH = tipText.getContentHeight(font: UIFont.systemFont(ofSize: 15), width: width*0.8)
            let hightA = textH + 135
            alertView!.frame = CGRect.init(x: 0, y: 0, width: widthA, height: hightA)
            alertView!.center = self.center
            alertView!.msgL.text = tipText
            self.addSubview(alertView!)
            
        case .onlyText:
            var widthT = tipText.getContentWidth(font: UIFont.systemFont(ofSize: 15)) + 30
            if widthT > ScreenWidth * 0.8 {
                widthT = ScreenWidth * 0.8
            }
            let textH = tipText.getContentHeight(font: UIFont.systemFont(ofSize: 15), width: widthT*0.8)
            let heightT = textH + 15
            alertView!.frame = CGRect.init(x: 0, y: 0, width: widthT, height: heightT)
            alertView!.center = self.center
            alertView!.msgL.text = tipText
            self.addSubview(alertView!)
            
            
        default: break
            
        }
    }
    
    //
    func showAlert() {
        var i=0
        kKeyWindow?.subviews.forEach({ (view) in
            if view.isKind(of: HD_LY_TipView.self) {
                    i = i + 1
            }
        })
        if i == 0 {
            kKeyWindow?.addSubview(self)
        }
        self.alpha = 0
        alertView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.alertView!.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }
    
    func hideAlert() {
        UIView.animate(withDuration: 0.3) {
            self.alertView!.transform = CGAffineTransform.identity
            self.alpha = 1
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView!.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.alpha = 0
        }) { (finished) in
            self.removeFromSuperview()
        }
    }

}
