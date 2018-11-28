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
        self.viewModel.request_getLaunchTagList(self)
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
        
        if HDDeclare.shared.deviceno != nil {
            
        }
        
        if self.mySignLabels.count > 0 {
            
            var tagIds: String? = ""
            
            for i in 0..<self.mySignLabels.count {
                
                let model: HDSSL_Tag = self.mySignLabels[i] as HDSSL_Tag
                
                tagIds = tagIds! + String(model.label_id!) + "#"
                
            }
            
            //调用接口
            HDSSL_TagViewModel().request_saveSelectedTags(deviceno: HDDeclare.shared.deviceno!, label_id_str: tagIds!, self)
            
        }
    }
    @IBAction func confirmAction(_ sender: Any) {
        self.mySignLabels.removeAll()
         tagView?.getBackSelectedTags()
    }
    @IBAction func action_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
