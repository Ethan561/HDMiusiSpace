//
//  HDZQ_MyViewModel.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyViewModel: NSObject {
    
    var follows: Bindable = Bindable([MyFollowModel]())
    func requestMyFollow(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFollow(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyFollowData = try! jsonDecoder.decode(MyFollowData.self, from: result)
            self.follows.value = model.data
        }) { (errorCode, msg) in

        }
    }
    
    var collectNews: Bindable = Bindable([HDSSL_SearchNews]())
    func requestMyCollectNews(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFavoriteNews(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectNewsData = try! jsonDecoder.decode(MyCollectNewsData.self, from: result)
            self.collectNews.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    
    var collectExhibitions: Bindable = Bindable([HDLY_dExhibitionListD]())
    func requestMyCollectExhibitions(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFavoriteExhibition(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:HDLY_dExhibitionListM = try! jsonDecoder.decode(HDLY_dExhibitionListM.self, from: result)
            self.collectExhibitions.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    
    var collectCourses: Bindable = Bindable([MyCollectCourseModel]())
    func requestMyCollectCourses(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFavoriteCourses(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectCourseData = try! jsonDecoder.decode(MyCollectCourseData.self, from: result)
            self.collectCourses.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    
    var bugCourses: Bindable = Bindable([MyCollectCourseModel]())
    func requestMyBuyCourses(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyBuyCourses(api_token:apiToken , skip:skip, take:take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectCourseData = try! jsonDecoder.decode(MyCollectCourseData.self, from: result)
            self.bugCourses.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    
    var studyCourses: Bindable = Bindable([MyCollectCourseModel]())
    func requestMyStudyCourses(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyStudyCourses(api_token:apiToken , skip:skip, take:take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectCourseData = try! jsonDecoder.decode(MyCollectCourseData.self, from: result)
            self.studyCourses.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    //我的钱包
    var goodsData: Bindable = Bindable(GoodsData())
    func requestMyWalletData(apiToken:String,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyWallet(api_token: apiToken), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            let model:HDSSL_goodsModel = try! jsonDecoder.decode(HDSSL_goodsModel.self, from: result)
            self.goodsData.value = model.data!
            
        }) { (errorCode, msg) in
            
        }
    }
    
}

