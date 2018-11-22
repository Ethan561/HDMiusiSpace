//
//  HDZQ_MyCollectSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

class HDZQ_MyCollectSubVC: HDItemBaseVC {
    
    private var news =  [HDSSL_SearchNews]()
    private var exhibitions =  [HDLY_dExhibitionListD]()
    public var type = 1 // 1,2
    
    private var viewModel = HDZQ_MyViewModel()
    
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
        
        tableView.register(UINib.init(nibName: "HDSSL_newsCell", bundle: nil), forCellReuseIdentifier: "HDSSL_newsCell")
        bindViewModel()
        if type == 1 {
            viewModel.requestMyCollectNews(apiToken: HDDeclare.shared.api_token ?? "", skip: 0, take: 10, type: type, vc: self)
        } else {
            viewModel.requestMyCollectExhibitions(apiToken: HDDeclare.shared.api_token ?? "", skip: 0, take: 10, type: type, vc: self)
        }
        
    }
    
    func bindViewModel() {
        viewModel.collectNews.bind { [weak self] (models) in
            if models.count > 0 {
                self?.news = models
                self?.tableView.reloadData()
            } else {
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
        }
        viewModel.collectExhibitions.bind { [weak self] (models) in
            if models.count > 0 {
                self?.exhibitions = models
                self?.tableView.reloadData()
            } else {
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
        }
    }
    
}

extension HDZQ_MyCollectSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1 {
            return news.count
        } else {
            return exhibitions.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == 1 {
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
            
            let plat = news.platform == nil ? "" : "|"+news.platform!
            cell.cell_tipsLab.text = String.init(format:"%@%@", news.keywords!,plat)
            
            cell.cell_commentBtn.setTitle(String.init(format: "%d", news.comments!), for: .normal)
            
            cell.cell_likeBtn.setTitle(String.init(format: "%d", news.likes!), for: .normal)
            
            return cell
        } else {
            let cell = HDSSL_dExhibitionCell.getMyTableCell(tableV: tableView) as HDSSL_dExhibitionCell
            if self.exhibitions.count > 0 {
                let model = exhibitions[indexPath.row]
                cell.model = model
            }
            return cell
        }
        

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        //展览详情
        //        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        //        let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
        //        let model = dataArr[indexPath.row]
        //        vc.exhibition_id = model.exhibitionID
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
