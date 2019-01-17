//
//  HDLY_StrategyListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/19.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_StrategyListVC: HDItemBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArr =  [DStrategyListData]()
    var museumId = 0
    var titleName  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
        self.title = titleName
        tableView.separatorStyle = .none
    }
    
    func dataRequest()  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getStrategyList(museum_id: museumId, skip: 0, take: 20, api_token: token) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:DStrategyListModel = try! jsonDecoder.decode(DStrategyListModel.self, from: result)
            if model.data != nil {
                self.dataArr = model.data!
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            //            tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            //            tableView.ly_showEmptyView()
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
}

extension HDLY_StrategyListVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_StrategyListCell.getMyTableCell(tableV: tableView) as HDLY_StrategyListCell
        if self.dataArr.count > 0 {
            let model = dataArr[indexPath.row]
            if model.img != nil {
                cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.titleL.text = model.title
            cell.desL.text = "\(model.categoryTitle!)|\(model.author!)"
            cell.commentBtn.setTitle("\(model.commentNum ?? 0)", for: .normal)
            cell.likeBtn.setTitle("\(model.like_num ?? 0)", for: .normal)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //攻略详情
        tableView.deselectRow(at: indexPath, animated: true)
        let model = dataArr[indexPath.row]

        let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_StrategyDetialVC") as! HDSSL_StrategyDetialVC
        vc.strategyid = model.strategyID
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}

