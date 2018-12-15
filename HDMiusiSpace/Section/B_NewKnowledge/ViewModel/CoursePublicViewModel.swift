//
//  CoursePublicViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class CoursePublicViewModel: NSObject {
    
    let commentSuccess: Bindable = Bindable(false)
    let isCollection: Bindable = Bindable(false)
    let likeModel: Bindable = Bindable(LikeModel())
    let isFocus: Bindable = Bindable(false)
    // 订单x信息
    let orderBuyInfo: Bindable = Bindable(OrderBuyInfoData())
    let orderResultInfo: Bindable = Bindable(OrderResultData())
    
    //评论（cate_id：类型id，1资讯，2轻听随看，3看展评论,4精选专题）
    func commentCommitRequest(api_token: String, comment: String, id: String, return_id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .commentDocomment(api_token: api_token, comment: comment, id: id, return_id: return_id, cate_id: cate_id), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.commentSuccess.value = true
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "评论成功")
            
        }) { (errorCode, msg) in
            
        }
    }
    
    //收藏（cate_id：分类id,1日卡,2资讯,3课程,4轻听随看,5看展,6精选专题）
    func doFavoriteRequest(api_token: String, id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFavoriteRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_favorite:Int = (dic!["data"] as! Dictionary)["is_favorite"] {
                if is_favorite == 0 {
                    self.isCollection.value = false
                }else {
                    self.isCollection.value = true
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    //点赞（cate_id：操作类型2资讯,3课程，4轻听随看，5评论点赞,6看展点赞,7留言点赞,8问答点赞,9精选专题点赞）
    func doLikeRequest( id: String, cate_id: String, _ vc: UIViewController)  {
        
        var token :String = ""
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doLikeRequest(id: id, cate_id: cate_id, api_token: token, deviceno: deviceno), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let dataDic:Dictionary<String,Any> = dic?["data"] as? Dictionary {
                let jsonDecoder = JSONDecoder()
                //JSON转Model：
                let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                let model:LikeModel = try! jsonDecoder.decode(LikeModel.self, from: dataA)
                self.likeModel.value = model
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
        }) { (errorCode, msg) in
            
        }
    }
    
    //关注（cate_id：1平台，2教师,3用户）
    func doFocusRequest(api_token: String, id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 0 {
                    self.isFocus.value = false
                } else {
                    self.isFocus.value = true
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    //获得购买信息
    func orderGetBuyInfoRequest(api_token: String, cate_id: Int, goods_id: Int, _ vc: UIViewController)  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .orderGetBuyInfo(cate_id: cate_id, goods_id: goods_id, api_token: api_token), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dic!)!
            let model:OrderBuyInfoModel = try! jsonDecoder.decode(OrderBuyInfoModel.self, from: dataA)
            if model.data != nil {
                self.orderBuyInfo.value = model.data!
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
    // 04创建订单
    /*
     cate_id: 订单类型1购买课程，2购买普通展览，3购买景区导览，4购买vip,5充值空间币
     goods_id: 要购买的商品id(课程id,导览id博物馆id,vip购买id，空间币充值id)
     pay_type: 支付方式1空间币支付2支付宝3微信
     */
    
    func createOrderRequest(api_token: String, cate_id: Int, goods_id: Int, pay_type: Int, _ vc: UIViewController)  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .orderCreateOrder(cate_id: cate_id, goods_id: goods_id, pay_type: pay_type, api_token: api_token), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dic!)!
            let model:OrderResultModel = try! jsonDecoder.decode(OrderResultModel.self, from: dataA)
            if model.data != nil {
                self.orderResultInfo.value = model.data!
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    var reportErrorModel: Bindable = Bindable(ReportErrorModel())
    
    //获取举报相关内容
    func getErrorContent( commentId: Int)  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getErrorOption(id: String(commentId), cate_id: "5"), success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            let model:ReportErrorModel = try! jsonDecoder.decode(ReportErrorModel.self, from: result)
            self.reportErrorModel.value = model
        }) { (errorCode, msg) in
            
        }
    }
    
    //对评论内容进行举报
    func reportCommentContent(api_token: String, option_id_str: String, comment_id: Int)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .commentReportOption(api_token: api_token, comment_id: comment_id, option_id_str: option_id_str), success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
           
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "举报成功")
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
}








