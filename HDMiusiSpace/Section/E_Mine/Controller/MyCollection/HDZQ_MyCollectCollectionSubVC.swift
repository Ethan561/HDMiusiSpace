//
//  HDZQ_MyCollectCollectionSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import ESPullToRefresh

class HDZQ_MyCollectCollectionSubVC: HDItemBaseVC {
    
    private var listens =  [MyCollectListenModel]()
    private var jingxuans =  [MyCollectJingxuanModel]()
    public var type = 4 // 1,2
    private var viewModel = HDZQ_MyViewModel()
    
    private var take = 10
    private var skip = 0
    
    lazy var collectionView: UICollectionView = {
        
        
    
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemW: Float = Float((ScreenWidth - 60) * 0.5)
        var itemH = itemW * 1.5 + 50
        if type == 5 {
             itemH = itemW / 16 * 11
        }
        
        layout.minimumLineSpacing = 20
       layout.sectionInset = UIEdgeInsets.init(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize.init(width: CGFloat(itemW), height: CGFloat(itemH))
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        let collectionView:UICollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib.init(nibName: HDLY_Listen_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Listen_CollectionCell.className)
        collectionView.register(UINib.init(nibName: HDLY_Topic_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Topic_CollectionCell.className)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        collectionView.frame = CGRect.init(x: 0, y: 44, width: ScreenWidth, height: ScreenHeight - kTopHeight-44)
        view.addSubview(self.collectionView)
        addRefresh()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData() {
        if type == 4 {
            viewModel.requestMyListens(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        } else {
            viewModel.requestMyCollectJingxuans(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        }
    }
    
    func bindViewModel() {
        viewModel.collectListens.bind { [weak self] (models) in
            if (self?.skip)! > 0 {
                self?.listens.append(contentsOf: models)
            } else {
                self?.listens = models
            }
            if (self?.listens.count)! > 0 {
                self?.collectionView.reloadData()
            } else {
                self?.collectionView.reloadData()
                self?.collectionView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.collectionView.ly_showEmptyView()
            }
            self?.collectionView.es.stopPullToRefresh()
            self?.collectionView.es.stopLoadingMore()
            if models.count == 0 {
                self?.collectionView.es.noticeNoMoreData()
            }
        }
        viewModel.collectJingxuans.bind { [weak self] (models) in
            if (self?.skip)! > 0 {
                self?.jingxuans.append(contentsOf: models)
            } else {
                self?.jingxuans = models
            }
            if (self?.jingxuans.count)! > 0 {
                self?.collectionView.reloadData()
            } else {
                self?.collectionView.reloadData()
                self?.collectionView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.collectionView.ly_showEmptyView()
            }
            self?.collectionView.es.stopPullToRefresh()
            self?.collectionView.es.stopLoadingMore()
            if models.count == 0 {
                self?.collectionView.es.noticeNoMoreData()
            }
        }
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.collectionView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.collectionView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.collectionView.refreshIdentifier = String.init(describing: self)
        self.collectionView.expiredTimeInterval = 20.0
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

extension HDZQ_MyCollectCollectionSubVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == 4 {
            return listens.count
        } else {
            return jingxuans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == 4 {
            let cell:HDLY_Listen_CollectionCell = HDLY_Listen_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
            if self.listens.count > 0 {
                let model = listens[indexPath.row]
                cell.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                cell.titleL.text = model.title
                cell.countL.text = "\(model.listening)人听过" 
                
            }
            return cell
        } else {
            let cell:HDLY_Topic_CollectionCell = HDLY_Topic_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
            if self.jingxuans.count > 0 {
                let model = jingxuans[indexPath.row]
                cell.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                cell.titleL.text = model.title
                cell.newTipL.isHidden = true
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == 4 {
            let model = listens[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            vc.listen_id = "\(model.listen_id)"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
             let model = jingxuans[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String(model.article_id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
