//
//  HDLY_AccountBind_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

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
       return 5
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
            if index == 0 {//修改密码
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "修改密码"
                return cell!
            }else if index == 1 {//手机号
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "手机号"
                cell?.subNameL.text = declare.phone
                cell?.moreImgV.isHidden = true
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
            }else if index == 2 {//邮箱
                
            }
        }
        
        if section == 1 {
            if index == 0 {//微信
      
            }else if index == 1 {//新浪微博
    
            }else if index == 2 {//邮箱

            }
        }
    }
    
}


