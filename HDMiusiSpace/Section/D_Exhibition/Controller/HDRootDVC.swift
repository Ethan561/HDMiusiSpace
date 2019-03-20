//
//  HDRootDVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit



class HDRootDVC: HDItemBaseVC,UIScrollViewDelegate,SPPageMenuDelegate {

    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var bavBarView  : UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar_btn1 : UIButton!
    @IBOutlet weak var navBar_btn2 : UIButton!
    @IBOutlet weak var myTableView: RootBMainTableView!
    var childVCScrollView: UIScrollView?
    var searchBarH:CGFloat = 50
    var menuIndex = 0
    var currentCityName: String?
    var tabHeader = HDZQ_RootDSearchView()

    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x:90, y: 0, width: ScreenWidth-125, height: 40), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
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
    
    lazy var btn_location: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        btn.frame = CGRect.init(x: 20, y: 0, width: 60, height: 40)
        btn.setTitle("天津", for: .normal)
        btn.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
        btn.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn.imageView?.image?.size.width)!, bottom: 0, right: (btn.imageView?.image?.size.width)!)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn.titleLabel?.bounds.size.width)!+10, bottom: 0, right: -(btn.titleLabel?.bounds.size.width)!)
        btn.addTarget(self, action: #selector(action_location), for: .touchUpInside)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        return btn
    }()
    
    lazy var voiceView: HDZQ_VoiceSearchView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_VoiceSearchView", owner: nil, options: nil)?.last as? HDZQ_VoiceSearchView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        return tmp!
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
    
    var condition1: Int! //1展览，2博物馆
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(subTableViewDidScroll(noti:)), name: NSNotification.Name.init(rawValue: "SubTableViewDidScroll"), object: nil)
        if HDDeclare.shared.isSystemLocateEnable == false {
            showOpenLocServiceTipView()
        }
        refreshCity()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        if kTopHeight == 64 {
            navBarHeight.constant = 72
        }
        self.hd_navigationBarHidden = true
        
        if HDLY_LocationTool.shared.city == nil {
            HDLY_LocationTool.shared.startLocation()
        }
        
        self.voiceView.isHidden = true
        self.voiceView.delegate = self
        kWindow?.addSubview(self.voiceView)
        
        navBar_btn1.isSelected = true
        condition1 = 1
        setupViews()
        let menuTitleArr = ["热门推荐","全部","最近"]
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        self.addContentSubViewsWithArr(titleArr: menuTitleArr)
        loadMyViews()

        let cityName: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
        if cityName != nil {
            HDDeclare.shared.locModel.cityName = cityName!
            if cityName != HDLY_LocationTool.shared.city {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.showChangeCityTipView()
                }
            }
        }
        
    }
    
    func setupViews() {
        if #available(iOS 11.0, *) {
            self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
            self.contentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
//        //
        tabHeader = Bundle.main.loadNibNamed("HDZQ_RootDSearchView", owner: nil, options: nil)?.first as! HDZQ_RootDSearchView
        tabHeader.voiceSearchBtn.addTarget(self, action: #selector(showVoiceSearchView), for: .touchUpInside)
        tabHeader.searchBtn.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        let placeholder: String? = (UserDefaults.standard.object(forKey: "SeachPlaceHolder") as? String)
        self.tabHeader.placeholderLab.text = placeholder
        
        //
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: searchBarH))
        tabHeader.frame = headView.bounds
        headView.addSubview(tabHeader)
        headView.backgroundColor = .red
        myTableView.tableHeaderView = headView
        myTableView.tableHeaderView!.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: searchBarH)
        myTableView.separatorStyle = .none
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.backgroundColor = UIColor.white
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: "SubTableViewDidScroll"), object: nil)
    }
    
    //MARK: - init
    func loadMyViews() -> Void {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHANGEEXHIBITIONMUSEUM"), object: navBar_btn1.isSelected)
        self.pageMenu.bridgeScrollView = self.contentScrollView
        if navBar_btn1.isSelected == true {
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
        }else {
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
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
        let storyborad = UIStoryboard.init(name: "RootA", bundle: nil)
        let vc: HDSSL_SearchVC = storyborad.instantiateViewController(withIdentifier: "HDSSL_SearchVC") as! HDSSL_SearchVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func searchAction() {
        action_search(searchBtn)
    }
    
    //MARK: - 定位
    @objc func action_location() {
        let vc: HDSSL_getLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_getLocationVC") as! HDSSL_getLocationVC
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
}

extension HDRootDVC:UITableViewDataSource,UITableViewDelegate {
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
        cell?.addSubview(self.btn_location)
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
extension HDRootDVC {
    // 获取 childVCScrollView
    @objc func subTableViewDidScroll(noti: NSNotification) {
        //切换显示 ScrollIndicator
        let notiScrollView: UIScrollView = noti.object as! UIScrollView
        self.childVCScrollView = notiScrollView
        //
        if self.myTableView.contentOffset.y < searchBarH {
            if self.myTableView.contentOffset.y > 0 {
               notiScrollView.contentOffset = CGPoint.zero
            }
            notiScrollView.showsVerticalScrollIndicator = false
            myTableView.showsVerticalScrollIndicator = true
            searchBtn.isHidden = true
        } else {
            notiScrollView.showsVerticalScrollIndicator = true
            myTableView.showsVerticalScrollIndicator = false
            searchBtn.isHidden = false
        }
        if self.myTableView.contentOffset.y <  50 {
            searchBtn.isHidden = true
        } else {
            searchBtn.isHidden = false
        }
    }
    
    //
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        LOG("*****:\(scrollView.contentOffset.y)")
        if self.myTableView == scrollView {
            if self.childVCScrollView != nil {
                if self.childVCScrollView!.contentOffset.y > 0 {
                    self.myTableView.contentOffset = CGPoint.init(x: 0, y: searchBarH)
                }
            }
            let offSetY = scrollView.contentOffset.y
            if offSetY >= searchBarH {
                self.myTableView.contentOffset = CGPoint.init(x: 0, y: searchBarH )// myTableView 不滚动
            } else {
                if offSetY <= 0 {
                    self.myTableView.contentOffset = CGPoint.init(x: 0, y: 0)// myTableView 不滚动
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "headerViewToTop"), object: nil)  //子视图不滚动
                }
            }
        }
    }
}


