//
//  HDRootDVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootDVC: HDItemBaseVC,UIScrollViewDelegate,SPPageMenuDelegate {

    @IBOutlet weak var bavBarView  : UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar_btn1 : UIButton!
    @IBOutlet weak var navBar_btn2 : UIButton!
    @IBOutlet weak var btn_location: UIButton!
    //
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var menuBgView: UIView!
    @IBOutlet weak var exhibitionScrollV: UIScrollView!
    @IBOutlet weak var museumScrollV: UIScrollView!
    var menuIndex = 0
    
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x:0, y: 0, width: ScreenWidth-125, height: 40), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 18)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.red
        page.backgroundColor = UIColor.white
        page.permutationWay = SPPageMenuPermutationWay.notScrollAdaptContent
        return page
    }()
    
    var condition1: Int! //1展览，2博物馆
    
    //mvvm
    var viewModel = RootDViewModel()
    var exhibitionArr =  [HDLY_dExhibitionListD]()  //展览数组
    var museumArr     =  [HDLY_dMuseumListD]() //博物馆数组
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //刷新选中的城市
        let str: String = UserDefaults.standard.object(forKey: "MyLocationCityName") as! String
        
        if str.count > 0 {
            print("城市\(str)")
            btn_location.setTitle(str, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        
        //MVVM
        bindViewModel()
        
        navBar_btn1.isSelected = true
        condition1 = 1
        museumScrollV.isHidden = true
        
        //定位按钮设置
        btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
        btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
        btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!+20, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
        btn_location.titleLabel?.lineBreakMode = .byTruncatingTail
        //
        setupScrollView()
        let menuTitleArr = ["热门推荐","全部","最近"]
        self.menuBgView.addSubview(self.pageMenu)
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        self.addContentSubViewsWithArr(titleArr: menuTitleArr)
        self.addMuseumSubViewsWithArr(titleArr: menuTitleArr)
        
        loadMyViews()

    }
    
    func setupScrollView() {
        
        exhibitionScrollV.delegate = self
        exhibitionScrollV.isPagingEnabled = true
        exhibitionScrollV.isScrollEnabled = true
        exhibitionScrollV.bounces = false
        exhibitionScrollV.showsVerticalScrollIndicator = false
        exhibitionScrollV.showsHorizontalScrollIndicator = false
        exhibitionScrollV.backgroundColor = UIColor.white
        //
        museumScrollV.delegate = self
        museumScrollV.isPagingEnabled = true
        museumScrollV.isScrollEnabled = true
        museumScrollV.bounces = false
        museumScrollV.showsVerticalScrollIndicator = false
        museumScrollV.showsHorizontalScrollIndicator = false
        museumScrollV.backgroundColor = UIColor.white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.pageMenu.frame = self.menuBgView.bounds
        
    }
    
    //MARK: - init
    func loadMyViews() -> Void {
        //
        if navBar_btn1.isSelected == true {
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
            
            self.pageMenu.bridgeScrollView = self.exhibitionScrollV
            exhibitionScrollV.isHidden = false
            museumScrollV.isHidden = true

        }else {
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
            
            self.pageMenu.bridgeScrollView = self.museumScrollV
            exhibitionScrollV.isHidden = true
            museumScrollV.isHidden = false
            showMuseumSubVC(index: menuIndex)
        }
    }
    
    func showMuseumSubVC(index: Int) {
        let contentScrollView: UIScrollView = museumScrollV
        contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*index), y: 0), animated: true)
        
        let targetViewController: UIViewController = self.childViewControllers[index+3]
        if targetViewController.isViewLoaded == true {
            return;
        }
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(index), y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight))
//        let s: UIScrollView = targetViewController.view.subviews[0] as! UIScrollView
//        var contentOffset:CGPoint = s.contentOffset
//        if contentOffset.y >= CGFloat(HeaderViewH) {
//            contentOffset.y = CGFloat(HeaderViewH)
//        }
//        s.contentOffset = contentOffset
        contentScrollView.addSubview(targetViewController.view)
    }

    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //展览数组
        viewModel.exhibitionArray.bind { (array) in
            weakSelf?.exhibitionArr = array
        }
        
        //博物馆数组
        viewModel.museumArray.bind { (array) in
            weakSelf?.museumArr = array
            
        }
    }
    
    //MARK: - 展览、博物馆切换
    @IBAction func action_changeMainType(_ sender: UIButton) {
        //tag=0 展览，tag=1 博物馆
        print(sender.tag)
        navBar_btn1.isSelected = !navBar_btn1.isSelected
        condition1 = sender.tag + 1 //保存大页面状态
        loadMyViews()
        
    }
    
    //MARK: - 搜索
    @IBAction func action_search(_ sender: UIButton) {
        //tag=0 普通搜索，tag=1 语音搜索
        print(sender.tag)
    }
    
    //MARK: - 定位
    @IBAction func action_location(_ sender: Any) {
        let vc: HDSSL_getLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_getLocationVC") as! HDSSL_getLocationVC
        self.navigationController?.pushViewController(vc, animated: true)
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

// PageMenu
extension HDRootDVC {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.exhibitionScrollV.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.exhibitionScrollV.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
            //let model  = self.menuArr[i]
            switch i {
                
            case 0://推荐
                let baseVC:HDLY_ExhibitionSubVC = HDLY_ExhibitionSubVC.init()
                self.addChildViewController(baseVC)
                baseVC.type = 1
                self.exhibitionScrollV.addSubview(self.childViewControllers[0].view)
            case 1://全部
                let baseVC:HDLY_ExhibitionSubVC = HDLY_ExhibitionSubVC.init()
                baseVC.type = 0
                self.addChildViewController(baseVC)
            case 2://最近
                let baseVC:HDLY_ExhibitionSubVC = HDLY_ExhibitionSubVC.init()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            default: break
                
            }
        }
    }
    
    func addMuseumSubViewsWithArr(titleArr: Array<String>) {
        
        self.museumScrollV.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.museumScrollV.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
            //let model  = self.menuArr[i]
            switch i {
                
            case 0://推荐
                let baseVC:HDLY_MuseumSubVC = HDLY_MuseumSubVC.init()
                self.addChildViewController(baseVC)
                baseVC.type = 1
//                self.exhibitionScrollV.addSubview(self.childViewControllers[0].view)
            case 1://全部
                let baseVC:HDLY_MuseumSubVC = HDLY_MuseumSubVC.init()
                baseVC.type = 0
                self.addChildViewController(baseVC)
            case 2://最近
                let baseVC:HDLY_MuseumSubVC = HDLY_MuseumSubVC.init()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            default: break
                
            }
        }
    }
    
        
    //MARK: ---- SPPageMenuDelegate -----
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        menuIndex = toIndex
        if self.childViewControllers.count == 0 {
            return
        }
        var contentScrollView: UIScrollView = exhibitionScrollV
        if condition1 == 2 {
            contentScrollView = museumScrollV
        }
        
        // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }else {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }
        var targetViewController:UIViewController = self.childViewControllers[toIndex]
        if condition1 == 2 {
            targetViewController = self.childViewControllers[toIndex+3]
        }
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
        contentScrollView.addSubview(targetViewController.view)
    }
}

