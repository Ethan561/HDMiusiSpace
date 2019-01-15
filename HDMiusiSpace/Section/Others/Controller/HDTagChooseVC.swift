//
//  HDTagChooseVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseVC: UIViewController {


    @IBOutlet weak var labTitle : UILabel!
    @IBOutlet weak var labDes   : UILabel!
    @IBOutlet weak var tagBgView: UIView!
        
    public var tagArray : [String] = Array.init()
    
    var tagStrArray : [String] = Array.init()        //标签字符串数组
    var selectedtagArray = [HDSSL_Tag]()             //已选标签字符串数组
    var careerArray = [HDSSL_Tag]()                  //已选职业标签字符串数组
    var dataArr = [HDSSL_TagData]()                  //标签类别数组
    var tagList = [HDSSL_Tag]()                      //标签数组
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyDatas()
        
        loadTagView()
        
    }
    //初始化标签数组
    func loadMyDatas() {
        //
        guard HDDeclare.shared.allTagsArray != nil else {
            return
        }
        dataArr = HDDeclare.shared.allTagsArray!
        
        let tagdatamodel = dataArr[2] //第三页多选
        
        self.labTitle.text = String.init(format: "%@", tagdatamodel.title!)
        self.labDes.text   = String.init(format: "%@", tagdatamodel.des!)
        self.tagList       = tagdatamodel.list!
        
        //标签标题
        for i:Int in 0..<tagList.count {
            let tagmodel = tagList[i]
            tagStrArray.append(tagmodel.title!)
        }
    }
    lazy var tagView : HD_SSL_TagView = {
        let tagview = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagview.tagViewType = TagViewType.TagViewTypeMultipleSelection
        tagview.userTagType = UserTagType.UserTagTypeFunny
        tagview.BlockFunc { (array) in
            
            //保存选择标签
            for i: Int in 0..<array.count {
                
                let index : Int = Int(array[i] as! String)!       //标签下标
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            HDDeclare.shared.funnyTagArray = self.selectedtagArray //本地保存已选标签
            
            HDDeclare.shared.selectedTagArray = HDDeclare.shared.careerTagArray! + HDDeclare.shared.stateTagArray! + self.selectedtagArray
            
            //保存
            if HDDeclare.shared.selectedTagArray!.count > 0 {
                //正式开始
                let userDefaults = UserDefaults.standard
                userDefaults.set("1", forKey: "saveTags")
                userDefaults.synchronize()
            }
            
            self.uploadMyTags() //调接口保存选择的标签
        }
        return tagview
    }()
    func loadTagView() {

        tagView.titleArray = tagStrArray
        
        tagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }
    //MARK: - 上传已选标签
    func uploadMyTags() {
        //
        if HDDeclare.shared.selectedTagArray!.count > 0 {
            
            var tagIds: String? = ""
            
            for i in 0..<HDDeclare.shared.selectedTagArray!.count {
                
                let model: HDSSL_Tag = HDDeclare.shared.selectedTagArray![i] as HDSSL_Tag
                
                tagIds = tagIds! + String(model.label_id!) + "#"
                
            }
            
            //调用接口
            HDSSL_TagViewModel().request_saveSelectedTags(deviceno: HDDeclare.shared.deviceno!, label_id_str: tagIds!, self)
            
        }
    }
    
    @IBAction func action_back(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetSelectedStateTags"), object: nil)
        
//        self.dismiss(animated: true, completion: nil)
        let transition = CATransition.init()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    @IBAction func SureAction(_ sender: Any) {
        //1、保存选择的标签
        tagView.getBackSelectedTags()
        //2、跳转vc
        self.performSegue(withIdentifier: "HD_PushToTabBarVCLine", sender: nil)

    }
    @IBAction func action_showTabVC(_ sender: UIButton) {
        //2、跳转vc
        self.performSegue(withIdentifier: "HD_PushToTabBarVCLine", sender: nil)
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
