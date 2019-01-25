//
//  HDTagChooseStateVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseStateVC: UIViewController {

    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labDes: UILabel!
    
    @IBOutlet weak var tagBgView: UIView!
    
    var tagStrArray : [String] = Array.init()        //标签字符串数组
    var selectedtagArray = [HDSSL_Tag]()             //已选标签字符串数组
    var dataArr = [HDSSL_TagData]()                  //标签类别数组
    var tagList = [HDSSL_Tag]()                      //标签数组
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //加载数据
        loadMyDatas()
        
        //加载标签
        loadTagView()
        //noti,返回重选
        NotificationCenter.default.addObserver(self, selector: #selector(NowResetTags), name: NSNotification.Name(rawValue: "resetSelectedStateTags"), object: nil)
    }
    
    //初始化标签数据
    func loadMyDatas() {
        //
        guard HDDeclare.shared.allTagsArray != nil else {
            return
        }
        
        dataArr = HDDeclare.shared.allTagsArray!//所有标签
        
        let tagdatamodel = dataArr[1] //第二页单选
        
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
        tagview.tagViewType = TagViewType.TagViewTypeSingleSelection
        tagview.userTagType = UserTagType.UserTagTypeState
        
        tagview.BlockFunc { (array) in
            //1、保存选择的标签
            print(array)
            
            self.selectedtagArray.removeAll() //移除所有
            
            for i: Int in 0..<array.count {
                
                let index : Int = Int(array[i] as! String)!       //标签下标
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            
            HDDeclare.shared.stateTagArray = self.selectedtagArray //本地保存已选标签
            
            //2、跳转vc
//            self.performSegue(withIdentifier: "HD_PushToChooseVCLine", sender: nil)
            let transition = CATransition.init()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window?.layer.add(transition, forKey: nil)
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HDTagChooseVC") as! HDTagChooseVC
            
            self.present(vc, animated: false, completion: nil)
        }
        return tagview
    }()
    func loadTagView() {
        tagView.titleArray = tagStrArray
        
        tagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }
    //MARK:--单选标签可以重置，多选标签不可重置
    @objc func NowResetTags(){
        print(selectedtagArray)
        
        let dataArr = HDDeclare.shared.stateTagArray!//已选职业标签
        
        var arr:[String] = Array.init()
        
        for i in 0..<dataArr.count {
            
            let sele = dataArr[i] //已选标签
            
            for i in 0..<tagList.count {
                
                let item = tagList[i]
                
                if item.label_id == sele.label_id { //找到已选标签位置
                    print(i)
                    arr.append(String(i))
                }
            }
        }
        
        tagView.reloadMySelectedTags(arr) //重置
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    @IBAction func action_back(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetSelectedCareerTags"), object: selectedtagArray)
        
//        self.dismiss(animated: true) {
//            //
//        }
        let transition = CATransition.init()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }

}
