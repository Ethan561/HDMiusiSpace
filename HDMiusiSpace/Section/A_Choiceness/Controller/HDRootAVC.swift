//
//  HDRootAVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootAVC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var searchBtn: UIButton!

    var tabHeader: RootBHeaderView!  //搜索和banner
    var bannerArr =  [BbannerModel]()
    //
    var collectionRow = -1
    var isCollection: Bool?
    var infoModel: ChoicenessModel?
    var dataArr =  [BItemModel]()
    
    //MVVM
    let viewModel: RootAViewModel = RootAViewModel()
    var searchVM: HDSSL_SearchViewModel = HDSSL_SearchViewModel()
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
    lazy var voiceView: HDZQ_VoiceSearchView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_VoiceSearchView", owner: nil, options: nil)?.last as? HDZQ_VoiceSearchView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        return tmp!
    }()
    
    var isNeedRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.voiceView.isHidden = true
        self.voiceView.delegate = self
        kWindow?.addSubview(self.voiceView)
        
        self.hd_navigationBarHidden = true
        navbarCons.constant = CGFloat(kTopHeight)
        if kTopHeight == 64 {
            navbarCons.constant = 72
        }
        getVersionData()
        setupViews()
        //MVVM
        bindViewModel()
        addRefresh()
        refreshAction()
        
        //定位
        HDLY_LocationTool.shared.startLocation()
        let cityName: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
        if cityName != nil {
            HDDeclare.shared.locModel.cityName = cityName!
        }
        //获取搜索默认提示信息
        searchVM.request_getSearchPlaceholder(vc: self)
        searchBtn.isHidden = true
        weak var weakS = self
        myTableView.ly_emptyView?.tapContentViewBlock = {
            weakS?.refreshAction()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNeedRefresh == true && HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            refreshAction()
            isNeedRefresh = false
        }else {
            isNeedRefresh = false
        } 
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)

        self.myTableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.myTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.myTableView.refreshIdentifier = String.init(describing: self)
        self.myTableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        self.viewModel.dataRequest(deviceno: deviceno, myTableView: self.myTableView , self)
        self.viewModel.dataRequestForBanner()
    }
    
    private func loadMore() {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()

        if infoModel?.data != nil {
            self.viewModel.dataRequestGetMoreNews(deviceno: deviceno, num: "10", myTableView: myTableView, self)
        }
    }
    
    @objc func refreshAction() {
        let deviceno = HDLY_UserModel.shared.getDeviceNum()
        self.viewModel.dataRequest(deviceno: deviceno, myTableView: self.myTableView , self)
        self.viewModel.dataRequestForBanner()
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.rootAData.bind { (_) in
            weakSelf?.showViewData()
        }
        viewModel.bannerArr.bind { (banner) in
            weakSelf?.bannerArr = banner
            if banner.count <= 1 {
                weakSelf?.tabHeader.pagerView.automaticSlidingInterval = 0
            }
            weakSelf?.tabHeader.pageControl.numberOfPages = banner.count
            weakSelf?.tabHeader.pagerView.reloadData()
            ///只有banner时，显示banner
            if self.infoModel?.data?.count == 0 && self.bannerArr.count == 0{
                let empV = EmptyConfigView.NoDataEmptyView()
                self.myTableView.ly_emptyView = empV
                self.myTableView.ly_showEmptyView()
            }else{
                self.myTableView.ly_hideEmptyView()
            }
            self.myTableView.reloadData()
        }
        viewModel.isNeedRefresh.bind { (_) in
            weakSelf?.refreshAction()
        }
        //收藏
        publicViewModel.isCollection.bind { (flag) in
            if flag == false {
                weakSelf?.isCollection = false
            } else {
                weakSelf?.isCollection = true
            }
            weakSelf?.myTableView.reloadRows(at: [IndexPath.init(row: weakSelf?.collectionRow ?? 0, section: 0)], with: .none)
        }
        //搜索框提示信息
        searchVM.searchPlaceholder.bind { (str) in
            print(str)
            //保存本地
            UserDefaults.standard.set(str, forKey: "SeachPlaceHolder")
            UserDefaults.standard.synchronize()
            
            weakSelf?.tabHeader.placeholderLab.text = str
        }
    }
    
    func showViewData() {
        self.infoModel = viewModel.rootAData.value
//        if self.infoModel?.data?.count == 0 && bannerArr.count == 0{
//            let empV = EmptyConfigView.NoDataEmptyView()
//            self.myTableView.ly_emptyView = empV
//            self.myTableView.ly_showEmptyView()
//        }else{
//            self.myTableView.ly_hideEmptyView()
//        }
        self.myTableView.reloadData()
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        //
        tabHeader = Bundle.main.loadNibNamed("RootBHeaderView", owner: nil, options: nil)?.first as? RootBHeaderView
        tabHeader.pagerView.dataSource = self
        tabHeader.pagerView.delegate = self
        tabHeader.pagerView.isInfinite = true
        tabHeader.searchBtn.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        tabHeader.voiceSeachBtn.addTarget(self, action: #selector(showVoiceSearchView), for: .touchUpInside)
        //
        myTableView.tableHeaderView = tabHeader
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: HeaderViewH)
        myTableView.separatorStyle = .none
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.backgroundColor = UIColor.white
        
    }
    
    //跳转搜索入口
    @objc func searchAction(_ sender: UIButton) {
        let vc: HDSSL_SearchVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_SearchVC") as! HDSSL_SearchVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showVoiceSearchView() {
        self.voiceView.voiceLabel.text = "想搜什么？说说试试"
        self.voiceView.voiceResult = ""
        self.voiceView.isHidden = false
        self.voiceView.gifView?.isHidden = false
        self.voiceView.voiceBtn.isHidden = true
        self.voiceView.startCollectVoice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    
    //跳转搜索入口
    @IBAction func searchBtnItemAction(_ sender: UIButton) {
        let storyborad = UIStoryboard.init(name: "RootA", bundle: nil)
        let vc: HDSSL_SearchVC = storyborad.instantiateViewController(withIdentifier: "HDSSL_SearchVC") as! HDSSL_SearchVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.myTableView.contentOffset.y <  60{
            searchBtn.isHidden = true
        } else {
            searchBtn.isHidden = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK:--- myTableView -----
extension HDRootAVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        if infoModel?.data != nil {
            return infoModel!.data!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = infoModel?.data![indexPath.row]
        if model?.type.int == 0 {//标签
            return 45
        }else if model?.type.int == 1 {//list
            return 100
        }else if model?.type.int == 2 {//日卡
            return 520*ScreenWidth/375.0
        }else if model?.type.int == 3 {//精选推荐
            return 160*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = infoModel!.data![indexPath.row]
        if model.type.int == 0 {
            let cell = RecommendSectionCell.getMyTableCell(tableV: tableView)
            cell?.nameLabel.text = model.category?.title
            if model.category?.title == "日卡" {
                cell?.moreL.text = ""
                cell?.moreBtn.isHidden  = true
            }else {
                cell?.moreL.text = "更多"
                cell?.moreBtn.isHidden  = false
            }
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            return cell!
        } else if model.type.int == 1 {
            let cell = HDLY_TopicRecmd_Cell.getMyTableCell(tableV: tableView)
            if model.itemList != nil {
                let model = model.itemList!
                cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.titleL.text = model.title
                cell?.desL.text = "\(model.keywords)|\(model.platTitle)"
                cell?.commentBtn.setTitle(model.comments.string, for: .normal)
                cell?.likeBtn.setTitle(model.likes.string, for: .normal)
            }
            
            return cell!
        }else if model.type.int == 2 {
            let cell = HDLY_RootACard_Cell.getMyTableCell(tableV: tableView)
            if model.itemCard?.img != nil {
                cell?.imgV.kf.setImage(with: URL.init(string: model.itemCard!.img), placeholder: UIImage.grayImage(sourceImageV: (cell?.imgV)!), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.collectionBtn.isHidden = false
            collectionRow = indexPath.row
            
            cell?.collectionBtn.tag = model.itemCard?.daycardID ?? 0
            cell?.collectionBtn.addTarget(self, action: #selector(cardCollectionBtnAction(_:)), for: UIControlEvents.touchUpInside)
            if isCollection != nil {
                cell?.collectionBtn.isSelected = isCollection!
                cell?.collectionBtn.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1.5, tx: 0, ty: 15)
                cell?.collectionBtn.alpha = 0.01
                UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                    cell?.collectionBtn.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                    cell?.collectionBtn.alpha = 1
                }) { (finish) in
                    cell?.collectionBtn.transform = CGAffineTransform.init(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
                }
            }else {
                if model.itemCard?.isFavorite == 1 {
                    self.isCollection = true
                    cell?.collectionBtn.isSelected = true
                } else {
                    cell?.collectionBtn.isSelected = false
                    self.isCollection = false
                }
            }
            
            return cell!
        }else if model.type.int == 3 {
            let cell = HDLY_Topic_Cell.getMyTableCell(tableV: tableView)
            cell?.listArray = model.itemClass
            cell?.delegate = self as HDLY_Topic_Cell_Delegate
            
            return cell!
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = infoModel!.data![indexPath.row]
        if model.type.int == 1 {//资讯
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = model.itemList?.articleID.string
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if model.type.int == 2 {//日卡
            if let item = model.itemCard {
                self.pushToCardDetail(model: item)
            }
        }
    }
}

extension HDRootAVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_RecmdMore_VC") as! HDLY_RecmdMore_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //收藏日卡
    @objc func cardCollectionBtnAction(_ sender: UIButton) {
        let cardID:String = String(sender.tag)
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            isNeedRefresh = true
            return
        }
        publicViewModel.doFavoriteRequest(api_token: HDDeclare.shared.api_token!, id: cardID, cate_id: "1", self)
    }
    
    //日卡跳转
    func pushToCardDetail(model: ChoicenessItemCard) {
        //cate_id: 轮播图类型1课程，2轻听随看，4展览，5活动
        if model.cardID ==  1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
            vc.courseId = String.init(format: "%ld", model.articleID)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if  model.cardID == 2 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            desVC.listen_id = String.init(format: "%ld", model.articleID)
            desVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cardID ==  4 {
            //展览详情
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            vc.exhibition_id = model.articleID
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cardID ==  5 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld", model.articleID)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDRootAVC : HDLY_Topic_Cell_Delegate {

    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Topic_Cell) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        vc.courseId = model.article_id?.string
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// FSPagerView
extension HDRootAVC {
    // MARK:- FSPagerView DataSource
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.bannerArr.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell:HDPagerViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index) as! HDPagerViewCell
        let model = bannerArr[index]
        if  model.img != nil  {
            cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
    
    // MARK:- FSPagerView Delegate
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        tabHeader.pageControl.currentPage = index
        
        let model = bannerArr[index]
        self.didSelectItemAtPagerViewCell(model: model, vc: self)
        
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard tabHeader.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        tabHeader.pageControl.currentPage = pagerView.currentIndex
        // Or Use KVO with property "currentIndex"
    }
}

extension HDRootAVC {
    func showUpdateAlertView(model:UpdateModel) {
        guard let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String  else {
            return
        }
        
        if model.version_no == "" || model.version_no == version {
            return
        }
        
        let alertView = Bundle.main.loadNibNamed("HDZQ_UpdateAlertView", owner: nil, options: nil)?.last as! HDZQ_UpdateAlertView
        alertView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        alertView.contentCiew.text = model.version_info
        alertView.updateBtn.addTouchUpInSideBtnAction { (btn) in
            alertView.removeFromSuperview()
            self.open(scheme: model.version_url)
        }
        kWindow?.addSubview(alertView)
    }
    
    func getVersionData() {
        //应用程序信息
        let infoDictionary = Bundle.main.infoDictionary!
        //let appDisplayName = infoDictionary["CFBundleDisplayName"] //程序名称
        let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
        LOG("===majorVersion: \(majorVersion)")
        
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .checkVersion(version_id: 0, device_id: HDDeclare.shared.deviceno ?? ""), cache: false, showHud: false, showErrorTip: false, loadingVC: self, success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                let model:UpdateData = try jsonDecoder.decode(UpdateData.self, from: result)
                if model.status == 1 {
                    let m = model.data
                    self.showUpdateAlertView(model:m!)
                }
            }
            catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (error, msg) in
//            self.showUpdateAlertView(model:nil)
        }
    }
    
}

extension HDRootAVC : HDZQ_VoiceResultDelegate {
    func voiceResult(result: String) {
        self.voiceView.isHidden = true
        let vc: HDSSL_SearchVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_SearchVC") as! HDSSL_SearchVC
        vc.searchContent = result
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
