//
//  HDZQ_MyCollectSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh

class HDZQ_MyCollectSubVC: HDItemBaseVC {
    
    private var news =  [HDSSL_SearchNews]()
    private var exhibitions =  [HDLY_dExhibitionListD]()
    private var strategys =  [StrategyModel]()
    public var type = 1 // 1,2
    private var viewModel = HDZQ_MyViewModel()
    
    private var take = 10
    private var skip = 0
    
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
        if type != 1 {
            tableView.separatorStyle = .none
        }
        addRefresh()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         requestData()
    }
    
    func requestData() {
        if type == 1 {
            viewModel.requestMyCollectNews(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        } else if type == 2 {
            viewModel.requestMyCollectExhibitions(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        } else {
            viewModel.requestMyCollectStrategys(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        }
    }
    
    func bindViewModel() {
        viewModel.collectNews.bind { [weak self] (models) in
            if (self?.skip)! > 0 {
                self?.news.append(contentsOf: models)
            } else {
                self?.news = models
            }
            if (self?.news.count)! > 0 {
                 self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
                self?.tableView.es.stopPullToRefresh()

            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if models.count == 0 {
                self?.tableView.es.noticeNoMoreData()
            }
        }
        viewModel.collectExhibitions.bind { [weak self] (models) in
            if (self?.skip)! > 0 {
                self?.exhibitions.append(contentsOf: models)
            } else {
                self?.exhibitions = models
            }
            if (self?.exhibitions.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
                self?.tableView.es.stopPullToRefresh()

            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if models.count == 0 {
                self?.tableView.es.noticeNoMoreData()
            }
        }
        viewModel.collectMyStrategy.bind { [weak self] (models) in
            if (self?.skip)! > 0 {
                self?.strategys.append(contentsOf: models)
            } else {
                self?.strategys = models
            }
            if (self?.strategys.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
                self?.tableView.es.stopPullToRefresh()
                
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

extension HDZQ_MyCollectSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1 {
            return news.count
        } else if type == 2  {
            return exhibitions.count
        } else {
            return strategys.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type != 2 {
            return 100
        } else {
            return (ScreenWidth-40)*188/335 + 110
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == 1 {
            let news = self.news[indexPath.row]
            
            let cell = HDSSL_newsCell.getMyTableCell(tableV: tableView) as HDSSL_newsCell
            cell.cell_imgView.kf.setImage(with: URL.init(string: news.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.cell_titleLab.text = String.init(format: "%@", news.title!)
            
            let plat = news.plat_title == nil ? "" : "|"+news.plat_title!
            cell.cell_tipsLab.text = String.init(format:"%@%@", news.keywords!,plat)
            
            cell.cell_commentBtn.setTitle(String.init(format: "%d", news.comments!), for: .normal)
            
            cell.cell_likeBtn.setTitle(String.init(format: "%d", news.likes!), for: .normal)
            
            return cell
        } else if type == 2 {
            let cell = HDSSL_dExhibitionCell.getMyTableCell(tableV: tableView) as HDSSL_dExhibitionCell
            if self.exhibitions.count > 0 {
                let model = exhibitions[indexPath.row]
                cell.model = model
            }
            return cell
        } else {
            let strategy = self.strategys[indexPath.row]
            
            let cell = HDSSL_newsCell.getMyTableCell(tableV: tableView) as HDSSL_newsCell
            cell.cell_imgView.kf.setImage(with: URL.init(string: strategy.img), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.cell_titleLab.text = String.init(format: "%@", strategy.title)
            cell.cell_tipsLab.isHidden = true
            cell.cell_commentBtn.setTitle(String.init(format: "%d", strategy.comment_num), for: .normal)
            cell.cell_likeBtn.setTitle(String.init(format: "%d", strategy.likes_num), for: .normal)
            return cell
        }
        

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 2 {
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            let model = exhibitions[indexPath.row]
            vc.exhibition_id = model.exhibitionID
            self.navigationController?.pushViewController(vc, animated: true)
        } else if type == 1 {
            let model = news[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String(model.article_id ?? 0)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let model = strategys[indexPath.row]
            let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_StrategyDetialVC") as! HDSSL_StrategyDetialVC
            vc.strategyid = model.strategy_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
