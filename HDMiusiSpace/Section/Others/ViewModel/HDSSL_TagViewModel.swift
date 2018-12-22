//
//  HDSSL_TagViewModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/4.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation
class HDSSL_TagViewModel: NSObject {
    //
    var tagModel: Bindable = Bindable([HDSSL_TagData]())
    
    //MARK: - 获取标签
    func request_getLaunchTagList(_ vc: UIViewController,_ tagView: UIScrollView)  {
        
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getLaunchTagList(api_token: token), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")

            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: HDSSL_TagModel = try! jsonDecoder.decode(HDSSL_TagModel.self, from: result)
            self.tagModel.value = model.data!
            
            tagView.ly_hideEmptyView()
            
        }) { (errorCode, msg) in
            
            tagView.ly_showEmptyView()//显示空数据页面
        }
    }
    
    //MARK: - 保存选择标签
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
        }) { (errorCode, msg) in
            //
        }
    }
}
