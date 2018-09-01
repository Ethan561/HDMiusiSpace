//
//  HDLY_ReportError_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/29.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ReportError_VC: HDItemBaseVC , UITextViewDelegate {

    var photoSelectorView: HDLY_PhotoSelectorView!

    @IBOutlet weak var errorBtn1: UIButton!
    @IBOutlet weak var errorBtn2: UIButton!
    @IBOutlet weak var errorBtn3: UIButton!
    @IBOutlet weak var errorBtn4: UIButton!
    @IBOutlet weak var errorBtn5: UIButton!
    @IBOutlet weak var errorBtn6: UIButton!
    @IBOutlet weak var errorBtnView: UIView!
    
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var textView: HDPlaceholderTextView!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var imgBgView: UIView!
    
    var textNum:Int = 0
    var articleID: String?
    var typeID: String?
    
    var imgPathArr: Array<String> = Array.init()
    var errorModel: ReportErrorModel?
    //MVVM
    let viewModel: ReportErrorViewModel = ReportErrorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initCollectionView()
        self.title = "报错"
        
        textView.placeholder = "请输入你想发布的内容..."
        textView.returnKeyType = UIReturnKeyType.done
        textView.delegate = self
        
        //MVVM
        bindViewModel()
        if articleID != nil && typeID != nil {
            viewModel.dataRequestWithListenID(id: articleID!, cate_id: typeID!, self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //键盘开启监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func setup() {
        imgV.layer.cornerRadius = 8
        
        textBgView.layer.cornerRadius = 4
        textBgView.layer.borderWidth = 1
        textBgView.layer.borderColor = UIColor.HexColor(0xDADADA).cgColor
        commitBtn.layer.cornerRadius = 27
        
        errorBtn1.isHidden = true
        errorBtn1.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn1.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)

        errorBtn2.isHidden = true
        errorBtn2.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn2.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)
        
        errorBtn3.isHidden = true
        errorBtn3.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn3.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)
        
        errorBtn4.isHidden = true
        errorBtn4.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn4.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)
        
        errorBtn5.isHidden = true
        errorBtn5.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn5.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)
        
        errorBtn6.isHidden = true
        errorBtn6.setImage(UIImage.init(named: "bc_icon_choose_gray"), for: .normal)
        errorBtn6.setImage(UIImage.init(named: "bc_icon_choose_red"), for: .selected)
        
    }
    
    // 初始化选择器
    func initCollectionView() {
        photoSelectorView = HDLY_PhotoSelectorView(self.navigationController)
        photoSelectorView.currentVC = self
//        let newImage = image!.scaleImage()
//        // 将选中的图片添加到图片数组
//        photoSelectorView.photos.append(newImage)
//        photoSelectorView.originalPhotos.append(image!)
        
        photoSelectorView.frame = imgBgView.bounds
        imgBgView.addSubview(photoSelectorView)
        
    }
    

    //MVVM
    
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.reportErrorModel.bind { (_) in
            
            weakSelf?.errorModel = self.viewModel.reportErrorModel.value
            weakSelf?.showViewData()
            weakSelf?.showErrorOptionListView()
        }
        
    }
    func showViewData() {
        titleL.text = errorModel?.data?.title
        imgV.kf.setImage(with: URL.init(string: (errorModel?.data?.img)!), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func showErrorOptionListView() {
        guard let list = errorModel?.data?.optionList else {
            return
        }
        for (i, item) in list.enumerated() {
            let model = item
            switch i {
            case 0:
                errorBtn1.isHidden = false
                errorBtn1.setTitle(model.optionTitle, for: .normal)
            case 1:
                errorBtn2.isHidden = false
                errorBtn2.setTitle(model.optionTitle, for: .normal)

            case 2:
                errorBtn3.isHidden = false
                errorBtn3.setTitle(model.optionTitle, for: .normal)

            case 3:
                errorBtn4.isHidden = false
                errorBtn4.setTitle(model.optionTitle, for: .normal)

            case 4:
                errorBtn5.isHidden = false
                errorBtn5.setTitle(model.optionTitle, for: .normal)

            case 5:
                errorBtn6.isHidden = false
                errorBtn6.setTitle(model.optionTitle, for: .normal)

            default: break
            }
        }
    
    }
        
    @IBAction func errorBtnChooseAction(_ sender: UIButton) {
        let index = sender.tag - 100
        switch index {
        case 0:
            errorBtn1.isSelected =  !errorBtn1.isSelected
        case 1:
            errorBtn2.isSelected =  !errorBtn2.isSelected
        case 2:
            errorBtn3.isSelected =  !errorBtn3.isSelected
        case 3:
            errorBtn4.isSelected =  !errorBtn4.isSelected
        case 4:
            errorBtn5.isSelected =  !errorBtn5.isSelected
        case 5:
            errorBtn6.isSelected =  !errorBtn6.isSelected
            
        default: break
            
        }
        
    }
    
    func getErrorOptionIdStr() -> String {
        var optionIdStr = ""
        for subBtn in errorBtnView.subviews {
            if subBtn.isKind(of: UIButton.self) {
                let btn: UIButton = subBtn as! UIButton
                if btn.isSelected == true {
                    let index = btn.tag - 100
                    guard let list = errorModel?.data?.optionList else {
                        return optionIdStr
                    }
                    let model = list[index]
                    let tempStr = "\(model.optionID)#"
                    optionIdStr += tempStr
                }
            }
        }
        return optionIdStr
    }
    
    
    @IBAction func commitBtnAction(_ sender: UIButton) {
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        
        var optionIdStr = getErrorOptionIdStr()
        if optionIdStr.contains("#") {
            optionIdStr.removeLast()
        }else {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请选择报错类型")
            return
        }
        
        if textView.text.isEmpty == true {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请填写内容")
            return
        }
        if photoSelectorView.originalPhotos.count ==  0 {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请选择要上传的图片")
            return
        }else if photoSelectorView.originalPhotos.count > 0 {
            uploadImgsAction(optionIdStr: optionIdStr)
        }

    }
    
    @objc func uploadImgsAction(optionIdStr: String) {
        self.view.endEditing(true)
        
        if photoSelectorView.originalPhotos.count > 0 {
            self.imgPathArr.removeAll()
            DispatchQueue.main.async {
//                let hud = self.pleaseWait()
                let  loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
                loadingView?.frame = self.view.bounds
                self.view.addSubview(loadingView!)
                
                for i in 0..<self.photoSelectorView.originalPhotos.count {
                    let img = self.photoSelectorView.originalPhotos[i]
                    var imgData = UIImagePNGRepresentation(img)!
                    if imgData.count/1024/1204 > 1 {
                        imgData = UIImage.resetImgSize(sourceImage: img, maxImageLenght: img.size.width*0.5, maxSizeKB: 1024)//最大1M
                    }
                    HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .uploadImg(api_token: HDDeclare.shared.api_token!, uoload_img: imgData), success: { (result) in
                        
                        let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                        LOG("\(String(describing: dic))")
                        let imgPath:String? = dic!["data"] as? String
                        let imgUrl: String =  (imgPath != nil ? imgPath! : "")
                        self.imgPathArr.append(imgUrl)
                        if self.imgPathArr.count == self.photoSelectorView.photos.count {
//                            hud.hide()
                            loadingView?.removeFromSuperview()
                            self.viewModel.sendErrorWithID(api_token: HDDeclare.shared.api_token!, option_id_str: optionIdStr, parent_id: self.articleID!, cate_id: self.typeID!, content: self.textView.text, uoload_img: self.imgPathArr, self)
                        }
                    }) { (errorCode, msg) in
//                        hud.hide()
                        loadingView?.removeFromSuperview()
                        HDAlert.showAlertTipWith(type: HDAlertType.error, text: "上传失败!")
                    }
                }
            }
        }else {
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        self.countL.text =  "\(self.textNum)/\(TOTAL_NUM)"
    }
    
    //MARK: ----
    
    //键盘的出现
    @objc func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        //let changeY = kbRect.origin.y - SCREEN_HEIGHT
        //键盘的高度
        let kbHeight = kbRect.size.height
        //        keyBoardH = kbHeight
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect.init(x: 0, y: -ScreenWidth*0.5, width: self.view.width, height: self.view.height)
            
        }
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.view.frame = CGRect.init(x: 0, y: CGFloat(kTopHeight), width: self.view.width, height: self.view.height)
            
        }
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
