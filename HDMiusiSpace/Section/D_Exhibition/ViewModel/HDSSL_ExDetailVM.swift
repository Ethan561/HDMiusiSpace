//
//  HDSSL_ExDetailVM.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/15.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

class HDSSL_ExDetailVM: NSObject {
    //展览详情的所有数据
    var exhibitionData: Bindable = Bindable(ExhibitionDetailDataModel())
    //请求展览详情的数据
    func request_getExhibitionDetail(exhibitionId: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getExhibitionDetail(exhibitionId: exhibitionId), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: ExhibitionDetailDataModel = try! jsonDecoder.decode(ExhibitionDetailDataModel.self, from: result)
            
            self.exhibitionData.value = model
            
            
        }) { (errorCode, msg) in
            //
        }
        
    }
}