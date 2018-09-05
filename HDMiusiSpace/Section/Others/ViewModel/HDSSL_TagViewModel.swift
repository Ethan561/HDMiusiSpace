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
    func request_getLaunchTagList(_ vc: UIViewController)  {
        
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
            
        }) { (errorCode, msg) in
            //            self.showEmptyView.value = true
        }
    }
}
