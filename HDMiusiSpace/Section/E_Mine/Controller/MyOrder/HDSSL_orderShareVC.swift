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
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var contentBgView: UIView!
    //user
    @IBOutlet weak var user_nickName: UILabel!
    @IBOutlet weak var user_portrial: UIImageView!
    //展览信息
    @IBOutlet weak var exhibition_img: UIImageView!
    @IBOutlet weak var exhibition_name: UILabel!
    @IBOutlet weak var exhibition_des: UILabel!
    //课程信息
    @IBOutlet weak var calss_price: UILabel!
    @IBOutlet weak var calss_studentNum: UILabel!
    @IBOutlet weak var class_timeNum: UILabel!
    //二维码
    @IBOutlet weak var qr_img: UIImageView!
    @IBOutlet weak var qr_title: UILabel!
    @IBOutlet weak var qr_des: UILabel!
    //评论文字
    @IBOutlet weak var commentLab: UITextView!
    
    
    var sharePath: String?
    var orderID  :Int?
    var shareView:HDLY_ShareView?
    var shareImage: UIImage? //分享图片
    //mvvm
    var viewModel: HDZQ_MyViewModel = HDZQ_MyViewModel()
    var shareModel: HDSSL_shareOrderModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        user_portrial.layer.cornerRadius = 57/2
        user_portrial.layer.masksToBounds = true
        exhibition_img.layer.cornerRadius = 10
        exhibition_img.layer.masksToBounds = true
        self.contentBgView.layer.cornerRadius = 10
        
        //获取画报信息
        viewModel.getOrderShareDataWith(api_token: HDDeclare.shared.api_token ?? "", orderId: orderID!, vc: self)
    }
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.orderShareDataModel.bind { (model) in
            weakSelf?.loadMyViews(model)
        }
    }
    func loadMyViews(_ model:HDSSL_shareOrderModel){
        self.shareModel = model
        DispatchQueue.main.async {
            //加载页面数据
            self.user_portrial.kf.setImage(with: URL.init(string: self.shareModel.avatar ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.user_portrial), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.user_nickName.text = self.shareModel.nickname
            self.exhibition_img.kf.setImage(with: URL.init(string: self.shareModel.img ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.exhibition_img), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.exhibition_name.text = self.shareModel.title
            self.exhibition_des.text = self.shareModel.author! + " " +  self.shareModel.sub_title!
            
            self.class_timeNum.text = String.init(format: "%d课时", self.shareModel.class_num!)
            self.calss_price.text = "¥" + self.shareModel.pay_amount!
            self.calss_studentNum.text = String.init(format: "%d人在学", self.shareModel.study_num!)
            
            
            self.commentLab.text = self.shareModel.des
            
            self.qr_img.kf.setImage(with: URL.init(string: self.shareModel.qr_code ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.qr_img), options: nil, progressBlock: nil, completionHandler: nil)
            self.qr_title.text = self.shareModel.qr_code_title
            self.qr_des.text = self.shareModel.qr_code_des
            

        }
        
    }
    @IBAction func action_share(_ sender: UIButton) {
        //1、截图保存图片
        shareImage = screenshotPicture()
        //2、上传图片
        if shareImage != nil {
            showSahreView()
        }
    }
    func showSahreView() {
        //3、分享
        let tipView: HDLY_ShareView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        shareView = tipView
    }
    
    //MARK:-截屏保存图片
    func screenshotPicture() -> UIImage? {
        
        shareBtn.isHidden = true
        
        let scale: CGFloat = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height-80), false, scale)
        
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if img != nil {
            UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
        }
        
        shareBtn.isHidden = false
        return img
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
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建图片内容对象
        let shareObject = UMShareImageObject.init()
        
        shareObject.shareImage = shareImage
        
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
