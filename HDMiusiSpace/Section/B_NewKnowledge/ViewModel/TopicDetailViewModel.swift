//
//  TopicDetailViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class TopicDetailViewModel: NSObject {
    
    var topicDetail: Bindable = Bindable(TopicModel())
    
    func dataRequestWithTopicID(listenID : String, _ vc: HDItemBaseVC)  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseTopicsInfo(api_token: token, id: listenID), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            
            //JSON转Model：
            let model:TopicModel = try! jsonDecoder.decode(TopicModel.self, from: result)
            self.topicDetail.value = model
            
        }) { (errorCode, msg) in
            
        }
    }
    
}
