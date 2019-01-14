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
    
    public var type = 0
    
    var tagView : HD_SSL_TagView?
    var signLabels = [String]()
    var mySignLabels = [HDSSL_Tag]()
    let viewModel: HDSSL_TagViewModel = HDSSL_TagViewModel()
    var tagList = [HDSSL_Tag]()
    var dataArr = [HDSSL_TagData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        if type == 0 {
            labTitle.text = "您现在属于"
            labDes.text = "根据选择，为您推荐更可能感兴趣的内容"
            submitBtn.isHidden  = true
        }
        if type == 1 {
            labTitle.text = "您现在状态是"
            labDes.text = "根据选择，为您推荐更可能感兴趣的内容"
            submitBtn.isHidden  = true
        }
        
        self.viewModel.request_getLaunchTagList(self,UIScrollView())
    }
    
    func bindViewModel() {
        viewModel.tagModel.bind { [weak self] (tagDataArray) in
            self?.dataArr = tagDataArray  //返回标签数据，需要保存到本地
            HDDeclare.shared.allTagsArray = tagDataArray //保存标签
            let tagdatamodel = self?.dataArr[(self?.type)!]  //第三页单选
            self?.tagList = (tagdatamodel?.list)!
            self?.tagList.forEach({ (model) in
                guard let title = model.title else { return }
                self?.signLabels.append(title)
            })
            self?.loadTagView() //加载tag view
        }
    }
    
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
           
            if self?.type == 0 {
                HDDeclare.shared.selectedTagArray = [HDSSL_Tag]()
            }
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)!       //标签下标
                let m = self?.tagList[index]
                self?.mySignLabels.append(m!) //保存选择标签
                HDDeclare.shared.selectedTagArray?.append(m!)
            }
            self?.uploadMyTags()
           
            
        }
        tagView?.titleArray = signLabels
        tagBgView.addSubview(tagView!)
        tagView?.loadTagsView()
    }
    
    func uploadMyTags() {
        //
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        
        if HDDeclare.shared.selectedTagArray != nil {
            
            var tagIds: String? = ""
            
            for i in 0..<HDDeclare.shared.selectedTagArray!.count {
                let model: HDSSL_Tag = HDDeclare.shared.selectedTagArray![i] as HDSSL_Tag
                tagIds = tagIds! + String(model.label_id!) + "#"
            }
            
            if self.type == 2 {
                self.request_saveSelectedTags(deviceno: deviceno, label_id_str: tagIds!, self)
            } else {
                let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_SignLabelVC") as! HDZQ_SignLabelVC
                if  self.type == 0 {
                    vc.type = 1
                } else {
                    vc.type = 2
                }
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    @IBAction func confirmAction(_ sender: Any) {
        self.mySignLabels.removeAll()
         tagView?.getBackSelectedTags()
    }
    @IBAction func action_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
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
            HDDeclare.shared.selectedTagArray!.forEach({ (m) in
                HDDeclare.shared.labStr?.append(m.title!)
            })
            HDDeclare.shared.selectedTagArray?.removeAll()
            HDAlert.showAlertTipWith(type: .onlyText, text: "修改成功")
            let delay = DispatchTime.now() + DispatchTimeInterval.seconds(1)
            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                var vc = self.presentingViewController?.presentingViewController?.presentingViewController;
                vc?.dismiss(animated: true, completion: nil)

            })
            
        }) { (errorCode, msg) in
            //
        }
    }
    
}
