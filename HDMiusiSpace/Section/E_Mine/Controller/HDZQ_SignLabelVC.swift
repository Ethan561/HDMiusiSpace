//
//  HDZQ_SignLabelVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_SignLabelVC: UIViewController {

    
    @IBOutlet weak var labTitle : UILabel!
    @IBOutlet weak var labDes   : UILabel!
    @IBOutlet weak var tagBgView: UIView!
     var tagView : HD_SSL_TagView?
    var signLabels = [String]()
    var mySignLabels = [HDSSL_Tag]()
    let viewModel: HDSSL_TagViewModel = HDSSL_TagViewModel()
    var tagList = [HDSSL_Tag]()
    var dataArr = [HDSSL_TagData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        self.viewModel.request_getLaunchTagList(self,UIScrollView())
    }
    
    func bindViewModel() {
        viewModel.tagModel.bind { [weak self] (tagDataArray) in
            self?.dataArr = tagDataArray  //返回标签数据，需要保存到本地
            HDDeclare.shared.allTagsArray = tagDataArray //保存标签
            let tagdatamodel = self?.dataArr[2]  //第三页单选
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
        tagView?.tagViewType = TagViewType.TagViewTypeMultipleSelection
        
        tagView?.BlockFunc { [weak self] (array) in
            //1、保存选择标签
            print(array)
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)!       //标签下标
                let m = self?.tagList[index]
                self?.mySignLabels.append(m!) //保存选择标签
                
            }
            self?.uploadMyTags()
            HDDeclare.shared.selectedTagArray = self?.mySignLabels
            
        }
        tagView?.titleArray = signLabels
        tagBgView.addSubview(tagView!)
        tagView?.loadTagsView()
    }
    
    func uploadMyTags() {
        //
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        
        if self.mySignLabels.count > 0 {
            
            var tagIds: String? = ""
            
            for i in 0..<self.mySignLabels.count {
                
                let model: HDSSL_Tag = self.mySignLabels[i] as HDSSL_Tag
                
                tagIds = tagIds! + String(model.label_id!) + "#"
                
            }
            //调用接口
           self.request_saveSelectedTags(deviceno: deviceno, label_id_str: tagIds!, self)
            
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
            self.mySignLabels.forEach({ (m) in
                HDDeclare.shared.labStr?.append(m.title!)
            })
            
            
            HDAlert.showAlertTipWith(type: .onlyText, text: "修改成功")
            let delay = DispatchTime.now() + DispatchTimeInterval.seconds(1)
           

            DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                self.dismiss(animated: true, completion: nil)
            })
            
            
        }) { (errorCode, msg) in
            //
        }
    }
    
}
