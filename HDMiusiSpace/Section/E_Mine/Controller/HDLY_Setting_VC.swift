//
//  HDLY_Setting_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/27.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import Kingfisher

class HDLY_Setting_VC: HDItemBaseVC {
    
    @IBOutlet weak var myTableView: UITableView!
    var logoutTip:HDLY_LogoutTip_View = HDLY_LogoutTip_View.createViewFromNib() as! HDLY_LogoutTip_View
    var isLogin = false
    var cacheSize = "0MB"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        setCacheSize()
        setupViews()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            isLogin = true
        }
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK:--- myTableView -----
extension HDLY_Setting_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 18
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        if section == 1 {
            if isLogin == true {
                return 1
            }else {
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else {
            if isLogin == true {
                 return 60
            }else {
                 return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//账号绑定设置
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "账号绑定设置"
                return cell!
            }else if index == 1 {//个人资料设置
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "个人资料设置"
                return cell!
            }else if index == 2 {//清理缓存
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "清理缓存"
                cell?.moreImgV.isHidden = true
                cell?.subNameL.text = self.cacheSize
                return cell!
            }else if index == 3 {//意见反馈
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.moreImgV.isHidden = true
                cell?.nameL.text = "意见反馈"
                return cell!
            }else if index == 4 {//关于缪斯空间
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.moreImgV.isHidden = true
                cell?.bottomLine.isHidden = true
                cell?.nameL.text = "关于缪斯空间"
                return cell!
            }
        }
        
        if section == 1 {
            let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
            if isLogin == true {
                cell?.nameL.text = "退出登录"
            }else {
                cell?.nameL.text = "登录/注册"
            }
            cell?.bottomLine.isHidden = true
            cell?.moreImgV.isHidden = true
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            if index == 0 {//账号绑定设置
                if isLogin == true {
                    self.performSegue(withIdentifier: "PushTo_HDLY_AccountBind_VC_Line", sender: nil)
                }else {
                    self.pushToLoginVC(vc: self)
                }
            }else if index == 1 {//个人资料设置
                if isLogin == true {
                    let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_UserInfo_VC") as! HDLY_UserInfo_VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.pushToLoginVC(vc: self)
                }
            }else if index == 2 {//清理缓存
                clearCacheRes()
            }else if index == 3 {//意见反馈
                if isLogin == true {
                    //反馈
                    let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Feedback_VC") as! HDLY_Feedback_VC
                    vc.typeID = "0"
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.pushToLoginVC(vc: self)
                }
            }else if index == 4 {//关于缪斯空间
                self.performSegue(withIdentifier: "PushTo_HDLY_About_VC_Line", sender: nil)
            }
        }
        if section == 1 {
            if isLogin == true {
                if kWindow != nil {
                    logoutTip.frame = kWindow!.bounds
                    kWindow!.addSubview(logoutTip)
                    weak var weakS = self
                    logoutTip.sureBlock = {
                        weakS?.logoutAction()
                    }
                }
            }else {
                self.pushToLoginVC(vc: self)
            }
        }
    }
    
}


// MARK: === actions ===
extension HDLY_Setting_VC {
    
    func logoutAction() {
        logoutTip.removeFromSuperview()
        logoutTip.sureBlock = nil
        
        let declare = HDDeclare.shared
        if declare.api_token != nil {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: HD_LY_API.userLogout(api_token: declare.api_token!), cache: false, showHud: false , success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG("\(String(describing: dic))")
                declare.removeUserMessage()
                declare.loginStatus = .kLogin_Status_Logout
                HDAlert.showAlertTipWith(type: .onlyText, text: "退出登录成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    self.back()
                })
            }) { (errorCode, msg) in
                
            }
        }else {
            declare.loginStatus = .kLogin_Status_Logout
        }
    }
    
    func clearCacheRes() {
        if self.cacheSize == "0MB" {
            HDAlert.showAlertTipWith(type: .onlyText, text: "当前没有缓存")
            return
        }
        let alertController = UIAlertController(title: "系统提示",
                                                message: "缓存大小\(self.cacheSize)是否清除", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
            action in
            KingfisherManager.shared.cache.clearDiskCache()
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "清除缓存成功！")
            let mapPath = String.init(format: "%@/Resource/WebMap", kCachePath)
            do {
                try FileManager.default.removeItem(atPath: mapPath)
            } catch  {
                LOG("error :\(error)")
            }
            self.cacheSize =  "0MB"
            let index = NSIndexPath.init(row: 2, section: 0)
            self.myTableView.reloadRows(at: [index as IndexPath], with: .none)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func setCacheSize() {
        KingfisherManager.shared.cache.calculateDiskCacheSize { (catchSize) in
            var mapSize:Int64?
            let mapPath = String.init(format: "%@/Resource/WebMap", kCachePath)
            let fileManager = FileManager.default
            do {
                let attr = try fileManager.attributesOfItem(atPath: mapPath)
                mapSize = attr[FileAttributeKey.size] as? Int64
            } catch  {
                LOG("error :\(error)")
            }
            
            //mapSize = mapSize == nil ? 0 : mapSize! + Int64(catchSize)
            if mapSize != nil {
                mapSize = Int64(catchSize) + mapSize!
            } else {
                mapSize = Int64(catchSize)
            }
            
            if mapSize == 0 {
                self.cacheSize = "0MB"
                return
            }
            
            let size = ceilf(Float(mapSize!)/1024.0/1024.0)
            self.cacheSize =  "\(size)MB"
            let index = NSIndexPath.init(row: 2, section: 0)
            self.myTableView.reloadRows(at: [index as IndexPath], with: .none)
        }
    }
    
}






