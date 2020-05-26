//
//  HDLY_AccountBind_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import AuthenticationServices

class HDLY_AccountBind_VC: HDItemBaseVC {
    
    @IBOutlet weak var myTableView: UITableView!
    let declare = HDDeclare.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账号绑定设置"
        setupViews()
        
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        myTableView.separatorStyle = .none
        myTableView.backgroundColor = UIColor.HexColor(0xF0F0F0)
        myTableView.isScrollEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushTo_HDLY_SafetyVerifi_VC_Line" {
            let vc:HDLY_SafetyVerifi_VC = segue.destination as! HDLY_SafetyVerifi_VC
            let type :String = sender as! String
            vc.segueType = type
        }
    }
    
    
}

// MARK:--- myTableView -----
extension HDLY_AccountBind_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if #available(iOS 13.0, *) {
            return 6
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == 0 {//修改密码
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.nameL.text = "修改密码"
            cell?.subNameL.text = ""
            cell?.moreImgV.isHidden = false
            return cell!
        }else if index == 1 {//手机号
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.nameL.text = "手机号"
            
            cell?.subNameL.text = declare.phone
            cell?.moreImgV.isHidden = true
            
            let phone = HDDeclare.shared.phone
            guard let foot =  phone?.suffix(4) else { return cell! }
            guard let head =  phone?.prefix(3) else { return cell! }
            cell?.subNameL.text = String(head) + "····" + String(foot)
            
            return cell!
        }
        else if index == 2 {//微信
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.moreImgV.isHidden = true
            cell?.nameL.text = "微信"
            if declare.isBindWechat == 1 {
                cell?.subNameL.text = declare.wechatName
            } else {
                cell?.subNameL.text = "未绑定"
            }
            return cell!
        }else if index == 3 {//新浪微博
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.nameL.text = "新浪微博"
            if declare.isBindWeibo == 1 {
                cell?.subNameL.text = declare.weiboName
            } else {
                cell?.subNameL.text = "未绑定"
            }
            
            cell?.moreImgV.isHidden = true
            return cell!
        }
        else if index == 4 {//QQ
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.nameL.text = "QQ"
            if declare.isBindWeibo == 1 {
                cell?.subNameL.text = declare.QQName
            } else {
                cell?.subNameL.text = "未绑定"
            }
            cell?.moreImgV.isHidden = true
            return cell!
        }
        else if index == 5 {//QQ
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            cell?.nameL.text = "Apple"
            if declare.isBindApple == 1 {
                cell?.subNameL.text = "已绑定"
            } else {
                cell?.subNameL.text = "未绑定"
            }
            cell?.moreImgV.isHidden = true
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//修改密码
                self.performSegue(withIdentifier: "PushTo_HDLY_SafetyVerifi_VC_Line", sender: "1")
            }else if index == 1 {//手机号
                self.performSegue(withIdentifier: "PushTo_HDLY_SafetyVerifi_VC_Line", sender: "2")
            }else if index == 2 {//微信
                if declare.isBindWechat == 1 {
                    self.cancelBindThird(b_from: "wx")
                } else {
                    self.getAuthWithUserInfoWithType(type: .wechatSession)
                }
                
            } else if index == 3 {//微博
                if declare.isBindWeibo == 1 {
                    self.cancelBindThird(b_from: "wb")
                } else {
                    self.getAuthWithUserInfoWithType(type: .sina)
                }
                
            } else if index == 4 {//QQ
                if declare.isBindQQ == 1 {
                    self.cancelBindThird(b_from: "qq")
                } else {
                    self.getAuthWithUserInfoWithType(type: .QQ)
                }
            } else if index == 5 {//Apple
                if declare.isBindApple == 1 {
                    self.cancelBindThird(b_from: "apple")
                } else {
                    self.handleAuthorizationAppleIDButtonPress()
                }
            }
        }
    }
    
    func getAuthWithUserInfoWithType(type: UMSocialPlatformType) {
        
        
        if UMSocialManager.default().isInstall(type) == false {
            HDAlert.showAlertTipWith(type: .onlyText, text: "未安装，无法绑定")
            return
        }
        
        var from = "qq"
        if type == .wechatSession {
            from = "wx"
        }else if type == .sina {
            from = "wb"
        }
        
        UMSocialManager.default().getUserInfo(with: type, currentViewController: self) { (result, error) in
            if error != nil {
                LOG("\(String(describing: error?.localizedDescription))")
                HDAlert.showAlertTipWith(type: .onlyText, text: "绑定失败")
            }else {
                let resp:UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse
                self.thirdLoginRequestWithInfo(resp: resp, from: from)
            }
        }
    }
    
    func handleAuthorizationAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            // 创建新的AppleID 授权请求\
            let appleIDRequest = appleIDProvider.createRequest()
            appleIDRequest.requestedScopes = [.fullName, .email]
            // 在用户授权期间请求的联系信息
            //            appleIDRequest.requestedScopes =  [email] @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController.init(authorizationRequests: [appleIDRequest])
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self;
            
            authorizationController.presentationContextProvider = self
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
        }else{
            // 处理不支持系统版本
            //                   NSLog(@"该系统版本不可用Apple登录");
        }
    }
    
    func thirdLoginRequestWithInfo(resp:UMSocialUserInfoResponse, from: String) {
        let api_token = HDDeclare.shared.api_token ?? ""
        let openid   = resp.uid!
        let b_nickname = resp.name!
        let b_avatar = resp.iconurl ?? ""
        let unionid = resp.unionId ?? ""
        let params: [String: Any] = ["openid": openid,
                                     "b_from": from,
                                     "unionid": unionid,
                                     "b_nickname": b_nickname,
                                     "b_avatar": b_avatar,
                                     "api_token": api_token,
        ]
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .bindThirdAccount(params: params), showHud: true, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" dic ： \(String(describing: dic))")
            guard let data : Int = dic!["data"] as? Int else {
                return
            }
            
            if data == 1 {
                HDAlert.showAlertTipWith(type: .onlyText, text: "绑定成功")
            }
            if from == "wx" {
                self.declare.isBindWechat = 1
                self.declare.wechatName = b_nickname
            }
            if from == "wb" {
                self.declare.isBindWeibo = 1
                self.declare.weiboName = b_nickname
            }
            if from == "qq" {
                self.declare.isBindQQ = 1
                self.declare.QQName = b_nickname
            }
            self.myTableView.reloadData()
        }) { (errorCode, msg) in
            HDAlert.showAlertTipWith(type: .onlyText, text: "绑定失败")
        }
    }
    
    
    func cancelBindThird(b_from:String) {
        var bindString = ""
        if b_from == "wx" {
            bindString = "微信"
        }
        if b_from == "wb" {
            bindString = "微博"
        }
        if b_from == "qq" {
            bindString = "QQ"
        }
        if b_from == "apple" {
            bindString = "苹果"
        }
        if kWindow != nil {
            let logoutTip:HDLY_LogoutTip_View = HDLY_LogoutTip_View.createViewFromNib() as! HDLY_LogoutTip_View
            logoutTip.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            logoutTip.tipTextLabel.text = "确认解除绑定当前\(bindString)账号?"
            logoutTip.tipTextLabel.font = UIFont.systemFont(ofSize: 15.0)
            kWindow!.addSubview(logoutTip)
            logoutTip.sureBlock = {
                logoutTip.removeFromSuperview()
                HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .cancelBindThirdAccount(api_token: HDDeclare.shared.api_token ?? "", b_from: b_from), success: { (result) in
                    let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                    LOG(" dic ： \(String(describing: dic))")
                    guard let data : Int = dic!["data"] as? Int else {
                        return
                    }
                    if data == 1 {
                        HDAlert.showAlertTipWith(type: .onlyText, text: "已解除绑定")
                    }
                    if b_from == "wx" {
                        self.declare.isBindWechat = 0
                    }
                    if b_from == "wb" {
                        self.declare.isBindWeibo = 0
                    }
                    if b_from == "qq" {
                        self.declare.isBindQQ = 0
                    }
                    if b_from == "apple" {
                        self.declare.isBindApple = 0
                    }
                    self.myTableView.reloadData()
                }) { (error, msg) in
                    HDAlert.showAlertTipWith(type: .onlyText, text: "解除绑定失败")
                }
            }
        }
    }
    
}


