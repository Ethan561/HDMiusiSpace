//
//  HDLY_RootCSubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/5.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh

class HDLY_RootCSubVC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    var dataArr =  [MuseumListData]()
    var type = 1 //1最近2最火
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    var orderTipView: HDLY_CreateOrderTipView?
    var page = 0

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
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name: NSNotification.Name.init(rawValue: "HDLY_RootCSubVC_Refresh_Noti"), object: nil)
    }
    
    var isNeedRefresh = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedRefresh == true {
            refreshAction()
            isNeedRefresh = false
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
    
    @objc func dataRequest()  {
        LOG("HDDeclare.shared.locModel.cityName: \(HDDeclare.shared.locModel.cityName)")
        let token = HDDeclare.shared.api_token ?? ""
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideMuseumList(city_name: HDDeclare.shared.locModel.cityName, longitude: longitude, latitude: latitude, type: type, skip: page, take: 10, api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.ly_endLoading()
            self.tableView.es.stopPullToRefresh()

            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_MuseumListModel = try jsonDecoder.decode(HDLY_MuseumListModel.self, from: result)
                self.dataArr = model.data
                if self.dataArr.count == 0 {
                    let empV = EmptyConfigView.NoDataEmptyView()//空数据显示
                    self.tableView.ly_emptyView = empV
                    self.tableView.ly_showEmptyView()
                }
                self.tableView.reloadData()
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            let empV = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_emptyView = empV
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func dataRequestLoadMore()  {
        
        let token = HDDeclare.shared.api_token ?? ""
        let latitude = HDDeclare.shared.locModel.latitude
        let longitude = HDDeclare.shared.locModel.longitude
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideMuseumList(city_name: HDDeclare.shared.locModel.cityName, longitude: longitude, latitude: latitude, type: type, skip: page, take: 10, api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_MuseumListModel = try jsonDecoder.decode(HDLY_MuseumListModel.self, from: result)
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
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight)-CGFloat(PageMenuH)-15)
    }
    
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_RootCSubVC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
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
        let model:MuseumListData = dataArr[section]
        if model.type == 1 {
            let listData = model.list
            if listData!.list.count == 0{
                return 1
            }
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if dataArr.count > 0 {
            if index == 0 {
                return 70
            }
            let model:MuseumListData = dataArr[indexPath.section]
            if model.type == 1 {
                if ScreenWidth == 320 {
                    return 200
                }
                return 223*ScreenWidth/375.0
            } else if model.type == 2 {
                return 300*ScreenWidth/320.0
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if dataArr.count > 0 {
            let model:MuseumListData = dataArr[indexPath.section]
            
            if model.type == 1 {
                let listData = model.list
                if index == 0 {
                    let cell:HDLY_GuideSectionCell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
                    cell.moreBtn.tag = 100 + indexPath.section
                    cell.moreBtn.isHidden = false
                    cell.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
                    cell.nameLabel.text = listData?.title
                    cell.subNameL.text = "\(listData?.count ?? 0)处展览讲解"
                    
                    cell.disL.text = listData?.distance
                    if model.list?.count ?? 0 < 2 {
                        cell.moreBtn.isHidden = true
                    }else {
                        cell.moreBtn.isHidden = false
                    }
                    return cell
                }
                
                let cell = HDLY_GuideCard2Cell.getMyTableCell(tableV: tableView)
                cell?.delegate = self
                if listData?.list != nil {
                    cell?.dataArray = listData!.list
                }

                return cell!
                
            } else if model.type == 2 {
                let mapData = model.map
                
                if index == 0 {
                    let cell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
                    cell?.moreBtn.isHidden = true
                    cell?.nameLabel.text = mapData?.title
                    cell?.subNameL.text = "\(mapData?.count ?? 0)处景点讲解"
                    cell?.disL.text = mapData?.distance
                    return cell!
                }
                
                let cell = HDLY_GuideMapCell.getMyTableCell(tableV: tableView)
                cell?.model = mapData
                return cell!
            }
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:MuseumListData = dataArr[indexPath.section]
        if model.type == 2 && indexPath.row == 1 {
            if model.map?.isLock == 0 {
                let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_MapGuideVC") as! HDLY_MapGuideVC
                vc.museum_id = model.map?.museumID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else {//购买弹窗
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    let logVC = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SmsLogin_VC") as! HDItemBaseVC
                    self.navigationController?.pushViewController(logVC, animated: true)
                    isNeedRefresh = true
                    return
                }
                //获取订单信息
                guard let goodId = model.map?.museumID else {
                    return
                }
                publicViewModel.orderGetBuyInfoRequest(api_token: HDDeclare.shared.api_token!, cate_id: 3, goods_id: goodId, self)
            }
        }
    }
}

extension HDLY_RootCSubVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = dataArr[index]
        if model.type == 1 {
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
            vc.museum_id = model.list?.museumID ?? 0
            vc.titleName = model.list?.title ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDLY_RootCSubVC:HDLY_GuideCard2Cell_Delegate {
    
    func didSelectItemAt(_ model:MuseumListModel, _ cell: HDLY_GuideCard2Cell) {
        let sb = UIStoryboard.init(name: "RootC", bundle: nil)
        
        if model.isLock != 0 {//1已锁住 0已解锁
            //购买弹窗
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                let logVC = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SmsLogin_VC") as! HDItemBaseVC
                self.navigationController?.pushViewController(logVC, animated: true)
                isNeedRefresh = true
                return
            }

            //获取订单信息
            let goodId = model.id 
            publicViewModel.orderGetBuyInfoRequest(api_token: HDDeclare.shared.api_token!, cate_id: 2, goods_id: goodId, self)
            return
        }
        
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            let logVC = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SmsLogin_VC") as! HDItemBaseVC
            self.navigationController?.pushViewController(logVC, animated: true)
            isNeedRefresh = true
            return
        }
        
        if model.type == 0 {//0数字编号版 1列表版 2扫一扫版
            //typeL.text = "数字编号版"
            let vc:HDLY_NumGuideVC = sb.instantiateViewController(withIdentifier: "HDLY_NumGuideVC") as! HDLY_NumGuideVC
            vc.titleName = model.title
            vc.exhibition_id = model.id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 1 {
            //typeL.text = "列表版"
            let vc:HDLY_ExhibitListVC = sb.instantiateViewController(withIdentifier: "HDLY_ExhibitListVC") as! HDLY_ExhibitListVC
            vc.exhibition_id = model.id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 2 {
            //typeL.text = "扫一扫版"
            let vc:HDLY_QRGuideVC = sb.instantiateViewController(withIdentifier: "HDLY_QRGuideVC") as! HDLY_QRGuideVC
            vc.titleName = model.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    
}

extension HDLY_RootCSubVC {
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        //获取订单支付信息
        publicViewModel.orderBuyInfo.bind { (model) in
            weakSelf?.showOrderTipView(model)
        }
        
        //生成订单并支付
        publicViewModel.orderResultInfo.bind { (model) in
            weakSelf?.showPaymentResult(model)
        }
        
    }
    
    
    
    //显示支付弹窗
    func showOrderTipView( _ model: OrderBuyInfoData) {
        let tipView: HDLY_CreateOrderTipView = HDLY_CreateOrderTipView.createViewFromNib() as! HDLY_CreateOrderTipView
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        win.addSubview(tipView)
        orderTipView = tipView
        
        tipView.titleL.text = model.title
        if model.price != nil {
            tipView.priceL.text = String.init(format: "￥%@", model.price!)
            tipView.spaceCoinL.text = model.spaceMoney
            tipView.sureBtn.setTitle("支付\(model.price!)空间币", for: .normal)
        }
        
        weak var _self = self
        tipView.sureBlock = {
            _self?.orderBuyAction(model)
        }
        
    }
    
    func orderBuyAction(_ model: OrderBuyInfoData) {
        guard let goodId = model.goodsID?.int else {
            return
        }
        if Float(model.spaceMoney!) ?? 0 < Float(model.price!) ?? 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.pushToMyWalletVC()
                self.orderTipView?.removeFromSuperview()
            }
            return
        }
        publicViewModel.createOrderRequest(api_token: HDDeclare.shared.api_token!, cate_id: model.cateID?.int ?? 0, goods_id: goodId, pay_type: 1, self)
        
    }
    
    //显示支付结果
    func showPaymentResult(_ model: OrderResultData) {
        guard let result = model.isNeedPay else {
            return
        }
        if result == 2 {
            orderTipView?.successView.isHidden = false
            self.refreshAction()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.orderTipView?.sureBlock = nil
                self.orderTipView?.removeFromSuperview()
            }
        }
        
    }
    
    
}
