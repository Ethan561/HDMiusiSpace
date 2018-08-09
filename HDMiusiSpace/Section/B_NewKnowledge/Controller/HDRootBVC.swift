//
//  HDRootBVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

let PageMenuH = 45
let HeaderViewH = (ScreenWidth*200/335.0+30)

class HDRootBVC: HDItemBaseVC,SPPageMenuDelegate, UITableViewDataSource,UITableViewDelegate,FSPagerViewDataSource,FSPagerViewDelegate {

    @IBOutlet weak var myTableView: RootBMainTableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    
    let titleArray:Array = ["推荐", "最新", "轻听随看", "艺术", "亲子"]
    var tabHeader: RootBHeaderView!
    
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x: 0, y: 0, width: Int(ScreenWidth), height: PageMenuH), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
  
        page.setItems(titleArray, selectedItemIndex: 0)
        page.delegate = self
        page.itemTitleFont = UIFont.systemFont(ofSize: 16)
        
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
        scrollView.frame  = CGRect.init(x: 0, y: 15, width: ScreenWidth, height:  ScreenHeight-CGFloat(kTopHeight))
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

    //
    fileprivate let imageNames = ["test1","test1","test1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbarCons.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        setupViews()
        //
        addContentSubViewsWithArr(titleArr: titleArray)
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
        tabHeader.pageControl.numberOfPages = self.imageNames.count
        tabHeader.pagerView.isInfinite = true
        //
        myTableView.tableHeaderView = tabHeader
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenWidth*200/335.0+30);
        myTableView.separatorStyle = .none
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            switch i {
            case 0://推荐
                let baseVC:HDLY_Recommend_SubVC = HDLY_Recommend_SubVC.init()
                self.addChildViewController(baseVC)
                self.contentScrollView.addSubview(self.childViewControllers[0].view)
            case 1://最新
                let baseVC:HDLY_Recommend_SubVC = HDLY_Recommend_SubVC.init()
                self.addChildViewController(baseVC)
            case 2://轻听随看
                let baseVC:HDLY_Listen_SubVC = HDLY_Listen_SubVC.init()
                self.addChildViewController(baseVC)
            case 3://艺术
                let baseVC:HDLY_Recommend_SubVC = HDLY_Recommend_SubVC.init()
                self.addChildViewController(baseVC)
            case 4://亲子
                let baseVC:HDLY_Recommend_SubVC = HDLY_Recommend_SubVC.init()
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
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight)
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
        cell?.addSubview(self.contentScrollView)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(ScreenWidth), height: PageMenuH))
        headerV.addSubview(self.pageMenu)
        pageMenu.backgroundColor = UIColor.white
        return headerV
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
        if self.myTableView.contentOffset.y < HeaderViewH {
            notiScrollView.contentOffset = CGPoint.zero
            notiScrollView.showsVerticalScrollIndicator = false
            myTableView.showsVerticalScrollIndicator = true

        }else {
            notiScrollView.showsVerticalScrollIndicator = true
            myTableView.showsVerticalScrollIndicator = false
        }
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        LOG("*****:\(scrollView.contentOffset.y)")
        if self.myTableView == scrollView {
            if self.childVCScrollView != nil {
                if self.childVCScrollView!.contentOffset.y > 0 {
                    self.myTableView.contentOffset = CGPoint.init(x: 0, y: HeaderViewH)
                }
            }
            if self.myTableView.contentOffset.y < HeaderViewH {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "headerViewToTop"), object: nil)  //子视图不滚动
            }else {
                self.myTableView.contentOffset = CGPoint.init(x: 0, y: HeaderViewH)// myTableView 不滚动
            }
        }
    }
}

// FSPagerView

extension HDRootBVC {
    
    // MARK:- FSPagerView DataSource
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.imageNames.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: self.imageNames[index])
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.textLabel?.text = index.description+index.description
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

