//
//  HDSSL_MyOrderSubVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDSSL_MyOrderSubVC: HDItemBaseVC {

    private var orderArray =  [MyOrder]()
    public var type: Int?  //0全部1待支付2已完成3已取消
    private var viewModel = HDZQ_MyViewModel()
    
    private var take = 10
    private var skip = 0
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isShowNavShadowLayer = false
        tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - kTopHeight)
        view.addSubview(self.tableView)
        addRefresh() //刷新
        bindViewModel()
        requestData()
    }
    
    //请求订单列表
    func requestData() {
        viewModel.requestMyOrderList(apiToken: "123456", skip: skip*10, take: take, status: type!, vc: self)  //HDDeclare.shared.api_token ?? ""
    }
    //mvvm
    func bindViewModel() {
        
        viewModel.orderList.bind { (models) in
            self.refreshTableView(models: models)
        }
        
    }
    //刷新列表
    func refreshTableView(models:[MyOrder]) {
        if models.count > 0 {
            if skip == 0 {
                self.orderArray.removeAll()
            }
            self.orderArray += models
            self.tableView.reloadData()
            
        }
        if self.orderArray.count == 0 {
            self.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.tableView.ly_showEmptyView()
        }
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        requestData()
    }
    
    private func loadMore() {
        skip += 1
        requestData()
    }
    
}

extension HDSSL_MyOrderSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = orderArray[indexPath.row]
        weak var weakSelf = self
        
        if model.cateID == 1 {
            //课程
            let cell = HDSSL_OrderCell.getMyTableCell(tableV: tableView)
            cell?.tag = indexPath.row
            cell?.order = model
            cell?.bloclkPayOrderFunc(block: { (type) in
                //支付
                weakSelf?.payMyOrderOf(type)
            })
            cell?.bloclkBeginClassFunc(block: { (type) in
                //开始上课
                weakSelf?.beginClassForOrderOf(type)
            })
            cell?.bloclkShareOrderFunc(block: { (type) in
                //晒单分享
                weakSelf?.shareMyOrderOf(type)
            })
            cell?.bloclkDeleteOrderFunc(block: { (type) in
                //删除订单
                weakSelf?.deleteMyOrderOf(type)
            })
            
            return cell!
            
        }else {
            //门票
            let cell = HDSSL_TicketCell.getMyTableCell(tableV: tableView)
            cell?.tag = indexPath.row
            cell?.order = model
            
            cell?.bloclkPayTicketFunc(block: { (type) in
                //支付
                weakSelf?.payMyOrderOf(type)
            })
            cell?.bloclkDeleteTicketFunc(block: { (type) in
                //删除
                weakSelf?.deleteMyOrderOf(type)
            })
            cell?.bloclkCommentTicketFunc(block: { (type) in
                //评价
                weakSelf?.commentMyOrderOf(type)
            })
            
            return cell!
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //博物馆详情
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDSSL_OrderDetialVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_OrderDetialVC") as! HDSSL_OrderDetialVC
        let model = orderArray[indexPath.row]
        vc.order = model
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension HDSSL_MyOrderSubVC{
    //操作订单
    //支付
    func payMyOrderOf(_ index: Int) {
        let order = orderArray[index]
    }
    //开始上课
    func beginClassForOrderOf(_ index: Int) {
        let order = orderArray[index]
    }
    //晒单分享
    func shareMyOrderOf(_ index: Int) {
        let order = orderArray[index]
    }
    //删除订单
    func deleteMyOrderOf(_ index: Int) {
        let order = orderArray[index]
    }
    //评价订单
    func commentMyOrderOf(_ index: Int) {
        let order = orderArray[index]
    }
}
