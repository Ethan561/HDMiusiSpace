//
//  HDZQ_SignLabelVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_SignLabelVC: UIViewController {

    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var labTitle : UILabel!
    @IBOutlet weak var labDes   : UILabel!
    @IBOutlet weak var tagBgView: UIView!
    @IBOutlet weak var backBtnTopH: NSLayoutConstraint!
    
    public var type = 2
    
    var tagView : HD_SSL_TagView?
    var signLabels = [String]()
    var mySignLabels = [HDSSL_Tag]()
    let viewModel: HDSSL_TagViewModel = HDSSL_TagViewModel()
    var tagList = [HDSSL_Tag]()
    var dataArr = [HDSSL_TagData]()
    var selectedtagArray = [HDSSL_Tag]()             //已选标签字符串数组
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        if type != 2 {
            submitBtn.isHidden  = true
        }
        
        if self.type == 2 {
            self.viewModel.request_getLaunchTagList(self,UIScrollView())
        }else{
            //数据
            self.dataArr = HDDeclare.shared.allTagsArray!
            let tagdatamodel = self.dataArr[(self.type)]  //第三页单选
            
            self.labTitle.text = String.init(format: "%@", (tagdatamodel.title)!)//标题
            self.labDes.text = String.init(format: "%@", (tagdatamodel.des)!)//描述
            
            self.tagList = (tagdatamodel.list)!
            self.tagList.forEach({ (model) in
                guard let title = model.title else { return }
                self.signLabels.append(title)
            })
            self.loadTagView() //加载tag view
        }
        
    }
    //返回请求结果
    func bindViewModel() {
        viewModel.tagModel.bind { [weak self] (tagDataArray) in
            self?.dataArr = tagDataArray  //返回标签数据，需要保存到本地
            HDDeclare.shared.allTagsArray = tagDataArray //保存标签
            
            let tagdatamodel = self?.dataArr[(self?.type)!]  //第三页单选
            
            self?.labTitle.text = String.init(format: "%@", (tagdatamodel?.title)!)
            self?.labDes.text = String.init(format: "%@", (tagdatamodel?.des)!)
            
            self?.tagList = (tagdatamodel?.list)!
            self?.tagList.forEach({ (model) in
                guard let title = model.title else { return }
                self?.signLabels.append(title)
            })
            self?.loadTagView() //加载tag view
        }
    }
    //加载页面数据
    func loadTagView() {
        tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        if type == 2 {
            tagView?.tagViewType = TagViewType.TagViewTypeMultipleSelection
        } else {
            tagView?.tagViewType = TagViewType.TagViewTypeSingleSelection
        }
    
        tagView?.BlockFunc { [weak self] (array) in
            //1、保存选择标签
            print(array)
            
            self?.selectedtagArray.removeAll() //移除所有
            
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)! //标签下标
                
                self?.selectedtagArray.append((self?.tagList[index])!) //保存选择标签
                
            }
            
            
            if self?.type == 0{
                //职业
                HDDeclare.shared.careerTagArray = self?.selectedtagArray //本地保存已选标签
            }else if self?.type == 1 {
                //职业
                HDDeclare.shared.stateTagArray = self?.selectedtagArray //本地保存已选标签
            }else if self?.type == 2 {
                //职业
                HDDeclare.shared.funnyTagArray = self?.selectedtagArray //本地保存已选标签
            }
            

            //下一页
            if self?.type == 2 {
                self?.readyUpload()
            }else {
                //动画效果
                let transition = CATransition.init()
                transition.duration = 0.3
                transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self?.view.window?.layer.add(transition, forKey: nil)
                
                let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_SignLabelVC") as! HDZQ_SignLabelVC
                if  self?.type == 0 {
                    vc.type = 1
                    self?.dismiss(animated: false, completion: nil)
                } else if self?.type == 1 {
                    vc.type = 2
                    self?.dismiss(animated: false, completion: nil)
                }
            }
            
        }
        tagView?.titleArray = signLabels
        tagBgView.addSubview(tagView!)
        tagView?.loadTagsView()
        
    }
    //准备提交数据
    func readyUpload() {
        
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        
        HDDeclare.shared.selectedTagArray = HDDeclare.shared.careerTagArray! + HDDeclare.shared.stateTagArray! + HDDeclare.shared.funnyTagArray!
        
        if HDDeclare.shared.selectedTagArray != nil {
            var tagIds: String? = ""
            
            for i in 0..<HDDeclare.shared.selectedTagArray!.count {
                let model: HDSSL_Tag = HDDeclare.shared.selectedTagArray![i] as HDSSL_Tag
                tagIds = tagIds! + String(model.label_id!) + "#"
            }
            self.request_saveSelectedTags(deviceno: deviceno, label_id_str: tagIds!, self)
        }
    }
    
    //提交
    @IBAction func confirmAction(_ sender: Any) {

        tagView?.getBackSelectedTags()
        
    }
    //返回
    @IBAction func action_back(_ sender: UIButton) {
        
        let transition = CATransition.init()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        
        //上一页，动画效果
        let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_SignLabelVC") as! HDZQ_SignLabelVC
        if  self.type == 2 {
            vc.type = 1
            
            self.present(vc, animated: false, completion: nil)
        } else if  self.type == 1{
            vc.type = 0
            
            self.present(vc, animated: false, completion: nil)
        }else{
            backToRootVC()
        }
        
    }
    //返回根控制器
    func backToRootVC() {
        //获取根VC
        var rootVC = self.presentingViewController
        while let parent = rootVC?.presentingViewController {
            rootVC = parent
        }
        //释放所有下级视图
        rootVC?.dismiss(animated: false, completion: nil)
    }
    //请求数据
    func request_saveSelectedTags(deviceno : String,label_id_str: String,_ vc:UIViewController) {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .saveSelectedTags(api_token: token, label_id_str: label_id_str, deviceno: deviceno), success: { (result) in
            //
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let arr:Array<String> = dic!["data"] as! Array<String>
            if arr.count > 0 {
                let tags = NSSet.init(array: arr)
                JPUSHService.setTags(tags as? Set<String>, completion: nil, seq: 1)
            }
            HDDeclare.shared.labStr?.removeAll()

            //保存个人信息
            if (HDDeclare.shared.funnyTagArray?.count)! > 0 {
                HDDeclare.shared.funnyTagArray!.forEach({ (m) in
                    HDDeclare.shared.labStr?.append(m.title!)//个人信息标签只显示兴趣
                })
            }
            
            HDDeclare.shared.selectedTagArray?.removeAll()
            HDAlert.showAlertTipWith(type: .onlyText, text: "修改成功")
            let delay = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                self.backToRootVC()
            })
            
        }) { (errorCode, msg) in
            //
        }
    }
    
}
