//
//  HDSSL_commentVM.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import Foundation

class HDSSL_commentVM: NSObject {
    //未评论列表
    var dataList: Bindable = Bindable([HDSSL_uncommentModel]())
    //发布成功，返回
    var backDic: Bindable = Bindable(HDSSL_commentResultModel())
    //生成画报
    var paperModel: Bindable = Bindable(HDSSL_PaperModel())
    
    //ExComListModel
    var exComListModel: Bindable = Bindable(ExComListModel())
    
    //回复评论结果
    let commentSuccess: Bindable = Bindable(false)
    
    //请求未评论列表
    func request_getNerverCommentList(skip: Int,take: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getHeartedButCommentList(api_token: HDDeclare.shared.api_token!, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_commentModel = try jsonDecoder.decode(HDSSL_commentModel.self, from: result)
                
                self.dataList.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    //发布评论
    func request_PublishCommentWith(exhibitId: Int,star: Int,content: String,uploadImags:[String], _ vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .publishCommentWith(api_token: HDDeclare.shared.api_token!, exhibitId: exhibitId, star: star, content: content, imgsPaths: uploadImags), success: { (result) in
            //
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_backCommentModel = try jsonDecoder.decode(HDSSL_backCommentModel.self, from: result)
                
                self.backDic.value = model.data!
                
                HDAlert.showAlertTipWith(type: .onlyText, text: "发布成功")
            }
            catch let error {
                LOG("解析错误：\(error)")
            }

            
        }) { (errorCode, msg) in
            //
        }
    }

    //生成画报
    func request_createPaper(api_token: String,commentId: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .createPaperWith(api_token: api_token, commentId: commentId), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_PaperModel = try jsonDecoder.decode(HDSSL_PaperModel.self, from: result)
                
                self.paperModel.value = model
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    
    //请求评论列表
    func request_getExhibitionCommentList(type:Int,skip: Int,take: Int,exhibitionID: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getExhibitionCommentList(api_token: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, exhibitionID: exhibitionID), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            
            do {
                let model: HDSSL_commentListModel = try jsonDecoder.decode(HDSSL_commentListModel.self, from: result)
                
                self.exComListModel.value = model.data!
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    
    //回复评论（cate_id：类型id，1资讯，2轻听随看，3看展评论,4精选专题）
    func request_replycommentWith(api_token: String, comment: String, id: String, return_id: String, cate_id: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .commentDocomment(api_token: api_token, comment: comment, id: id, return_id: return_id, cate_id: cate_id), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.commentSuccess.value = true
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "评论成功")
            
        }) { (errorCode, msg) in
            self.commentSuccess.value = false
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "评论失败")
        }
    }
    
}