extension HDLY_AccountBind_VC : ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let user = appleIDCredential.user // 授权的用户唯一标识
            let identityToken = appleIDCredential.identityToken // 授权用户的JWT凭证
            let str = String(data:identityToken!, encoding: String.Encoding.utf8)!
            let array = user.components(separatedBy:".")
            print("字符串转数组:\(array)")
            let name = array[1]
            let index = name.index(name.startIndex, offsetBy:6)//获取字符d的索引
            let nickname = String(name[..<index])
            HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .checkApple(userId: user, identityToken: str), showHud: true, loadingVC: self, success: { (result) in
                
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG(" dic ： \(String(describing: dic))")
                let api_token = HDDeclare.shared.api_token ?? ""
                let deviceno = HDLY_UserModel.shared.getDeviceNum()
                let params: [String: Any] = ["openid": user,
                                             "b_from": "apple",
                                             "deviceno": deviceno,
                                             "b_nickname": "apple用户\(nickname)",
                                             "api_token": api_token,
                ]
                HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .bindThirdAccount(params: params), showHud: true, loadingVC: self, success: { (result) in
                    
                    let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                    LOG(" dic ： \(String(describing: dic))")
                    guard let data : Int = dic!["data"] as? Int else {
                        return
                    }
                    
                    if data == 1 {
                        HDAlert.showAlertTipWith(type: .onlyText, text: "绑定成功")
                    }
                    self.declare.isBindApple = 1
                    self.myTableView.reloadData()
                }) { (errorCode, msg) in
                    HDAlert.showAlertTipWith(type: .onlyText, text: "绑定失败")
                }
            }) { (errorCode, msg) in
                HDAlert.showAlertTipWith(type: HDAlertType.error, text: msg)
            }
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

@available(iOS 13.0, *)
extension HDLY_AccountBind_VC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
