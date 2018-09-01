//
//  RootAViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/1.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class RootAViewModel: NSObject {
    
    var rootAData: Bindable = Bindable(ChoicenessModel())
    let showEmptyView: Bindable = Bindable(false)
    var bannerArr =  Bindable([BbannerModel]())

    //
    func dataRequest(deviceno : String, _ vc: HDItemBaseVC)  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .choicenessHomeRequest(api_token: token, deviceno: deviceno), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.showEmptyView.value = false
            
            let jsonDecoder = JSONDecoder()
            let model:ChoicenessModel = try! jsonDecoder.decode(ChoicenessModel.self, from: result)
            self.rootAData.value = model
            
        }) { (errorCode, msg) in
            self.showEmptyView.value = true
        }
    }
    
    func dataRequestForBanner()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getChoicenessHomeBanner(), showHud: false, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            
            var bannerArr =  [BbannerModel]()
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    let model:BbannerModel = try! jsonDecoder.decode(BbannerModel.self, from: dataA)
                    bannerArr.append(model)
                }
                self.bannerArr.value = bannerArr
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
}









