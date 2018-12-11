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
    //我的订单列表
    var orderList: Bindable = Bindable([MyOrder]())
    func requestMyOrderList(apiToken:String,skip:Int,take:Int,status:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderList(api_token: apiToken, status: status, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:HDSSLMyOrderModel = try! jsonDecoder.decode(HDSSLMyOrderModel.self, from: result)
            self.orderList.value = model.data!
        }) { (errorCode, msg) in
            
        }
    }
    //我的订单详情
    var orderDetail: Bindable = Bindable(OrderDetailModel())
    func requestMyOrderDetail(apiToken:String,orderId:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderDetail(api_token: apiToken, orderId: orderId), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:HDSSLMyOrderDetailModel = try! jsonDecoder.decode(HDSSLMyOrderDetailModel.self, from: result)
            self.orderDetail.value = model.data!
        }) { (errorCode, msg) in
            
        }
    }
    //订单交易记录
    //我的订单详情
    var orderRecordList: Bindable = Bindable([OrderRecordDataModel]())
    func getOrderRecordList(apiToken:String,skip:Int,take:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestOrderRecordList(api_token: apiToken, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:HDSSL_OrderRecordModel = try! jsonDecoder.decode(HDSSL_OrderRecordModel.self, from: result)
            self.orderRecordList.value = model.data!
        }) { (errorCode, msg) in
            
        }
    }
    //我的订单分享图地址
    var orderPicPath: Bindable = Bindable(String())
    func getOrderSharePicPath(apiToken:String,order_id:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderSharePicPath(api_token: apiToken, orderId: order_id), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:HDSSLMyOrderSharePicModel = try! jsonDecoder.decode(HDSSLMyOrderSharePicModel.self, from: result)
            self.orderPicPath.value = model.data!
        }) { (errorCode, msg) in
            
        }
    }
    
}

