//
//  HDSSL_shareCommentVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//  本地加载结束，截屏保存分享

import UIKit

class HDSSL_shareCommentVC: HDItemBaseVC {

    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var portrial: UIImageView!
    @IBOutlet weak var lab_nickName: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var ex_img: UIImageView!
    @IBOutlet weak var ex_name: UILabel!
    @IBOutlet weak var ex_address: UILabel!
    @IBOutlet weak var list_img1: UIImageView!
    @IBOutlet weak var list_img2: UIImageView!
    @IBOutlet weak var museumBtn: UIButton!
    @IBOutlet weak var qr_img: UIImageView!
    @IBOutlet weak var qr_title: UILabel!
    @IBOutlet weak var qr_des: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    
    var imgPath: String?//服务器生存分享图片地址
    var commentId: Int? //评论id
    var shareView:HDLY_ShareView?
    var shareImage: UIImage? //分享图片
    //mvvm
    var viewModel: HDSSL_commentVM = HDSSL_commentVM()
    var shareModel:HDSSL_PaperDataModel!
    var starSlider : XHStarRateView! //评星View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        //获取画报信息
        viewModel.get_informationOfPaper(api_token: HDDeclare.shared.api_token ?? "", commentId: commentId!, vc: self)
        //加载页面数据
//        self.largeImgView.kf.setImage(with: URL.init(string: self.imgPath!), placeholder: UIImage.grayImage(sourceImageV: self.largeImgView), options: nil, progressBlock: nil, completionHandler: nil)
        //
        portrial.layer.cornerRadius = 57/2
        portrial.layer.masksToBounds = true
        ex_img.layer.cornerRadius = 10
        ex_img.layer.masksToBounds = true
        
        starSlider = XHStarRateView.init(frame: starView.bounds, numberOfStars: 5, rateStyle: .HalfStar, isAnination: true,andForegroundImg:"zlpl_star_red" , finish: { (index) in

        })
        starView.addSubview(starSlider)
        
    }
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.paperShareDataModel.bind { (model) in
            weakSelf?.loadMyViews(model)
        }
    }
    func loadMyViews(_ model:HDSSL_PaperDataModel){
        self.shareModel = model
        DispatchQueue.main.async {
            //加载页面数据
            self.bgView.layer.cornerRadius = 10
            self.portrial.kf.setImage(with: URL.init(string: self.shareModel.avatar ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.portrial), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.lab_nickName.text = self.shareModel.nickname
            self.ex_img.kf.setImage(with: URL.init(string: self.shareModel.img ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.ex_img), options: nil, progressBlock: nil, completionHandler: nil)
            
            self.ex_name.text = self.shareModel.title
            self.ex_address.text = self.shareModel.exhibition_address
            if self.shareModel.is_card == 0 {
                self.list_img1.isHidden = true
            }
            if self.shareModel.is_tour == 0 {
                self.list_img2.isHidden = true
            }
            self.museumBtn.setTitle(self.shareModel.museum_address, for: .normal)
            self.commentTextView.text = self.shareModel.content
            
            self.qr_img.kf.setImage(with: URL.init(string: self.shareModel.qr_code ?? ""), placeholder: UIImage.grayImage(sourceImageV: self.qr_img), options: nil, progressBlock: nil, completionHandler: nil)
            self.qr_title.text = self.shareModel.qr_code_title
            self.qr_des.text = self.shareModel.qr_code_des
            
            self.starSlider.setCurrentScore(CGFloat(self.shareModel!.star!))
        }
        
    }
    
    @IBAction func action_shareImg(_ sender: Any) {
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
        
        
        let scale: CGFloat = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height-80), false, scale)
        
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if img != nil {
            UIImageWriteToSavedPhotosAlbum(img!, nil, nil, nil)
        }
        
        return img
    }

}

//MARK:--- 分享
extension HDSSL_shareCommentVC: UMShareDelegate {
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        
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
