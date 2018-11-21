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
    
    //请求
    func request_getNerverCommentList(skip: Int,take: Int,vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .getHeartedButCommentList(api_token: HDDeclare.shared.api_token!, skip: skip, take: take), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: HDSSL_commentModel = try! jsonDecoder.decode(HDSSL_commentModel.self, from: result)

            self.dataList.value = model.data!
            
            
        }) { (errorCode, msg) in
            //
        }
        
    }
    //fabu
    func request_PublishCommentWith(exhibitId: Int,star: Int,content: String,uploadImags:[String], _ vc: HDItemBaseVC) {
        HD_LY_NetHelper.loadData(API: HD_SSL_API.self, target: .publishCommentWith(api_token: HDDeclare.shared.api_token!, exhibitId: exhibitId, star: star, content: content, imgsPaths: uploadImags), success: { (result) in
            //
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            //JSON转Model：
            let jsonDecoder = JSONDecoder()
            let model: HDSSL_backCommentModel = try! jsonDecoder.decode(HDSSL_backCommentModel.self, from: result)
            
            self.backDic.value = model.data!
            
            HDAlert.showAlertTipWith(type: .onlyText, text: "发布成功")
            
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
//                vc.navigationController?.popViewController(animated: true)
//            })
            
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
            let model: HDSSL_PaperModel = try! jsonDecoder.decode(HDSSL_PaperModel.self, from: result)
            
            self.paperModel.value = model
            
            
        }) { (errorCode, msg) in
            //
        }
        
    }
}
