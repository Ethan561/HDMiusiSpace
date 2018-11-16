//
//  HDLY_MuseumSubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/15.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDLY_MuseumSubVC: HDItemBaseVC {

    var dataArr =  [HDLY_dMuseumListD]()
    var type = -1 // 0全部 1推荐 2最近
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
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
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
        
    }
    
    func dataRequest()  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumList(type: type, skip: 0, take: 20, city_name: "", longitude: "", latitude: "", keywords: "", api_token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model: HDLY_dMuseumListM = try! jsonDecoder.decode(HDLY_dMuseumListM.self, from: result)
            self.dataArr = model.data
            self.tableView.reloadData()
        }) { (errorCode, msg) in
            //            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            //            self.tableView.ly_showEmptyView()
        }
    }
    
    func addRefresh() {
        let footer: ESRefreshProtocol & ESRefreshAnimatorProtocol = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    private func loadMore() {
        self.tableView.es.noticeNoMoreData()
    }
    
    @objc func pageTitleViewToTop() {
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
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight)-100)
        
    }
}


extension HDLY_MuseumSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dataArr.count > 0 {
            let model = dataArr[indexPath.row]
            if model.isLive == 0 && model.isGg == 0 {
                return 100
            }
        }
        return 120
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = HDSSL_dMuseumCell.getMyTableCell(tableV: tableView) as HDSSL_dMuseumCell
        if dataArr.count > 0 {
            let model = dataArr[indexPath.row]
            cell.model = model
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        //博物馆详情
        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
