//
//  HDLY_ExhibitionListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ExhibitionListVC: HDItemBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArr =  [HDLY_ExhibitionListData]()
    var museum_id = 0
    var titleName = ""
    var vipTipView:HDLY_OpenVipTipView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        self.view.addSubview(self.tableView)
        self.title = self.titleName
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        dataRequest()
    }
    
    func dataRequest()  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitionList(museum_id: museum_id, skip: 0, take: 20, token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:HDLY_ExhibitionListM = try! jsonDecoder.decode(HDLY_ExhibitionListM.self, from: result)
            self.dataArr = model.data
            if self.dataArr.count > 0 {
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_ExhibitionListVC:UITableViewDataSource,UITableViewDelegate {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126*ScreenWidth/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = HDLY_ExhibitionCell.getMyTableCell(tableV: tableView)
        if dataArr.count > 0 {
            let model = dataArr[indexPath.row]
            cell?.modelA = model
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        if model.isLock == 1 {
            let tipView:HDLY_OpenVipTipView = HDLY_OpenVipTipView.createViewFromNib() as! HDLY_OpenVipTipView
            tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            tipView.model = model
            if kWindow != nil {
                kWindow!.addSubview(tipView)
            }
            tipView.webView.loadRequest(URLRequest.init(url: URL.init(string: "http://www.muspace.net/api/guide/vip_privilege?p=i")!))
            weak var weakS = self
            tipView.sureBlock = { model in
                weakS?.showDetailVC(model)
            }
            vipTipView = tipView
            return
        }
        showDetailVC(model)
        
    }
    
    
    func showDetailVC(_ model:HDLY_ExhibitionListData) {
        vipTipView?.removeFromSuperview()
        vipTipView?.sureBlock = nil
        
        if model.type == 0 {//0数字编号版 1列表版 2扫一扫版
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_NumGuideVC") as! HDLY_NumGuideVC
            vc.exhibition_id = model.exhibitionID
            vc.titleName = model.title ?? ""

            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 1 {
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitListVC") as! HDLY_ExhibitListVC
            vc.exhibition_id = model.exhibitionID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 2 {
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_QRGuideVC") as! HDLY_QRGuideVC
            self.titleName = model.title ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    

}

