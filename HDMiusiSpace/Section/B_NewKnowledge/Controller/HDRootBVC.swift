//
//  HDRootBVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import Kingfisher
import ESPullToRefresh

let PageMenuH = 45.0
let HeaderViewH = (ScreenWidth*200/375.0)+80

class HDRootBVC: HDItemBaseVC,SPPageMenuDelegate, UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate {
    
    @IBOutlet weak var tabVBottomCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: RootBMainTableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var searchBtn: UIButton!
    
    var menuArr = [CourseMenuModel]()
    var tabHeader: RootBHeaderView!
    var bannerArr =  [BbannerModel]()
    
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x: 0, y: 0, width: Int(ScreenWidth), height: Int(PageMenuH)), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 18)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.clear
        page.backgroundColor = UIColor.white
        page.permutationWay = SPPageMenuPermutationWay.scrollAdaptContent
        page.bridgeScrollView = self.contentScrollView
        
        return page
    }()
    
    lazy var contentScrollView: UIScrollView =  {
        let scrollView = UIScrollView.init()
        scrollView.frame  = CGRect.init(x: 0, y: 15+CGFloat(PageMenuH), width: ScreenWidth, height:  ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight)-CGFloat(PageMenuH)-15)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.white
        
        return scrollView
    }()
    
    var childVCScrollView: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabVBottomCons.constant = CGFloat(kTabBarHeight)
        navbarCons.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        setupViews()
        //
        dataRequestForBanner()
        dataRequestForMenu()
        searchBtn.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll(noti:)), name: NSNotification.Name.init(rawValue: "SubTableViewDidScroll"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "SubTableViewDidScroll"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //
        tabHeader = Bundle.main.loadNibNamed("RootBHeaderView", owner: nil, options: nil)?.first as! RootBHeaderView
        tabHeader.pagerView.dataSource = self
        tabHeader.pagerView.delegate = self
        tabHeader.pagerView.isInfinite = true
        tabHeader.searchBtn.addTarget(self, action: #selector(searchAction(_:)), for: .touchUpInside)
        
        //
        myTableView.tableHeaderView = tabHeader
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: HeaderViewH)
        myTableView.separatorStyle = .none
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.backgroundColor = UIColor.white

    }
    
    func dataRequestForBanner()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getNewKnowledgeBanner(), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            self.bannerArr.removeAll()
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    let model:BbannerModel = try! jsonDecoder.decode(BbannerModel.self, from: dataA)
                    self.bannerArr.append(model)
                }
                self.tabHeader.pageControl.numberOfPages = self.bannerArr.count
                self.tabHeader.pagerView.reloadData()
            }
            
        }) { (errorCode, msg) in
            
        }
    }

    func dataRequestForMenu() {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseCateList(), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.myTableView.ly_hideEmptyView()

            let jsonDecoder = JSONDecoder()
            let model:CourseMenu = try! jsonDecoder.decode(CourseMenu.self, from: result)
            self.menuArr = model.data
            
            var menuTitleArr = Array<String>()
            for model in self.menuArr {
                menuTitleArr.append(model.cateName)
            }
            self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
            self.addContentSubViewsWithArr(titleArr: menuTitleArr)
        }) { (errorCode, msg) in
            self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.myTableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequestForMenu()
        dataRequestForBanner()
    }
    
    //跳转搜索入口
    @IBAction func searchAction(_ sender: UIButton) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// PageMenu
extension HDRootBVC {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.contentScrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.contentScrollView.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
            let model  = self.menuArr[i]
            switch i {
                
            case 0://推荐
                let baseVC:HDLY_Recommend_SubVC = HDLY_Recommend_SubVC.init()
                self.addChildViewController(baseVC)
                self.contentScrollView.addSubview(self.childViewControllers[0].view)
                baseVC.showListenView.bind { [weak self] show in
                    if show {
                        guard let vc = self else {
                            return
                        }
                        vc.pageMenu(vc.pageMenu, itemSelectedFrom: 0, to: 2)
                        vc.pageMenu.selectedItemIndex = 2
                    }
                }
            case 1://最新
                let baseVC:HDLY_Art_SubVC = HDLY_Art_SubVC.init()
                baseVC.isNewest = true
                baseVC.cateID = "0"
                self.addChildViewController(baseVC)
            case 2://轻听随看
                let baseVC:HDLY_Listen_SubVC = HDLY_Listen_SubVC.init()
                self.addChildViewController(baseVC)
            case 3://艺术
                let baseVC:HDLY_Art_SubVC = HDLY_Art_SubVC.init()
                baseVC.cateID = "\(model.cateID)"
                self.addChildViewController(baseVC)
            case 4://亲子
                let baseVC:HDLY_Art_SubVC = HDLY_Art_SubVC.init()
                baseVC.cateID = "\(model.cateID)"
                
                self.addChildViewController(baseVC)
            default: break
                
            }
        }
    }
    
    
    //MARK: ---- SPPageMenuDelegate -----
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        if self.childViewControllers.count == 0 {
            return
        }
        // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            self.contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }else {
            self.contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }
        let targetViewController:UIViewController = self.childViewControllers[toIndex]
        if targetViewController.isViewLoaded == true {
            return;
        }
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight))
        let s: UIScrollView = targetViewController.view.subviews[0] as! UIScrollView
        var contentOffset:CGPoint = s.contentOffset
        if contentOffset.y >= CGFloat(HeaderViewH) {
            contentOffset.y = CGFloat(HeaderViewH)
        }
        s.contentOffset = contentOffset
        self.contentScrollView.addSubview(targetViewController.view)
    }
}


// MARK:--- myTableView -----
extension HDRootBVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.addSubview(self.pageMenu)
        cell?.addSubview(self.contentScrollView)
        cell?.backgroundColor = UIColor.white
        self.contentScrollView.backgroundColor = UIColor.white
        
        return cell!
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

//滑动显示控制
extension HDRootBVC {
    // 获取 childVCScrollView
    @objc func subTableViewDidScroll(noti: NSNotification) {
        //切换显示 ScrollIndicator
        let notiScrollView: UIScrollView = noti.object as! UIScrollView
        self.childVCScrollView = notiScrollView
        //
        if self.myTableView.contentOffset.y < HeaderViewH {
            notiScrollView.contentOffset = CGPoint.zero
            notiScrollView.showsVerticalScrollIndicator = false
            myTableView.showsVerticalScrollIndicator = true
            searchBtn.isHidden = true
        } else {
            notiScrollView.showsVerticalScrollIndicator = true
            myTableView.showsVerticalScrollIndicator = false
            searchBtn.isHidden = false
        }
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//       LOG("*****:\(scrollView.contentOffset.y)")
        if self.myTableView == scrollView {
            if self.childVCScrollView != nil {
                if self.childVCScrollView!.contentOffset.y > 0 {
                    self.myTableView.contentOffset = CGPoint.init(x: 0, y: HeaderViewH)
                }
            }
            let offSetY = scrollView.contentOffset.y
            if offSetY >= HeaderViewH {
                self.myTableView.contentOffset = CGPoint.init(x: 0, y: HeaderViewH )// myTableView 不滚动
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "headerViewToTop"), object: nil)  //子视图不滚动
            }
        }
    }
}


// FSPagerView

extension HDRootBVC {
    
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
        tabHeader.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }
}



