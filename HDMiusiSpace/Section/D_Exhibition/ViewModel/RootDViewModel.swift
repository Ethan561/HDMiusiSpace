//
//  RootDViewModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class RootDViewModel: NSObject {
    //展览列表数组
    var exhibitionArray: Bindable = Bindable([HDLY_dExhibitionListD]())
    //博物馆列表数组
    var museumArray: Bindable = Bindable([HDLY_dMuseumListD]())
    
    //请求展览列表
    func request_getExhibitionList(location: String, type: Int, vc: HDItemBaseVC, tableView: UITableView) {

        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionExhibitionList(type: type, skip: 0, take: 20, city_name: "", longitude: "", latitude: "", keywords: "") , showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:HDLY_dExhibitionListM = try! jsonDecoder.decode(HDLY_dExhibitionListM.self, from: result)
            self.exhibitionArray.value = model.data
            
        }) { (errorCode, msg) in
//            tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
//            tableView.ly_showEmptyView()
        }
        
    }
    //请求博物馆列表
    func request_getMuseumList(location: String,type: Int,vc: HDItemBaseVC) {
        print(location)
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: 0, take: 20, city_name: "", longitude: "", latitude: "", keywords: "", api_token: token), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model: HDLY_dMuseumListM = try! jsonDecoder.decode(HDLY_dMuseumListM.self, from: result)
            self.museumArray.value = model.data
  
        }) { (errorCode, msg) in
//            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
//            self.tableView.ly_showEmptyView()
        }
    }
}
