//
//  HDLY_RootCVM.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/23.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_RootCVM: NSObject {
    
    
    let footprintSuccess: Bindable = Bindable(false)
    
    //足迹上传
    func uploadFootprintRequest(api_token: String, exhibit_id: Int, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .uploadFavoritesFootprint(exhibit_id: exhibit_id, api_token: api_token), showHud: true, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("导览足迹上传 :\(String(describing: dic))")
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
    //学习记录上传
    func uploadCourseRecordsRequest(api_token: String, chapter_id: Int, study_time: String, _ vc: UIViewController)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .uploadCourseRecords(chapter_id: chapter_id, api_token: api_token, study_time: study_time), showHud: false, showErrorTip: false, loadingVC: vc, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("学习记录上传:\(String(describing: dic))")
            
        }) { (errorCode, msg) in
            
        }
    }
    
}











