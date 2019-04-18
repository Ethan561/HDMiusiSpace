//
//  HDLY_About_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_About_VC: HDItemBaseVC {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var phone = "010-85619596"
    private var email = "postmaster@muspace.com"
    private var gnjs  = "http://www.muspace.net/api/users/about_html/gnjs?p=i"
    private var ysxy  = "http://www.muspace.net/api/users/about_html/ysxy?p=i"
    private var syxy  = "http://www.muspace.net/api/users/about_html/syxy?p=i"
    private var version = "1.0.0"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于缪斯空间"
        setupViews()
        requestMuseSpaceInfo()
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        myTableView.separatorStyle = .none
        myTableView.backgroundColor = UIColor.HexColor(0xF0F0F0)
        
        let h = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 210*ScreenWidth/375.0))
        let headerView = Bundle.main.loadNibNamed("HDZQ_AboutMuseHeaderView", owner: nil, options: nil)?.last as?  HDZQ_AboutMuseHeaderView
        headerView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 210*ScreenWidth/375.0)
        h.addSubview(headerView!)
        myTableView.tableHeaderView = h
        
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 120))
        let footer = Bundle.main.loadNibNamed("HDZQ_AboutMuseFooterView", owner: nil, options: nil)?.last as? HDZQ_AboutMuseFooterView
        footer?.privacyProtocol.addTarget(self, action: #selector(openPrivacyPage), for: .touchUpInside)
        footer?.userProtocol.addTarget(self, action: #selector(openUserProtocolPage), for: .touchUpInside)
        footer?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 120)
        v.addSubview(footer!)
        myTableView.tableFooterView = v
        guard let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String  else {
            return
        }
        self.version = version
        headerView!.versionLabel.text = "v\(version)"
    }
    
    @objc func openPrivacyPage() {
        let vc = HDLY_WKWebVC()
        vc.titleName = "隐私协议"
        vc.urlPath = self.ysxy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openUserProtocolPage() {
        let vc = HDLY_WKWebVC()
        vc.titleName = "使用协议"
        vc.urlPath = self.syxy
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK:--- myTableView -----
extension HDLY_About_VC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let index = indexPath.row
        let cell = HDLY_MineInfo_Cell.getMyTableCell(tableV: tableView)
        cell?.isUserInteractionEnabled = true
        if section == 0 {
            /*if index == 0 {//客服热线
                cell?.nameL.text = "客服热线"
                cell?.subNameL.text = self.phone
                cell?.moreImgV.isHidden = true
                return cell!
            }else if index == 1 {//个人资料设置
            }*/
            cell?.nameL.text = "联系邮箱"
            cell?.subNameL.text = self.email
            cell?.moreImgV.isHidden = true
            cell?.bottomLine.isHidden = true
            return cell!
        }
        if section == 1 {
            if index == 0 {//功能介绍
                cell?.nameL.text = "功能介绍"
                return cell!
            }else if index == 1 {//喜欢我们
                cell?.nameL.text = "喜欢我们"
                cell?.subNameL.text = ""
                cell?.bottomLine.isHidden = false
                return cell!
            }else if index == 2 {//检查版本
                cell?.nameL.text = "检查版本"
                if let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String  {
                    if version == self.version || self.version == "" {
                        cell?.subNameLTrainingCons.constant = 10
                        cell?.subNameL.text = "已经是最新版本"
                        cell?.isUserInteractionEnabled = false
                        cell?.moreImgV.isHidden = true
                    } else {
                        cell?.subNameLTrainingCons.constant = 45
                        cell?.subNameL.text = "可更新到V\(self.version)"
                        cell?.moreImgV.isHidden = false
                    }
                }
                cell?.bottomLine.isHidden = true
                return cell!
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        if section == 0 && index == 0 {
            open(scheme: "tel:\(self.phone)")
        }
        if section == 0 && index == 1 {
            open(scheme: "mailto://\(self.email)")
        }
        if section == 1 && index == 0 {
            let vc = HDLY_WKWebVC()
            vc.titleName = "功能介绍"
            vc.urlPath = self.gnjs
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if section == 1 && index == 1 {
            // 弹窗评分
            //            open(scheme: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1130149052")
            open(scheme: "https://fir.im/musespace")
        }
        if section == 1 && index == 2 {
            open(scheme: "https://fir.im/musespace")
        }
    }
    
    
    
    func showAlert(msg: String) {
        open(scheme: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1130149052")
    }
    
}

extension HDLY_About_VC {
    func requestMuseSpaceInfo() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getAboutMuseSpaceInfo(versionId:0), success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG(" dic ： \(String(describing: dic))")
            guard let dataDic: Dictionary<String,Any> = dic!["data"] as? Dictionary else { return }
            guard let phone = dataDic["phone"] as? String else {return}
            self.phone = phone
            guard let email = dataDic["email"] as? String else {return}
            self.email = email
            guard let gnjs = dataDic["gnjs"] as? String else {return}
            self.gnjs = gnjs
            guard let syxy = dataDic["syxy"] as? String else {return}
            self.syxy = syxy
            guard let ysxy = dataDic["ysxy"] as? String else {return}
            self.ysxy = ysxy
            guard let version = dataDic["version_code"] as? String else {return}
            self.version = version
            self.myTableView.reloadData()
        }) { (error, msg) in
            
        }
    }
}
