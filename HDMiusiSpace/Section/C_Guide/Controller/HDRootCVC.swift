//
//  HDRootCVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootCVC: HDItemBaseVC,UIScrollViewDelegate,SPPageMenuDelegate {
    
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var scrollVBottomCons: NSLayoutConstraint!
    @IBOutlet weak var btn_location: UIButton!
    
    var currentCityName: String?
    
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x:100, y: 8, width: Int(140), height: Int(PageMenuH)), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 18)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.red
        page.backgroundColor = UIColor.white
        page.permutationWay = SPPageMenuPermutationWay.notScrollEqualWidths
        page.bridgeScrollView = self.contentScrollView
        
        return page
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollVBottomCons.constant = CGFloat(kTabBarHeight)
        navbarCons.constant = CGFloat(kTopHeight)
        if kTopHeight == 64 {
            navbarCons.constant = 72
        }
        self.hd_navigationBarHidden = true
                
        setupScrollView()
       // menuView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 3, shadowOffset: CGSize.init(width: 0, height: 5))
        
        let menuTitleArr = ["最近","最火"]
        self.menuView.addSubview(self.pageMenu)
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        self.addContentSubViewsWithArr(titleArr: menuTitleArr)
        
        let cityName: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
        if cityName != nil {
            if cityName != HDLY_LocationTool.shared.city {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                    self.showChangeCityTipView()
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
  
        //刷新选中的城市
        let str: String? = UserDefaults.standard.object(forKey: "MyLocationCityName") as? String
        guard str != nil else {
            let city = HDLY_LocationTool.shared.city ?? ""
            btn_location.setTitle(city, for: .normal)
            UserDefaults.standard.set(city, forKey: "MyLocationCityName")
            HDDeclare.shared.locModel.cityName = city
            //定位按钮设置
            btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
            btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
            btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
            return
        }
        
        if currentCityName == nil {
            if str!.count > 0 {
                print("城市\(str)")
                currentCityName = str
                btn_location.setTitle(str, for: .normal)
                HDDeclare.shared.locModel.cityName = str!

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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_RootCSubVC_Refresh_Noti"), object: nil)
            }
        }
        
    }
    
    
    func setupScrollView() {
        contentScrollView.delegate = self
        contentScrollView.isPagingEnabled = true
        contentScrollView.isScrollEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.backgroundColor = UIColor.white
        

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
        
        if HDLY_LocationTool.shared.city != nil && topVC.isKind(of: HDRootCVC.self){
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
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLY_RootCSubVC_Refresh_Noti"), object: nil)
    }
    
    
    //MARK: - 足迹
    @IBAction func footprintsAction(_ sender: Any) {
//        showWebVC(url: "http://news.baidu.com/")
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        
        let vc: HDZQ_MyFootprintVC = UIStoryboard.init(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDZQ_MyFootprintVC") as! HDZQ_MyFootprintVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showWebVC(url: String) {
        
        let webVC =  HDLY_WKWebVC()
        webVC.urlPath = url
        webVC.titleName = "测试"
        webVC.progressTintColor = UIColor.HexColor(0xE8593E)
        webVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    //MARK: - 定位
    @IBAction func action_location(_ sender: Any) {
        
        let vc: HDSSL_getLocationVC = UIStoryboard.init(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_getLocationVC") as! HDSSL_getLocationVC
        
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
extension HDRootCVC {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.contentScrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.contentScrollView.isScrollEnabled = true
        
        for (i, _) in titleArr.enumerated() {
//            let model  = self.menuArr[i]
            switch i {
                
            case 0://最近
                let baseVC:HDLY_RootCSubVC = HDLY_RootCSubVC.init()
                self.addChildViewController(baseVC)
                baseVC.type = 1
                self.contentScrollView.addSubview(self.childViewControllers[0].view)
            case 1://最火
                let baseVC:HDLY_RootCSubVC = HDLY_RootCSubVC.init()
                baseVC.type = 2
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

