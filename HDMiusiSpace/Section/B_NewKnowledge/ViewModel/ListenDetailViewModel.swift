//
//  ListenDetailViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/22.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class ListenDetailViewModel: NSObject {
    
    var listenDetail: Bindable = Bindable(ListenDetail())
    let showEmptyView: Bindable = Bindable(false)
    
    func dataRequestWithListenID(listenID : String, _ vc: HDItemBaseVC)  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListenDetail(listen_id: listenID, api_token: token), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.showEmptyView.value = false

            let jsonDecoder = JSONDecoder()
            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            //JSON转Model：
            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
            let model:ListenDetail = try! jsonDecoder.decode(ListenDetail.self, from: dataA)
            self.listenDetail.value = model
            
        }) { (errorCode, msg) in
            self.showEmptyView.value = true
        }
    }
    
    func listenedNumAdd(listenID : String)  {

        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListenedNumAdd(listen_id: listenID), showHud: false,showErrorTip: false, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            
        }) { (errorCode, msg) in
            
        }
    }
    
}







