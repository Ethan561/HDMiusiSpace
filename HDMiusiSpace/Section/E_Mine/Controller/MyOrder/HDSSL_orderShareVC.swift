//
//  HDSSL_orderShareVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/12/11.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_orderShareVC: HDItemBaseVC {
    @IBOutlet weak var bgView: UIImageView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var sharePath: String?
    var shareView:HDLY_ShareView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(sharePath!)
        self.imgView.kf.setImage(with: URL.init(string: sharePath!), placeholder: UIImage.grayImage(sourceImageV: self.imgView), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @IBAction func action_share(_ sender: UIButton) {
        let tipView: HDLY_ShareView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        shareView = tipView
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK:--- 分享
extension HDSSL_orderShareVC: UMShareDelegate {
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard let url  = self.sharePath else {
            return
        }
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = url
        let shareObject = UMShareWebpageObject.shareObject(withTitle: "缪斯空间", descr: "归属感，缪斯空间", thumImage: thumbURL)
        
        //设置网页地址
        shareObject?.webpageUrl = url
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        
        weak var weakS = self
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { data, error in
            if error != nil {
                //UMSocialLog(error)
                LOG(error)
                weakS?.shareView?.alertWithShareError(error!)
            } else {
                if (data is UMSocialShareResponse) {
                    let resp = data as? UMSocialShareResponse
                    //分享结果消息
                    LOG(resp?.message)
                    //第三方原始返回的数据
                    print(resp?.originalResponse ?? 0)
                } else {
                    LOG(data)
                }
                HDAlert.showAlertTipWith(type: .onlyText, text: "分享成功")
                HDLY_ShareGrowth.shareGrowthRequest()
                weakS?.shareView?.removeFromSuperview()
            }
        }
        
        
        
    }
}
