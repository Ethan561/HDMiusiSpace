//
//  HDTagChooseCareerVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseCareerVC: UIViewController {

    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_des  : UILabel!
    @IBOutlet weak var TagBgView: UIView!
    
    var tagStrArray : [String] = Array.init()        //标签字符串数组
    var selectedtagArray = [HDSSL_Tag]()             //已选标签字符串数组
    var dataArr = [HDSSL_TagData]()                  //标签类别数组
    var tagList = [HDSSL_Tag]()                      //标签数组
    
    //MVVM
    let viewModel: HDSSL_TagViewModel = HDSSL_TagViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MVVM
        bindViewModel()
        //获取启动标签
        self.viewModel.request_getLaunchTagList(self)
        
    }
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        viewModel.tagModel.bind { (tagDataArray) in
            
            weakSelf?.dataArr = tagDataArray  //返回标签数据，需要保存到本地
            
            HDDeclare.shared.allTagsArray = tagDataArray //保存标签
            
            let tagdatamodel = weakSelf?.dataArr[0]  //第一页单选
            
            
            weakSelf?.lab_title.text = String.init(format: "%@", (tagdatamodel?.title)!)
            weakSelf?.lab_des.text = String.init(format: "%@", (tagdatamodel?.des)!)
            weakSelf?.tagList = (tagdatamodel?.list)!
            
            //显示标签标题
            for i:Int in 0..<(weakSelf?.tagList.count)! {
                let tagmodel = weakSelf?.tagList[i]
                weakSelf?.tagStrArray.append((tagmodel?.title)!)
            }
            
            weakSelf?.loadTagView() //加载tag view
        }
    }
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: TagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        
        tagView.BlockFunc { (array) in
            //1、保存选择标签
            print(array)
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)! //标签下标
//                let str : String = self.tagStrArray[index] //
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            
            
            //2、跳转vc
            self.performSegue(withIdentifier: "HD_PushToChooseSateVCLine", sender: nil)
        }
        tagView.titleArray = tagStrArray  //
        
        TagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HD_PushToChooseSateVCLine" {

        }
    }
}

