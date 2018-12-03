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
    
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        
        tagView.BlockFunc { (array) in
            //1、保存选择的标签
            print(array)
            for i: Int in 0..<array.count {
                
                let index : Int = Int(array[i] as! String)!       //标签下标
                
                self.selectedtagArray.append(self.tagList[index]) //保存选择标签
            }
            
            //2、跳转vc
            self.performSegue(withIdentifier: "HD_PushToChooseVCLine", sender: nil)
        }
        tagView.titleArray = tagStrArray
        
        tagBgView.addSubview(tagView)
        tagView.loadTagsView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //
    @IBAction func action_back(_ sender: UIButton) {
        self.dismiss(animated: true) {
            //
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HD_PushToChooseVCLine" {
            
            let vc:HDTagChooseVC = segue.destination as! HDTagChooseVC
            vc.selectedtagArray = selectedtagArray
        }
    }

}
