//
//  HDLY_ExhibitionListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_ExhibitionListVC: HDItemBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArr =  [HDLY_ExhibitionListData]()
    var museum_id = 0
    var titleName = ""
    var vipTipView:HDLY_OpenVipTipView?
    var page = 0
    
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
        addRefresh()
    }
    
    var isNeedRefresh = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedRefresh == true {
            dataRequest()
            isNeedRefresh = false
        }
    }
    
    
    func dataRequest()  {
        let token:String =  HDDeclare.shared.api_token ?? ""
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitionList(museum_id: museum_id, skip: page, take: 20, token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()

            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_ExhibitionListM = try jsonDecoder.decode(HDLY_ExhibitionListM.self, from: result)
                self.dataArr = model.data
                if self.dataArr.count > 0 {
                    self.tableView.reloadData()
                }else {
                    let empV = EmptyConfigView.NoDataEmptyView()
                    self.tableView.ly_emptyView = empV
                    self.tableView.ly_showEmptyView()
                }
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()

        }
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshAction()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    
    @objc func refreshAction() {
        page = 0
        dataRequest()
    }
    
    private func loadMore() {
        page = page + 10
        dataRequestLoadMore()
    }
    
    func dataRequestLoadMore()  {
        let token:String =  HDDeclare.shared.api_token ?? ""
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitionList(museum_id: museum_id, skip: page, take: 20, token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_ExhibitionListM = try jsonDecoder.decode(HDLY_ExhibitionListM.self, from: result)
                if model.data.count > 0 {
                    self.tableView.es.stopLoadingMore()
                    self.dataArr += model.data
                    self.tableView.reloadData()
                } else {
                    self.tableView.es.noticeNoMoreData()
                }
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.es.stopLoadingMore()
        }
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
                HDAlert.showAlertTipWith(type: .onlyText, text: "敬请期待")

               // weakS?.showDetailVC(model)
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

