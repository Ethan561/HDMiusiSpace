//
//  HDZQ_MyFollowSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDZQ_MyFollowSubVC: HDItemBaseVC {

    private var dataArr =  [MyFollowModel]()
    public var type = 1 // 1,2
    
    private var viewModel = HDZQ_MyViewModel()
    private var take = 10
    private var skip = 0
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        tableView.frame = CGRect.init(x: 0, y: 44, width: ScreenWidth, height: ScreenHeight - kTopHeight-44)
        view.addSubview(self.tableView)
        tableView.register(UINib.init(nibName: "HDZQ_MyFollowCell", bundle: nil), forCellReuseIdentifier: "HDZQ_MyFollowCell")
        addRefresh()
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData() {
        viewModel.requestMyFollow(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
    }
    
    func bindViewModel() {
        viewModel.follows.bind { [weak self] (models) in
            
            if (self?.skip)! > 0 {
                self?.dataArr.append(contentsOf: models)
            } else {
                self?.dataArr = models
            }
            if (self?.dataArr.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if models.count == 0 {
                 self?.tableView.es.noticeNoMoreData()
            }
            
            
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
        skip = skip + take
        requestData()
    }
}

extension HDZQ_MyFollowSubVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_MyFollowCell") as? HDZQ_MyFollowCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HDZQ_MyFollowCell", owner: nil, options: nil)?.last as? HDZQ_MyFollowCell
        }
        cell?.setCellWithModel(model: model)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 2 {
            let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
            let vc: HDZQ_OthersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDZQ_OthersCenterVC") as! HDZQ_OthersCenterVC
            let model = dataArr[indexPath.row]
            vc.toid = model.toid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
