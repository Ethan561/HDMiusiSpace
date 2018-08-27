//
//  HDTabBarVC.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class HDTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadControllers()

    }
    
    func loadControllers() {
        let nav1: HDItemBaseNaviVC = UIStoryboard.init(name: "RootA", bundle: nil).instantiateViewController(withIdentifier: "HDRootANavVC") as! HDItemBaseNaviVC
        let nav2: HDItemBaseNaviVC = UIStoryboard.init(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDRootBNavVC") as! HDItemBaseNaviVC
        let nav3: HDItemBaseNaviVC = UIStoryboard.init(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDRootCNavVC") as! HDItemBaseNaviVC
        let nav4: HDItemBaseNaviVC = UIStoryboard.init(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDRootDNavVC") as! HDItemBaseNaviVC
        let nav5: HDItemBaseNaviVC = UIStoryboard.init(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDRootENavVC") as! HDItemBaseNaviVC
        self.viewControllers = [nav1, nav2, nav3, nav4, nav5]
        
        
        //
        setupTabbar()
    }
    
    func setupTabbar() {
        let tabBar = HDTabBar.init(frame: self.tabBar.bounds)
        tabBar.backgroundColor = UIColor.clear
        tabBar.tabBarItemAttributes = [
            [kTabBarItemTitle: "精选", kTabBarNormalImgName: "tab_icon_jingxuan_default", kTabBarSelectedImgName: "tab_icon_jingxuan_pressed", kTabBarItemType: "0"],
            [kTabBarItemTitle: "新知", kTabBarNormalImgName: "tab_icon_xinzhi_default", kTabBarSelectedImgName: "tab_icon_xinzhi_pressed", kTabBarItemType: "0"],
            [kTabBarItemTitle: "导览", kTabBarNormalImgName: "tab_icon_daolan_default", kTabBarSelectedImgName: "tab_icon_daolan_pressed", kTabBarItemType: "0"],
            [kTabBarItemTitle: "看展", kTabBarNormalImgName: "tab_icon_kanzhan_default", kTabBarSelectedImgName: "tab_icon_kanzhan_pressed", kTabBarItemType: "0"],
            [kTabBarItemTitle: "我的", kTabBarNormalImgName: "tab_icon_wode_default", kTabBarSelectedImgName: "tab_icon_wode_pressed", kTabBarItemType: "0"]
        ]
        
        self.selectedIndex = 0
        self.tabBar.addSubview(tabBar)
        self.tabBar.tintColor = TabBarSelectedColor
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.backgroundImage = UIImage.init()
        self.tabBar.shadowImage = UIImage.init()
        //
        let bgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(ScreenWidth), height: kTabBarHeight))
        bgView.backgroundColor = UIColor.white
        self.tabBar.insertSubview(bgView, at: 0)
        bgView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))

        //
        HDDeclare.shared.tabBarVC = self
        
    }
}



