//
//  ReportErrorViewModel.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/29.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class ReportErrorViewModel: NSObject {
    
    var reportErrorModel: Bindable = Bindable(ReportErrorModel())
    
    //(cate_id):报错分类1课程,2轻听随看,3看展,4资讯,5评论举报
    func dataRequestWithListenID(id: String, cate_id: String, _ vc: HDItemBaseVC)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getErrorOption(id: id, cate_id: cate_id), showHud: true, loadingVC: vc, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            let model:ReportErrorModel = try! jsonDecoder.decode(ReportErrorModel.self, from: result)
            self.reportErrorModel.value = model
            
        }) { (errorCode, msg) in
            
        }
    }
    
    //cate_id: 操作类型1课程,2轻听随看,3看展,4资讯
    func sendErrorWithID(api_token: String, option_id_str: String, parent_id: String, cate_id: String, content: String, uoload_img: Array<String>, _ vc: HDItemBaseVC)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .sendError(api_token: api_token, option_id_str: option_id_str, parent_id: parent_id, cate_id: cate_id, content: content, uoload_img: uoload_img), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            HDAlert.showAlertTipWith(type: .onlyText, text: "提交成功")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                vc.navigationController?.popViewController(animated: true)
            })
            
        }) { (errorCode, msg) in
            
        }
    }
}

















