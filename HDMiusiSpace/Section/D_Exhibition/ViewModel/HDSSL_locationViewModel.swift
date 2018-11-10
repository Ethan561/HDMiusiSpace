//
//  HDSSL_locationViewModel.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/8.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation
class HDSSL_locationViewModel: NSObject {
    //城市数组
    var cityArray: Bindable = Bindable([CitiesModel]())
    var hotAray:Bindable = Bindable([CityModel]())
    
    var leftTableList: Bindable = Bindable([CountyTypeListModel]())
    var countyList: Bindable = Bindable ([CountyListModel]())
    //请求国内城市列表
    func request_getCityList(type: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getCityList(type: type), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: CityDataModel = try! jsonDecoder.decode(CityDataModel.self, from: result)
            
            let dictionary:CityDataSecModel? = model.data!
            
            self.cityArray.value = dictionary!.city_list!
            self.hotAray.value = model.data!.hot_city!
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    
    //请求国际城市列表
    func request_getWorldCityList(kind: Int,type: Int,isrecommand: Bool,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getWorldCityList(kind: kind, type: type), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: CountyDataModel = try! jsonDecoder.decode(CountyDataModel.self, from: result)
            
            let dictionary:CountyDataSecModel? = model.data!
           
            if isrecommand == true {
                self.leftTableList.value = dictionary!.type_list!
            }
            
            self.countyList.value = dictionary!.country_list!
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    
}
