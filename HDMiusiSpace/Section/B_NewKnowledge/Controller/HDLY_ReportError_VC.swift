//
//  HDLY_ReportError_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/29.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ReportError_VC: HDItemBaseVC {

    var photoSelectorView: HDLY_PhotoSelectorView!

    @IBOutlet weak var errorBtn1: UIButton!
    @IBOutlet weak var errorBtn2: UIButton!
    @IBOutlet weak var errorBtn3: UIButton!
    @IBOutlet weak var errorBtn4: UIButton!
    @IBOutlet weak var errorBtn5: UIButton!
    @IBOutlet weak var errorBtn6: UIButton!
    
    @IBOutlet weak var imgV: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var textBgView: UIView!
    @IBOutlet weak var textView: HDPlaceholderTextView!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var imgBgView: UIView!
    
    var articleID: String?
    
    var errorModel: ReportErrorModel?
    //MVVM
    let viewModel: ReportErrorViewModel = ReportErrorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        initCollectionView()
        self.title = "报错"
        
        //MVVM
        bindViewModel()
        if articleID != nil {
            viewModel.dataRequestWithListenID(id: articleID!, cate_id: "4", self)
        }
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
        errorBtn3.isHidden = true
        errorBtn4.isHidden = true
        errorBtn5.isHidden = true
        errorBtn6.isHidden = true
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
        imgV.kf.setImage(with: URL.init(string: "img"))
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
        
    
    @IBAction func commitBtnAction(_ sender: UIButton) {
        
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
