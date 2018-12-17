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
    var searchPlaceholder: Bindable = Bindable(String())
    
    var tagArray: Bindable = Bindable([HDSSL_SearchTag]())
    var resultArray: Bindable = Bindable([HDSSL_SearchType]())
    
    
    //1请求搜索标题，默认搜索提示信息
    func request_getSearchPlaceholder(vc: HDItemBaseVC) {
        //
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getSearchPlaceholder(), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_searchPlaceholderModel = try jsonDecoder.decode(HDSSL_searchPlaceholderModel.self, from: result)
                
                self.searchPlaceholder.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
    }
    //2请求标签
    func request_getTags(vc: HDItemBaseVC) {
        //
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getSearchTypes(), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_searchTagModel = try jsonDecoder.decode(HDSSL_searchTagModel.self, from: result)
                self.tagArray.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
    }
    //3搜索
    func request_search(str: String,skip: Int,take: Int,type: Int,vc: HDItemBaseVC) {
        print(str)
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .startSearchWith(keyword: str, skip: skip, take: take, searchType: type), success: { (result) in
            //
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_SearchResultModel = try jsonDecoder.decode(HDSSL_SearchResultModel.self, from: result)
                self.resultArray.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            //
        }
    }
}
