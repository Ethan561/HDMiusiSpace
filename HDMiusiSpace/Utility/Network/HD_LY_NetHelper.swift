//
//  HD_LY_NetHelper.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Moya
import Alamofire

//错误码 根据台数据确定
let Status_Code_Success = 1
let Status_Code_Success1 = 200

let Status_Code_Error   = 0
let Status_Code_ErrorToken = 405

let Status_Code_NoLocation = -1

let Status_Code_WrongFloor = -2

let Status_Code_ErrorId = -3

class ResponseModel: Decodable {
    var status : Int
    var msg    : String
}

/*
 - Parameters:
 - API: 要使用的moya请求枚举（TargetType）
 - target: TargetType里的枚举值
 - cache: 是否缓存
 - success: 成功的回调
 - error:  连接服务器成功但是数据获取失败
 - failure: 连接服务器失败
 */

let netReacMhanager = NetworkReachabilityManager.init()

class HD_LY_NetHelper {
    
    //显示弹窗显示在VC上
    class func loadData<Tar: TargetType>(API: Tar.Type, target: Tar, cache: Bool = false, showHud: Bool = true ,showErrorTip: Bool = true, loadingVC:UIViewController? = nil , success: @escaping((Data) -> Void), failure: ((Int?, String) ->Void)? ) {
        
        //默认参数初始化
        //let provider = MoyaProvider<Tar>()
        let provider = MoyaProvider<Tar>(plugins: [AuthPlugin()])
        
        //是否需要缓存操作
        var loadingView: HDLoadingView?
        //显示网络请求加载提醒
        if showHud == true {
            DispatchQueue.main.async {
                guard let vc = loadingVC else {
                    return
                }
                loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
                loadingView?.frame = vc.view.bounds
                vc.view.addSubview(loadingView!)
            }
        }
        
        if netReacMhanager!.isReachable == false {
            
        }
        
        provider.request(target) { (result) in
            //隐藏加载提醒
            loadingView?.removeFromSuperview()
            
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    let baseModel = try? decoder.decode(ResponseModel.self, from: response.data)
                    guard let model = baseModel else {
                        if let failureBlack = failure {
                            failureHandle(failure: failure, stateCode: response.statusCode, message: "接口异常:\(response.statusCode)")
                        }
                        return
                    }
                    //
                    switch model.status {
                    //请求成功
                    case Status_Code_Success,Status_Code_Success1 :
                        success(response.data)
                    //失败
                    case Status_Code_Error:
                        
                        failureHandle(failure: failure, stateCode: nil, message: model.msg)
                    //ErrorToken
                    case Status_Code_ErrorToken:
                        
                        failureHandle(failure: failure, stateCode: Status_Code_ErrorToken, message: "登录过期，请重新登录")
                        UserDefaults.standard.set("", forKey: kLogin_Token)
                        HDDeclare.shared.api_token = ""
                        HDDeclare.shared.loginStatus = .kLogin_Status_Logout
                        
                    default:
                        //其他错误
                        failureHandle(failure: failure, stateCode: response.statusCode, message: model.msg)
                        break
                    }
                }
                    
                catch let error {
                    guard let error = error as? MoyaError else { return }
                    let statusCode = error.response?.statusCode ?? 0
                    let errorCode = "请求出错，错误码：" + String(statusCode)
                    failureHandle(failure: failure, stateCode: statusCode, message: error.errorDescription ?? errorCode)
                }
                
            case .failure(_):
                failureHandle(failure: failure, stateCode: nil, message: "网络异常")
            }
        }
        
        //错误处理 - 弹出错误信息
        func failureHandle(failure: ((Int?, String) ->Void)? , stateCode: Int?, message: String) {
            if showErrorTip {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: message)
            }
            if let failureBlack = failure {
                failureBlack(nil ,message)
            }
        }
    }
    
}


extension HD_LY_NetHelper {
    
    //Dictionary转Data 的方法
    public class func jsonToData(jsonDic:Dictionary<String, Any>) ->Data?{
        if (!JSONSerialization.isValidJSONObject(jsonDic)) {
            LOG("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: jsonDic, options: [])
        //Data转换成String打印输出
        _ = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        //        print("Json Str:\(str!)")
        return data
    }
    
    //Data转Dictionary
    public class func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch _{
            //            print("Data转Dictionary 失败")
            return nil
        }
    }
    
    // MARK： 定义枚举类型
    public enum RequestType: Int {
        case GET
        case POST
    }
    
    public class func alamofireRequest(methodType:RequestType, url:String, parameters:[String:AnyObject]?, finished:@escaping (_ result : AnyObject?, _ error: NSError?) -> ()){
        
        //1、定义请求结果回调闭包
        let resultCallBack = { (response: DataResponse<Any>) in
            if response.result.isSuccess {
                finished(response.result.value as AnyObject?, nil)
            }else {
                finished(nil, response.result.error as NSError?)
            }
        }
        
        //2、请求数据
        let httpMethod:HTTPMethod = methodType == .GET ? .get : .post
        Alamofire.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: resultCallBack)
        
    }
}

// -- alamofireRequest 请求示例 ----
/*
 func requestMapPoiInfo() -> Void {
 let requestStr =  HDDeclare.IP_Request_Header() + "/api/map/get_exhibit_list_by_map"
 let paramas = ["p" : "i" ,"floor_num" : self.myFloor!] as [String : AnyObject]
 
 HD_LY_NetHelper.alamofireRequest(methodType: .GET, url: requestStr, parameters: paramas) { (result, error) in
 if error == nil {//请求成功
 let dic:NSDictionary = result as! NSDictionary
 print("获取的Poi = \(dic)")
 if dic["status"] as! Int == 1 {
 let tempArr = NSMutableArray.init()
 let dataArr: NSArray? = dic["data"] as? NSArray
 if dataArr != nil {
 for dic in dataArr! {
 let model : HD_NKM_Map_Obj = HD_NKM_Map_Obj.mapPoi(withDict: dic as! [AnyHashable : Any])
 tempArr.add(model)
 }
 self.poiArray = tempArr
 self.showAllAnn(mapTemp: self.mapView!)
 }
 }
 
 }else {//请求失败
 
 }
 }
 }
 */

