//
//  HDLY_ExhibitionSubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/15.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_ExhibitionSubVC: HDItemBaseVC {
    
    var dataArr =  [HDLY_dExhibitionListD]()
    var museumDataArr =  [HDLY_dMuseumListD]()
    var type = -1 // 0全部 1推荐 2最近
    var page = 0
    var isExhibition = true
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        self.hd_navigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(headerViewToRefresh), name: NSNotification.Name.init(rawValue: "headerViewToRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView(noti:)), name: NSNotification.Name.init(rawValue: "CHANGEEXHIBITIONMUSEUM"), object: nil)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction),
                                               name: NSNotification.Name.init(rawValue: "HDLY_RootDSubVC_Refresh_Noti"),
                                               object: nil)
        //
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV
    }
    
    
   @objc func dataRequest()  {
        tableView.ly_startLoading()
        let cityName: String = HDDeclare.shared.locModel.cityName
    let latitude = HDDeclare.shared.locModel.latitude
    let longitude = HDDeclare.shared.locModel.longitude
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionExhibitionList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "") , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
            self.tableView.ly_endLoading()
            //
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_dExhibitionListM = try jsonDecoder.decode(HDLY_dExhibitionListM.self, from: result)
                self.dataArr = model.data
                self.tableView.reloadData()
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_endLoading()
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
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
        if isExhibition {
            dataRequest()
        } else {
            museumDataRequest()
        }
    }
    
    private func loadMore() {
        page = page + 10
        if isExhibition {
            dataRequestLoadMore()
        } else {
            MuseumDataRequestLoadMore()
        }
    }
    
    @objc func refreshTableView(noti:Notification) {
        if let obj = noti.object as? Bool {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.isExhibition = obj
                self.refreshAction()
            }
            
        }
    }
    
    func dataRequestLoadMore()  {
        
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionExhibitionList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "") , showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_dExhibitionListM = try jsonDecoder.decode(HDLY_dExhibitionListM.self, from: result)
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
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.es.stopLoadingMore()
        }
    }
    
    @objc func museumDataRequest()  {
        
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()
            
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDLY_dMuseumListM = try jsonDecoder.decode(HDLY_dMuseumListM.self, from: result)
                self.museumDataArr = model.data
                self.tableView.reloadData()
            }
            catch let error {
                LOG("\(error)")
            }
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    func MuseumDataRequestLoadMore() {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDLY_dMuseumListM = try jsonDecoder.decode(HDLY_dMuseumListM.self, from: result)
                if model.data.count > 0 {
                    self.tableView.es.stopLoadingMore()
                    self.museumDataArr += model.data
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
    
    
    @objc func pageTitleViewToTop() {
        self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
    }
    
    @objc func headerViewToRefresh() {
        self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
    }
    
    //监听子视图滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubTableViewDidScroll"), object: scrollView)
        //LOG("==== SubTableViewDidScroll :\(scrollView.contentOffset.y)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight)-50)
        
    }
}


extension HDLY_ExhibitionSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExhibition {
           return self.dataArr.count
        } else {
            return self.museumDataArr.count
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isExhibition {
            return (ScreenWidth-40)*188/335 + 110
        } else {
            if museumDataArr.count > 0 {
                let model = museumDataArr[indexPath.row]
                if model.isLive == 0 && model.isGg == 0 {
                    return 100
                }
            }
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isExhibition{
            let cell = HDSSL_dExhibitionCell.getMyTableCell(tableV: tableView) as HDSSL_dExhibitionCell
            if self.dataArr.count > 0 {
                let model = dataArr[indexPath.row]
                cell.model = model
            }
            return cell
        } else {
            let cell = HDSSL_dMuseumCell.getMyTableCell(tableV: tableView) as HDSSL_dMuseumCell
            if museumDataArr.count > 0 {
                let model = museumDataArr[indexPath.row]
                cell.model = model
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //展览详情
        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        if isExhibition {
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            let model = dataArr[indexPath.row]
            vc.exhibition_id = model.exhibitionID
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
            let model = museumDataArr[indexPath.row]
            vc.museumId = model.museumID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