// PageMenu
extension HDRootDVC {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.contentScrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.contentScrollView.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
            //let model  = self.menuArr[i]
            switch i {
                
            case 0://推荐
                let baseVC:HDLY_ExhibitionSubVC = HDLY_ExhibitionSubVC.init()
                self.addChildViewController(baseVC)
                baseVC.type = 1
                self.contentScrollView.addSubview(self.childViewControllers[0].view)
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
        
    //MARK: ---- SPPageMenuDelegate -----
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        menuIndex = toIndex
        if self.childViewControllers.count == 0 {
            return
        }

        // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }else {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }
        let targetViewController:UIViewController = self.childViewControllers[toIndex]
        if targetViewController.isViewLoaded == true {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHANGEEXHIBITIONMUSEUM"), object: navBar_btn1.isSelected)

            return;
        }
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight))
        let s: UIScrollView = targetViewController.view.subviews[0] as! UIScrollView
        var contentOffset:CGPoint = s.contentOffset
        if contentOffset.y >= CGFloat(searchBarH) {
            contentOffset.y = CGFloat(searchBarH)
        }
        s.contentOffset = contentOffset
        contentScrollView.addSubview(targetViewController.view)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CHANGEEXHIBITIONMUSEUM"), object: navBar_btn1.isSelected)

    }
}

extension HDRootDVC {
    func refreshCity()  {
        //刷新选中的城市
        let str: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
        guard str != nil else {
            let city = HDLY_LocationTool.shared.city ?? "无法获取位置"
            btn_location.setTitle(city, for: .normal)
            UserDefaults.standard.set(city, forKey: "MyLocationCityName")
            HDDeclare.shared.locModel.cityName = city
            //定位按钮设置
            btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
            btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
            btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_RootDSubVC_Refresh_Noti"), object: nil)

            return
        }
        
        if currentCityName == nil {
            if str!.count > 0 {
//                print("城市\(str)")
                currentCityName = str
                HDDeclare.shared.locModel.cityName = str!
                
                btn_location.setTitle(str, for: .normal)
                //定位按钮设置
                btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
                btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
                btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
                
            }
        }else {
            if currentCityName == str {
                
            }else {
                btn_location.setTitle(str, for: .normal)
                //定位按钮设置
                btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
                btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
                btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
                currentCityName = str
                
                //界面刷新
                HDDeclare.shared.locModel.cityName = str!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_RootDSubVC_Refresh_Noti"), object: nil)
            }
        }
        
    }
    
    //弹窗提醒切换城市
    func showChangeCityTipView() {
        if HDDeclare.shared.showChangeCityTip == true {
            return
        }
        let tipView:HDLY_ChangeCityAlert = HDLY_ChangeCityAlert.createViewFromNib() as! HDLY_ChangeCityAlert
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        guard let topVC = self.getTopVC() else {
            return
        }
        if HDLY_LocationTool.shared.city != nil && topVC.isKind(of: HDRootDVC.self){
            win.addSubview(tipView)
            tipView.tipL.text = "定位到您在 \(HDLY_LocationTool.shared.city!)，是否切换至该城市？"
        }
        HDDeclare.shared.showChangeCityTip = true
        weak var weakS = self
        tipView.sureBtnBlock = {
            weakS?.changeCityAction()
        }
    }
    
    func changeCityAction() {
        guard let str = HDLY_LocationTool.shared.city else {
            return
        }
        currentCityName = str
        btn_location.setTitle(str, for: .normal)
        //定位按钮设置
        btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
        btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
        btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
        UserDefaults.standard.set(str, forKey: "MyLocationCityName")
        
        //界面刷新
        HDDeclare.shared.locModel.cityName = str
        HDDeclare.shared.locModel.latitude = "\(HDLY_LocationTool.shared.coordinate!.latitude)"
        HDDeclare.shared.locModel.longitude = "\(HDLY_LocationTool.shared.coordinate!.longitude)"
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_RootDSubVC_Refresh_Noti"), object: nil)
    }
    
    //弹窗提醒开启定位
    func showOpenLocServiceTipView() {
        let tipView: HDLY_OpenLocServiceTip = HDLY_OpenLocServiceTip.createViewFromNib() as! HDLY_OpenLocServiceTip
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        guard let topVC = self.getTopVC() else {
            return
        }
        
        if topVC.isKind(of: HDRootCVC.self){
            win.addSubview(tipView)
        }
    }
    
}

extension HDRootDVC : HDZQ_VoiceResultDelegate {
    func voiceResult(result: String) {
        self.voiceView.isHidden = true
        let vc: HDSSL_SearchVC = UIStoryboard.init(name: "RootA", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_SearchVC") as! HDSSL_SearchVC
        vc.searchContent = result
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
