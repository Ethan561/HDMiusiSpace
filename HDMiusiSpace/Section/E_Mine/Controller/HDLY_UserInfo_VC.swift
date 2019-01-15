//
//  HDLY_UserInfo_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_UserInfo_VC: HDItemBaseVC , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nicknameL: UILabel!
    @IBOutlet weak var genderL: UILabel!
    @IBOutlet weak var signatureL: UILabel!
    @IBOutlet weak var labStrs: UIView!
    
    @IBOutlet weak var labSignsViewBottomConstraint: NSLayoutConstraint!
    var lastTagOrigin : CGPoint?  //上一个标签起点
    var lastTagSize   : CGSize?   //上一个标签尺寸
    
    var pickedAvatarImage: UIImage?
    lazy var genderTipView: HDLY_GenderTip_View = HDLY_GenderTip_View.createViewFromNib() as! HDLY_GenderTip_View
    
    let declare:HDDeclare = HDDeclare.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "编辑个人资料"
        avatarBtn.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showUserInfo()

    }
    
    func showUserInfo() {
        nicknameL.text = declare.nickname
        signatureL.text = declare.profile
        var s = ""
        declare.labStr?.forEach({ (str) in
            s = s + str
        })
        labStrs.removeAllSubviews()
         var recordLab: UILabel? = nil
        for i in 0..<declare.labStr!.count {
            let tagTitle = declare.labStr![i] as NSString
            let lab = UILabel()
            lab.backgroundColor = UIColor.white
            lab.textColor = UIColor.HexColor(0x9b9b9b)
            lab.font =  UIFont.systemFont(ofSize: 14)
            lab.lineBreakMode = .byTruncatingTail
            let rect = tagTitle.boundingRect(with: CGSize.init(width:ScreenWidth - 150, height: 30), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), attributes: [NSAttributedStringKey.font : lab.font], context: nil)
            
            let BtnW = rect.size.width + 20
            let BtnH = rect.size.height + 10
            // 左对齐
//            if i == 0 {
//                lab.frame = CGRect(x: 0, y: 10, width: BtnW, height: BtnH)
//            } else {
//                let yuWidth: CGFloat = labStrs.frame.size.width - 10 - (recordLab?.frame.origin.x ?? 0.0) - (recordLab?.frame.size.width ?? 0.0)
//                if yuWidth >= (rect.size.width ) {
//                    lab.frame = CGRect(x: (recordLab?.frame.origin.x ?? 0.0) + (recordLab?.frame.size.width ?? 0.0) + 10, y: recordLab?.frame.origin.y ?? 0.0, width: BtnW, height: BtnH)
//                } else {
//                    lab.frame = CGRect(x: 0, y: (recordLab?.frame.origin.y ?? 0.0) + (recordLab?.frame.size.height ?? 0.0) + 10, width: BtnW, height: BtnH)
//                }
//            }
            // 右对齐
            let w = ScreenWidth - 150
            if i == 0 {
                lab.frame = CGRect(x: w - 10 - BtnW , y: 10, width: BtnW, height: BtnH)
            } else {
                let yuWidth: CGFloat = (recordLab?.frame.origin.x ?? 0.0) - 10
                if yuWidth >= (rect.size.width ) {
                    lab.frame = CGRect(x: (recordLab?.frame.origin.x ?? 0.0) - 10 - BtnW, y: recordLab?.frame.origin.y ?? 0.0, width: BtnW, height: BtnH)
                } else {
                    lab.frame = CGRect(x: w - 10 - BtnW, y: (recordLab?.frame.origin.y ?? 0.0) + (recordLab?.frame.size.height ?? 0.0) + 10, width: BtnW, height: BtnH)
                }
            }

            lab.text = tagTitle as String
            lab.textAlignment = .center
            lab.layer.masksToBounds = true
            lab.layer.cornerRadius = (rect.size.height + 10) / 2
            lab.layer.borderWidth = 0.5
            lab.layer.borderColor = UIColor.HexColor(0x9b9b9b).cgColor
            labStrs.addSubview(lab)
            recordLab = lab
            
        }
        
        if recordLab != nil  {
            labSignsViewBottomConstraint.constant = recordLab!.frame.origin.y + 40
        }
        
        
        genderL.text = declare.gender
        if declare.avatar != nil {
            avatarBtn.kf.setBackgroundImage(with: URL.init(string: declare.avatar!), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    @IBAction func changeAvatarAction(_ sender: UIButton) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        // 2 命令（样式：退出Cancel，警告Destructive-按钮标题为红色，默认Default）
        let cancelAction = UIAlertAction(title: "相机", style: UIAlertActionStyle.default) { (alert) in
            self.chooseFromCamera()
        }
        let deleteAction = UIAlertAction(title: "相册", style: UIAlertActionStyle.default) { (alert) in
            self.chooseFromLibarary()
        }
        
        let third = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (alert) in
            
        }
        
        alertSheet.addAction(cancelAction)
        alertSheet.addAction(deleteAction)
        alertSheet.addAction(third)
        // 3 跳转
        self.present(alertSheet, animated: true, completion: nil)
        
    }
    
    
    func chooseFromLibarary()  {
        let imagePicker = UIImagePickerController()
        // 表示操作为进入系统相册
        imagePicker.sourceType = .photoLibrary
        // 设置代理为 ViewController
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // 允许用户编辑选择的图片
        imagePicker.allowsEditing = true
        // 进入系统相册界面
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func chooseFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            // 表示操作为拍照
            imagePicker.sourceType = .camera
            // 拍照后允许用户进行编辑
            imagePicker.allowsEditing = true
            // 也可以设置成视频
            imagePicker.cameraCaptureMode = .photo
            // 设置代理为 ViewController，已经实现了协议
            imagePicker.delegate = self
            // 进入拍照界面
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            // 照相机不可用
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 参数 UIImagePickerControllerOriginalImage 代表选取原图片，这里使用 UIImagePickerControllerEditedImage 代表选取的是经过用户拉伸后的图片。
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            picker.dismiss(animated: true, completion: nil)
            // 这里对选取的图片进行你需要的操作，通常会调整 ContentMode。
            LOG("\(String.init(describing: pickedImage))")
            pickedAvatarImage = pickedImage
            uploadImgsAction(img: pickedImage)
        }
        else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadImgsAction(img: UIImage)  {
        
        var imgData = UIImagePNGRepresentation(img)!

        imgData = UIImage.resetImgSize(sourceImage: img, maxImageLenght: img.size.width*0.5, maxSizeKB: 1024)//最大1M
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .modifyAvatar(api_token: declare.api_token!, avatar: imgData), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let imgStr: String = dic!["data"] as! String
            self.declare.avatar = HDDeclare.IP_Request_Header() + imgStr
            self.avatarBtn.setBackgroundImage(img, for: .normal)
            HDAlert.showAlertTipWith(type: .onlyText, text: "头像更新成功")
        }) { (errorCode, msg) in
            
        }
        
    }
    
    
    @IBAction func changeNickNameAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_ModifyName_VC_Line", sender: 1)
    }
    
    @IBAction func changeSignLabeAction(_ sender: Any) {
        
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HDTagChooseStateVC") as! HDTagChooseStateVC
//        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeGenderAction(_ sender: UIButton) {
        if kWindow != nil {
            self.genderTipView.frame = kWindow!.bounds
            kWindow!.addSubview(self.genderTipView)
            weak var weakS = self
            self.genderTipView.sureBlock = { (type) in
                weakS?.changeGenderRequest(type)
            }
        }
    }
    
    func changeGenderRequest(_ type: Int) {
        if HDDeclare.shared.api_token == nil { return }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .usersChangeGender(api_token: HDDeclare.shared.api_token!, sex: "\(type)"), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let sex: String = dic!["data"] as! String
            self.genderL.text = sex == "1" ?  "男" : "女"
            self.declare.gender = self.genderL.text
             self.genderTipView.sureBlock = nil
        }) { (errorCode, msg) in
            self.genderTipView.sureBlock = nil
        }
    }
    
    
    @IBAction func changeSignatureAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_ModifyName_VC_Line", sender: 2)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushTo_HDLY_ModifyName_VC_Line" {
            let type:Int = sender as! Int
            let vc: HDLY_ModifyName_VC = segue.destination as! HDLY_ModifyName_VC
            if type == 1 {
                vc.showNicknameVIew = true
            }else if type == 2 {
                vc.showNicknameVIew = false
            }
            
        }
    }


}
