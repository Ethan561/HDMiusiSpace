//
//  HDSSL_MyOrderSubVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDSSL_MyOrderSubVC: HDItemBaseVC {

    private var orderArray =  [MyOrder]()
    public var type: Int?  //0全部1待支付2已完成3已取消
    private var viewModel = HDZQ_MyViewModel()
    
    private var take = 10
    private var skip = 0
    
    var currentShareOrder:MyOrder?
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isShowNavShadowLayer = false
        tableView.frame = CGRect.init(x: 0, y: 44, width: ScreenWidth, height: ScreenHeight - kTopHeight-44)
        view.addSubview(self.tableView)
        
        addRefresh() //刷新
        bindViewModel()
        requestData()
    }
    
    //请求订单列表
    func requestData() {
        viewModel.requestMyOrderList(apiToken: HDDeclare.shared.api_token ?? "", skip: skip*10, take: take, status: type!, vc: self)  //HDDeclare.shared.api_token ?? ""
    }
    //mvvm
    func bindViewModel() {
        
        viewModel.orderList.bind { (models) in
            self.refreshTableView(models: models)
        }
        viewModel.isDeleteOrder.bind { (isdelete) in
            print(isdelete)
            if isdelete == 1 {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "删除订单成功")
                self.skip = 0
                self.requestData()
                
            } else {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "删除订单失败")
            }
            
        }
        viewModel.orderPicPath.bind { (path) in
            //订单分享图
            print(path)
            //进入分享页面
            if path.count > 0 {
                let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
                let shareOrderVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_orderShareVC") as! HDSSL_orderShareVC
                shareOrderVC.sharePath = path
                shareOrderVC.orderID = self.currentShareOrder?.orderID
                self.navigationController?.pushViewController(shareOrderVC, animated: true)
            }
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
            self.tableView.es.stopPullToRefresh()
            self.tableView.es.stopLoadingMore()
        }else{
            self.tableView.es.noticeNoMoreData()
        }
        if self.orderArray.count == 0 {
            self.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
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
        
        let storyBoard = UIStoryboard.init(name: "RootB", bundle: Bundle.main)
        let vc: HDLY_CourseList_VC = storyBoard.instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
        vc.courseId = String.init(format: "%d", order.goodsID ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //晒单分享
    func shareMyOrderOf(_ index: Int) {
        let order = orderArray[index]
        currentShareOrder = order
        //请求图片地址，然后跳转页面
        viewModel.getOrderSharePicPath(apiToken: HDDeclare.shared.api_token ?? "", order_id: (order.orderID)!, vc: self) //HDDeclare.shared.api_token ?? ""
    }
    //删除订单
    func deleteMyOrderOf(_ index: Int) {
        //提示
        weak var weakself = self
        
        let tipView: HDSSL_defaultAlertView = HDSSL_defaultAlertView.createViewFromNib() as! HDSSL_defaultAlertView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.topTitleLabel.text = ""
        tipView.titleLab.text = "删除当前订单？"
        tipView.blockSelected { (type) in
            if type == 1 {
                let order = weakself?.orderArray[index]
                weakself?.viewModel.deleteOrderBy(apiToken: HDDeclare.shared.api_token ?? "", order_id: order!.orderID!, vc: self)
            }
        }
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        
        
    }
    //评价订单
    func commentMyOrderOf(_ index: Int) {
        let order = orderArray[index]
        
        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        let commentvc = storyBoard.instantiateViewController(withIdentifier: "HDSSL_commentVC") as! HDSSL_commentVC
        commentvc.exhibition_id = order.goodsID
        self.navigationController?.pushViewController(commentvc, animated: true)
        
    }
}
