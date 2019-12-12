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
    var exhibitionMuseumArr =  [D_ExhibitionMuseumListData]()
    
    var type = -1 // 0全部 1推荐 2最近
    var page = 0
    var isExhibition = true
    var isExhibitionMuseum = false
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
            self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction),
                                               name: NSNotification.Name.init(rawValue: "HDLY_RootDSubVC_Refresh_Noti"),
                                               object: nil)
        

    }
    
    //MARK: === addRefresh ===
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
    
    
    //MARK: --- dataRequest ---
    
    //展览模块
   @objc func dataRequest()  {
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        let token = HDDeclare.shared.api_token ?? ""
    
        if type == 0 {//展览博物馆
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionNewMuseumList(skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, api_token : token) , showHud: true, loadingVC: self.parent, success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG("\(String(describing: dic))")
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()
                self.dataArr.removeAll()
                //
                let jsonDecoder = JSONDecoder()
                do {
                    let model:D_ExhibitionMuseumList = try jsonDecoder.decode(D_ExhibitionMuseumList.self, from: result)
                    self.exhibitionMuseumArr = model.data
                    if self.exhibitionMuseumArr.count == 0 {
                        let empV = EmptyConfigView.NoDataEmptyView()
                        self.tableView.ly_emptyView = empV
                        self.tableView.ly_showEmptyView()
                    }
                    self.tableView.reloadData()
                }
                catch let error {
                    LOG("\(error)")
                }
                
            }) { (errorCode, msg) in
                self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
                self.tableView.ly_showEmptyView()
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()
            }
        }else {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionExhibitionList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token : token) , showHud: true, loadingVC: self.parent, success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG("\(String(describing: dic))")
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()
                self.dataArr.removeAll()
                //
                let jsonDecoder = JSONDecoder()
                do {
                    let model:HDLY_dExhibitionListM = try jsonDecoder.decode(HDLY_dExhibitionListM.self, from: result)
                    self.dataArr = model.data
                    if self.dataArr.count == 0 {
                        let empV = EmptyConfigView.NoDataEmptyView()
                        self.tableView.ly_emptyView = empV
                        self.tableView.ly_showEmptyView()
                    }
                    self.tableView.reloadData()
                }
                catch let error {
                    LOG("\(error)")
                }
                
            }) { (errorCode, msg) in
                self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
                self.tableView.ly_showEmptyView()
                self.tableView.es.stopPullToRefresh()
                self.tableView.es.stopLoadingMore()
            }
        }
    }

    func dataRequestLoadMore()  {
        
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        let token = HDDeclare.shared.api_token ?? ""
        
        if type == 0 {//展览博物馆
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionNewMuseumList(skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, api_token : token) , showHud: false, loadingVC: self.parent, success: { (result) in
                let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                LOG("\(String(describing: dic))")
                
                let jsonDecoder = JSONDecoder()
                do {
                    let model:D_ExhibitionMuseumList = try jsonDecoder.decode(D_ExhibitionMuseumList.self, from: result)
                    if model.data.count > 0 {
                        self.tableView.es.stopLoadingMore()
                        self.exhibitionMuseumArr += model.data
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
        }else {
            HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionExhibitionList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token : token) , showHud: false, loadingVC: self.parent, success: { (result) in
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
    }
    
    //博物馆模块数据获取 museumDataRequest
    @objc func museumDataRequest()  {
        
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        
        let cityName: String = HDDeclare.shared.locModel.cityName
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token: token), showHud: true, loadingVC: self.parent, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()
            self.museumDataArr.removeAll()
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDLY_dMuseumListM = try jsonDecoder.decode(HDLY_dMuseumListM.self, from: result)
                self.museumDataArr = model.data
                if self.museumDataArr.count == 0 {
                    let empV = EmptyConfigView.NoDataEmptyView()
                    self.tableView.ly_emptyView = empV
                    self.tableView.ly_showEmptyView()
                }
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
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: page, take: 10, city_name: cityName , longitude: longitude, latitude: latitude, keywords: "", api_token: token), showHud: false, loadingVC: self.parent, success: { (result) in
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
    
    
    //MARK: =====
    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        if isExhibition && type == 0  {
            return exhibitionMuseumArr.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExhibition {
            if type == 0 {
                return 2
            }
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
            let index = indexPath.row
            if type == 0 {
                if index == 0 {
                    return 70
                }
                if ScreenWidth == 320 {
                    return 200
                }
                return 223*ScreenWidth/375.0
            }
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
        if isExhibition {
            let index = indexPath.row
            if type == 0 {
                let model:D_ExhibitionMuseumListData = exhibitionMuseumArr[indexPath.section]
                if index == 0 {
                    let cell:HDLY_dExMusSectionCell = HDLY_dExMusSectionCell.getMyTableCell(tableV: tableView)
                    cell.moreBtn.tag = 100 + indexPath.section
                    cell.moreBtn.isHidden = false
                    cell.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
                    //
                    cell.titleBtn.tag = 100 + indexPath.section
                    cell.titleBtn.addTarget(self, action: #selector(museumTitleBtnAction(_:)), for: .touchUpInside)
                    
                    cell.nameLabel.text = model.title
                    cell.subNameL.text = String.init(format: "%ld个展览", model.count ?? 0)
                    if model.list?.count ?? 0 < 2 {
                        cell.moreBtn.isHidden = true
                    }else {
                        cell.moreBtn.isHidden = false
                    }
                    if model.is_favorites == 1 {
                        cell.tudingImgV.isHidden = false
                    }else {
                        cell.tudingImgV.isHidden = true
                    }
                    return cell
                }
                
                let cell = HDSSL_sameMuseumCell.getMyTableCell(tableV: tableView)
                cell?.listArray = model.list
                weak var weakS = self
                cell?.BlockTapItemFunc(block: { (m) in
                    weakS?.showExhibitionDetailVC(exhibitionID: m.exhibitionID ?? 0)
                })
                return cell!
            }
            
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
            if type != 0 {
                let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
                let model = dataArr[indexPath.row]
                vc.exhibition_id = model.exhibitionID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
            let model = museumDataArr[indexPath.row]
            vc.museumId = model.museumID
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDLY_ExhibitionSubVC {
    //博物馆下的全部展览
    @objc func moreBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = exhibitionMuseumArr[index]
        let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SameExhibitionListVC") as! HDLY_SameExhibitionListVC
        vc.museumId = model.museumID ?? 0
        vc.exhibitionId = 0
        vc.titleName = model.title ?? ""
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //博物馆详情
    @objc func museumTitleBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = exhibitionMuseumArr[index]
        let vc: HDSSL_dMuseumDetailVC = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
        vc.museumId = model.museumID ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showExhibitionDetailVC(exhibitionID: Int) {
        //展览详情
        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
        vc.exhibition_id = exhibitionID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

