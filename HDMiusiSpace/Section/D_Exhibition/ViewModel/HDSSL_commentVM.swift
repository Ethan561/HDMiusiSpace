//
//  HDSSL_commentVM.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

class HDSSL_commentVM: NSObject {
    //未评论列表
    var dataList: Bindable = Bindable([HDSSL_uncommentModel]())
    //请求
    func request_getNerverCommentList(skip: Int,take: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getHeartedButCommentList(api_token: HDDeclare.shared.api_token!, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: HDSSL_commentModel = try! jsonDecoder.decode(HDSSL_commentModel.self, from: result)

            self.dataList.value = model.data!
            
            
        }) { (errorCode, msg) in
            //
        }
        
    }
}
