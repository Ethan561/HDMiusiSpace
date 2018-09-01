//
//  HDTagChooseCareerVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDTagChooseCareerVC: UIViewController {

    @IBOutlet weak var TagBgView: UIView!
    
    public var tagArray : [String] = Array.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagArray = ["学生","初入职场","创业者","职场精英","管理层","自由职业者"]
        
        let tagView = HD_SSL_TagView.init(frame: TagBgView.bounds)
        tagView.titleArray = tagArray
        
        TagBgView.addSubview(tagView)
        tagView.loadTagsView()
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
