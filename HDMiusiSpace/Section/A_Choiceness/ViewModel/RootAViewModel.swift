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
    var isNeedRefresh: Bindable = Bindable(false)
    var bannerArr =  Bindable([BbannerModel]())
    
    //
    func dataRequest(deviceno : String, myTableView: UITableView , _ vc: HDItemBaseVC)  {
        myTableView.ly_startLoading()
        var token:String = ""
        if HDDeclare.shared.api_token !=  nil {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .choicenessHomeRequest(api_token: token, deviceno: deviceno), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            myTableView.ly_endLoading()
            
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            do {
                let model:ChoicenessModel = try jsonDecoder.decode(ChoicenessModel.self, from: result)
                self.rootAData.value = model
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
            myTableView.es.stopPullToRefresh()
            myTableView.es.stopLoadingMore()
            
        }) { (errorCode, msg) in
            let empV = EmptyConfigView.NoNetworkEmptyView()
            myTableView.ly_emptyView = empV
            myTableView.ly_endLoading()
            myTableView.es.stopPullToRefresh()
        }
    }
    
    @objc func refreshAction() {
        self.isNeedRefresh.value = true
    }
    
    
    func dataRequestGetMoreNews(deviceno : String, num: String, myTableView: UITableView , _ vc: HDItemBaseVC)  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .choicenessHomeMoreRequest(api_token: token, deviceno: deviceno, num: num), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:ChoicenessModel = try! jsonDecoder.decode(ChoicenessModel.self, from: result)
            if model.data != nil && self.rootAData.value.data != nil {
                if (model.data?.count)! > 0 {
                    self.rootAData.value.data! += model.data!
                    myTableView.es.stopLoadingMore()
                } else {
                    myTableView.es.noticeNoMoreData()
                }
            } else {
            }
        }) { (errorCode, msg) in
            myTableView.es.stopLoadingMore()
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









