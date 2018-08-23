//
//  ListenDetailViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/22.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class ListenDetailViewModel: NSObject {
    
    var listenDetail: Bindable = Bindable(ListenDetail())
    let commentSuccess: Bindable = Bindable(false)
    let isCollection: Bindable = Bindable(false)
    let likeModel: Bindable = Bindable(LikeModel())
    let isFocus: Bindable = Bindable(false)

    func dataRequestWithListenID(listenID : String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListenDetail(listen_id: listenID, api_token: TestToken), showHud: false, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            //JSON转Model：
            let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
            let model:ListenDetail = try! jsonDecoder.decode(ListenDetail.self, from: dataA)
            self.listenDetail.value = model
            
        }) { (errorCode, msg) in
            
        }
    }
    
    //评论
    func commentCommitRequest(api_token: String, comment: String, id: String, return_id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .commentDocomment(api_token: api_token, comment: comment, id: id, return_id: return_id, cate_id: cate_id), showHud: false, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.commentSuccess.value = true
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "评论成功")
            
        }) { (errorCode, msg) in
            
        }
    }
    //收藏
    func doFavoriteRequest(api_token: String, id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFavoriteRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: vc, success: { (result) in
            
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
    
    //喜欢
    func doLikeRequest(api_token: String, deviceno: String, id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doLikeRequest(id: id, cate_id: cate_id, api_token: api_token, deviceno: deviceno), showHud: false, loadingVC: vc, success: { (result) in
            
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
    
    //关注
    func doFocusRequest(api_token: String, id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 0 {
                    self.isFocus.value = false
                }else {
                    self.isFocus.value = true
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
}




















