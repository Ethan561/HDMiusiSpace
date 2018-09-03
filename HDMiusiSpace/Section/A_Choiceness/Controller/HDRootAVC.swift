//
//  HDRootAVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootAVC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate  {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    
    var tabHeader: RootBHeaderView!
    var bannerArr =  [BbannerModel]()
    
    var infoModel: ChoicenessModel?
    var dataArr =  [BItemModel]()
    //MVVM
    let viewModel: RootAViewModel = RootAViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = CGFloat(kTopHeight)
        setupViews()
        
        //MVVM
        bindViewModel()
        viewModel.dataRequestForBanner()
        if HDDeclare.shared.deviceno != nil {
            viewModel.dataRequest(deviceno: HDDeclare.shared.deviceno!, self)
        }
        self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
        self.myTableView.ly_hideEmptyView()
        
    }
    
    @objc func refreshAction() {
        if HDDeclare.shared.deviceno != nil {
            viewModel.dataRequest(deviceno: HDDeclare.shared.deviceno!, self)
        }
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.rootAData.bind { (_) in
            weakSelf?.showViewData()
        }
        viewModel.showEmptyView.bind() { (show) in
            if show {
                weakSelf?.myTableView.ly_showEmptyView()
            }else {
                weakSelf?.myTableView.ly_hideEmptyView()
            }
        }
        viewModel.bannerArr.bind { (banner) in
            weakSelf?.bannerArr = banner
            weakSelf?.tabHeader.pageControl.numberOfPages = banner.count
            weakSelf?.tabHeader.pagerView.reloadData()
        }
    }
    
    func showViewData() {
        self.infoModel = viewModel.rootAData.value
        self.myTableView.reloadData()
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //
        tabHeader = Bundle.main.loadNibNamed("RootBHeaderView", owner: nil, options: nil)?.first as! RootBHeaderView
        tabHeader.pagerView.dataSource = self
        tabHeader.pagerView.delegate = self
        tabHeader.pagerView.isInfinite = true
        //
        myTableView.tableHeaderView = tabHeader
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: HeaderViewH)
        myTableView.separatorStyle = .none
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.backgroundColor = UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }else if model?.type.int == 3 {//精选好课
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
            }
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            return cell!
        }else if model.type.int == 1 {
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
        if model.type.int == 0 {
            
        }else if model.type.int == 1 {
            
        }else if model.type.int == 2 {

        }else if model.type.int == 3 {//轻听随看
            
        }
    }
}

extension HDRootAVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        
    }
}

extension HDRootAVC : HDLY_Topic_Cell_Delegate {

    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Topic_Cell) {
        
//        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDectail_VC") as! HDLY_TopicDectail_VC
//        vc.topic_id = model.article_id?.string
//        self.navigationController?.pushViewController(vc, animated: true)
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
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard tabHeader.pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        tabHeader.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}

