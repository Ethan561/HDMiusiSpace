//
//  HDTagChooseStateVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseStateVC: UIViewController {

    @IBOutlet weak var tagBgView: UIView!
    public var tagArray : [String] = Array.init()
    
    var tagStrArray : [String] = Array.init()        //标签字符串数组
    var selectedtagArray : [String] = Array.init()   //已选标签字符串数组
    var dataArr = [HDSSL_TagData]()                  //标签类别数组
    var tagList = [HDSSL_Tag]()                      //标签数组
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagArray = ["单身","热恋中","已婚","辣妈奶爸"]
        
        loadTagView()
        
    }
    
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        
        tagView.BlockFunc { (array) in
            //1、保存选择的标签
            print(array)
            //2、跳转vc
            self.performSegue(withIdentifier: "HD_PushToChooseVCLine", sender: nil)
        }
        tagView.titleArray = tagArray
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
