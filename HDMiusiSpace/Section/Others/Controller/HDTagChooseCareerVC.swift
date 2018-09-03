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
        
        request_getLaunchTagList()
        
        loadTagView()
        
    }
    
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: TagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        
        tagView.BlockFunc { (array) in
            //1、保存选择标签
            print(array)
            //2、跳转vc
            self.performSegue(withIdentifier: "HD_PushToChooseSateVCLine", sender: nil)
        }
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
extension HDTagChooseCareerVC {
    
    func request_getLaunchTagList()  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getLaunchTagList(api_token: token), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
//            self.showEmptyView.value = false
            
//            let jsonDecoder = JSONDecoder()
//            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            
            //JSON转Model：
//            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
//            let model:ListenDetail = try! jsonDecoder.decode(ListenDetail.self, from: dataA)
//            self.listenDetail.value = model
            
        }) { (errorCode, msg) in
//            self.showEmptyView.value = true
        }
    }
}
