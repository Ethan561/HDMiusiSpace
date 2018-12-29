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
    
    var searchResults: Bindable = Bindable([FollowPerModel]())
    func requestSearchResults(apiToken:String,keywords:String,skip:Int,take:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: HD_ZQ_Person_API.getMySearch(api_token:apiToken , keywords:keywords, skip:skip, take:take), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            print("\(dic)")
            let jsonDecoder = JSONDecoder()
            let model:SearResultData = try! jsonDecoder.decode(SearResultData.self, from: result)
            self.searchResults.value = model.data
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
    
    var collectListens: Bindable = Bindable([MyCollectListenModel]())
    func requestMyListens(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFavoriteListens(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectListenData = try! jsonDecoder.decode(MyCollectListenData.self, from: result)
            self.collectListens.value = model.data
        }) { (errorCode, msg) in
            
        }
    }
    
    var collectJingxuans: Bindable = Bindable([MyCollectJingxuanModel]())
    func requestMyCollectJingxuans(apiToken:String,skip:Int,take:Int,type:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target:.getMyFavoriteJingxuan(api_token:apiToken , skip:skip, take:take,type:type), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            let model:MyCollectJingxuanData = try! jsonDecoder.decode(MyCollectJingxuanData.self, from: result)
            self.collectJingxuans.value = model.data
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
            
            do {
                let model:HDSSL_goodsModel = try jsonDecoder.decode(HDSSL_goodsModel.self, from: result)
                self.goodsData.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    //我的订单列表
    var orderList: Bindable = Bindable([MyOrder]())
    func requestMyOrderList(apiToken:String,skip:Int,take:Int,status:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderList(api_token: apiToken, status: status, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:HDSSLMyOrderModel = try jsonDecoder.decode(HDSSLMyOrderModel.self, from: result)
                self.orderList.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    //我的订单详情
    var orderDetail: Bindable = Bindable(OrderDetailModel())
    func requestMyOrderDetail(apiToken:String,orderId:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderDetail(api_token: apiToken, orderId: orderId), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:HDSSLMyOrderDetailModel = try jsonDecoder.decode(HDSSLMyOrderDetailModel.self, from: result)
                self.orderDetail.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    //订单交易记录
    //我的订单详情
    var orderRecordList: Bindable = Bindable([OrderRecordDataModel]())
    func getOrderRecordList(apiToken:String,skip:Int,take:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestOrderRecordList(api_token: apiToken, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:HDSSL_OrderRecordModel = try jsonDecoder.decode(HDSSL_OrderRecordModel.self, from: result)
                self.orderRecordList.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    //我的订单分享图地址
    var orderPicPath: Bindable = Bindable(String())
    func getOrderSharePicPath(apiToken:String,order_id:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .requestMyOrderSharePicPath(api_token: apiToken, orderId: order_id), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:HDSSLMyOrderSharePicModel = try jsonDecoder.decode(HDSSLMyOrderSharePicModel.self, from: result)
                self.orderPicPath.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    //回复评论结果
    let isDeleteOrder: Bindable = Bindable(Int())
    func deleteOrderBy(apiToken:String,order_id:Int,vc:UIViewController) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .deleteMyOrderBy(orderId: order_id, api_token: apiToken), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
    
            do {
                let model:HDSSLDeleteOrderModel = try jsonDecoder.decode(HDSSLDeleteOrderModel.self, from: result)
                self.isDeleteOrder.value = (model.data?.int)!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    
    //MARK: -- 我的关注教师、机构详情 --
    var teacherDynamic: Bindable = Bindable(TeacherDynamicData())
    
    func requestMyFollowForTeacher(apiToken:String, skip:Int, take:Int, teacher_id:Int, vc:UIViewController) {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .dynamicTeacherIndex(teacher_id: teacher_id, api_token: apiToken, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                let model:TeacherDynamic = try jsonDecoder.decode(TeacherDynamic.self, from: result)
                if model.data != nil {
                    self.teacherDynamic.value = model.data!
                }
            }
            catch let error {
                LOG("\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    var platDynamic: Bindable = Bindable(PlatDynamicData())
    
    func requestMyFollowForPlat(apiToken:String, skip:Int, take:Int, platform_id:Int, vc:UIViewController) {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .dynamicPlatIndex(platform_id: platform_id, api_token: apiToken, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:PlatDynamic = try jsonDecoder.decode(PlatDynamic.self, from: result)
                if model.data != nil {
                    self.platDynamic.value = model.data!
                }
            }
            catch let error {
                LOG("\(error)")
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    //分享订单数据
    var orderShareDataModel: Bindable = Bindable(HDSSL_shareOrderModel())
    func getOrderShareDataWith(api_token: String,orderId: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getMyOrderShareData(api_token: api_token, orderId: orderId), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDSSL_shareOrderDataModel = try jsonDecoder.decode(HDSSL_shareOrderDataModel.self, from: result)
                
                self.orderShareDataModel.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
        
    }
}


