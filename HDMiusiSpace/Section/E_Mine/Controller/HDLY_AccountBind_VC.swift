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
extension HDLY_AccountBind_VC: UITableViewDelegate, UITableViewDataSource {
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
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
            }else if index == 2 {//邮箱
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "邮箱"
                cell?.moreImgV.isHidden = true
                cell?.bottomLine.isHidden = true
                return cell!
            }
        }
        
        if section == 1 {
            if index == 0 {//微信
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.moreImgV.isHidden = true
                cell?.nameL.text = "微信"
                cell?.subNameL.text = "未绑定"
                return cell!
            }else if index == 1 {//新浪微博
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "新浪微博"
                cell?.subNameL.text = "未绑定"
                cell?.moreImgV.isHidden = true
                return cell!
            }else if index == 2 {//邮箱
                let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
                cell?.nameL.text = "邮箱"
                cell?.subNameL.text = "未绑定"
                cell?.moreImgV.isHidden = true
                cell?.bottomLine.isHidden = true
                return cell!
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 {
            
        }
    }
    
}


