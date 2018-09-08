//
//  HDSSL_SearchViewModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/7.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import Foundation
class HDSSL_SearchViewModel: NSObject {
    //标签数组
    var tagArray: Bindable = Bindable([HDSSL_SearchTag]())
    
    //请求标签
    func request_getTags(vc: HDItemBaseVC) {
        //
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getSearchTypes(), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: HDSSL_searchTagModel = try! jsonDecoder.decode(HDSSL_searchTagModel.self, from: result)
            self.tagArray.value = model.data!
            
            
        }) { (errorCode, msg) in
            //
        }
    }
    //搜索
    func request_search(_ str: String,vc: HDItemBaseVC) {
        print(str)
    }
}
