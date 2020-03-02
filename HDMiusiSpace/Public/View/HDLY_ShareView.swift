//
//  HDLY_ShareView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

protocol UMShareDelegate: NSObjectProtocol {
    func shareDelegate(platformType: UMSocialPlatformType)
}

class HDLY_ShareView: UIView {

    @IBOutlet weak var wxBtn: UIButton!
    @IBOutlet weak var pyqBtn: UIButton!
    @IBOutlet weak var wbBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var qzBtn: UIButton!
    weak var delegate : UMShareDelegate?

    let imgArr = ["share_WeChat", "share_pyq", "share_weibo","share_qq" ,"share_qzane"]
    let titleArr = ["微信好友","朋友圈","新浪微博","QQ","QQ空间"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let btnArr = [wxBtn,pyqBtn,wbBtn,qqBtn,qzBtn]
        for (i,btn) in btnArr.enumerated() {
            let imgName = imgArr[i]
            let title = titleArr[i]
            btn?.set(image: UIImage.init(named: imgName), title: title, titlePosition: .bottom, additionalSpacing: 8, state: UIControl.State.normal)
            btn?.setBackgroundImage(UIImage.getImgWithColor(UIColor.white, imgSize: CGSize.init(width: 20, height: 20)), for: .normal)
            btn?.setBackgroundImage(UIImage.getImgWithColor(UIColor.white, imgSize: CGSize.init(width: 20, height: 20)), for: .normal)
            btn?.tag = 100 + i
            btn?.addTarget(self, action: #selector(shareAction(_:)), for: .touchUpInside)
        }
    }
    
    @objc func shareAction(_ sender: UIButton) {
        let index = sender.tag - 100
        var platformType: UMSocialPlatformType =  UMSocialPlatformType.QQ
        if index == 0 {
            platformType = .wechatSession
        }
        else if index == 1 {
            platformType = .wechatTimeLine
        }
        else if index == 2 {
            platformType = .sina
        }
        else if index == 3 {
            platformType = .QQ
        }
        else if index == 4 {
            platformType = .qzone
        }
        shareWithType(platformType: platformType)
    }
    
    func shareWithType(platformType: UMSocialPlatformType) {
        if delegate != nil {
            delegate?.shareDelegate(platformType: platformType)
        }
    }

    
    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    func alertWithShareError(_ error: Error ) {
        let code = (error as NSError).code
        var result:String = "0000"
        switch code {
        case 2000:
            result = "未知错误"
        case 2001:
            result = "未安装软件或版本不支持"
        case 2002:
            result = "授权失败"
        case 2003:
            result = "分享失败"
        case 2005:
            result = "分享内容为空"
        case 2008:
            result = "应用未安装"
        case 2009:
            result = "分享取消"
        case 2010:
            result = "网络错误"
            
        default:
            result = "分享失败"
            break
        }
        HDAlert.showAlertTipWith(type: .onlyText, text: result)
    }
    
    
}
