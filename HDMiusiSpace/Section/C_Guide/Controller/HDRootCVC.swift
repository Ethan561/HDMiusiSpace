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
        self.hd_navigationBarHidden = true
                
        setupScrollView()
        menuView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 3, shadowOffset: CGSize.init(width: 0, height: 5))
        
        let menuTitleArr = ["最近","最火"]
        self.menuView.addSubview(self.pageMenu)
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        self.addContentSubViewsWithArr(titleArr: menuTitleArr)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //刷新选中的城市
        let str: String = UserDefaults.standard.object(forKey: "MyLocationCityName") as! String
        
        if str.count > 0 {
            print("城市\(str)")
            btn_location.setTitle(str, for: .normal)
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
        
        //定位按钮设置
        btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
        btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
        btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
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

