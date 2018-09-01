//
//  HDTagChooseVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseVC: UIViewController {

    @IBOutlet weak var tagBgView: UIView!
    
    var tagView : HD_SSL_TagView?
    
    public var tagArray : [String] = Array.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagArray = ["互联网行业","历史","艺术","亲子","文化","科技","美术","教育","文物","展览","文艺","博物馆","音乐","生活娱乐","电影","其他"]
        
        loadTagView()
        
    }
    
    func loadTagView() {
        tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagView?.tagViewType = TagViewType.TagViewTypeMultipleSelection
        
        tagView?.BlockFunc { (array) in
            //
            print(array)
        }
        tagView?.titleArray = tagArray
        
        tagBgView.addSubview(tagView!)
        tagView?.loadTagsView()
    }
    
    @IBAction func action_back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SureAction(_ sender: Any) {
        //1、保存选择的标签
        tagView?.getBackSelectedTags()
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
