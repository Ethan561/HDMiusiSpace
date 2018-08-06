//
//  HDTabBar.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

let TabBarNormalColor = UIColor.HexColor(0x4A4A4A)
let TabBarSelectedColor = UIColor.HexColor(0xE8593E)

//代理方法
@objc protocol HDTabBarDelegate: NSObjectProtocol {
    @objc optional func tabBarDidSelectedRiseButton()
}

class HDTabBar: UIView {
    //代理
    weak var delegate: HDTabBarDelegate?
    
    var tabBarItemAttributes: NSArray? {
        didSet {
            createSubMenuView()
        }
    }
    var tabBarItems: NSMutableArray?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.white
        let topLineImgV = UIImageView.init(frame: CGRect.init(x: 0, y: -5, width: ScreenWidth, height: 5))
        topLineImgV.image = UIImage.init(named: "tapbar_top_line")
//        self.addSubview(topLineImgV)
    }
    
    func createSubMenuView() {
        let itemW = ScreenWidth / CGFloat((tabBarItemAttributes?.count)!)
        let tabBarHeight = self.height
        var itemTag: Int = 0
        
        tabBarItems = NSMutableArray.init(capacity: (tabBarItemAttributes?.count)!)
        if tabBarItemAttributes?.count != 0 {
            //
            for item in tabBarItemAttributes! {
                let tempDic = item as? NSDictionary
                let type  =  tempDic![kTabBarItemType] as! String
                let frame = CGRect.init(x:CGFloat(itemTag) * itemW, y: 0, width: itemW, height: tabBarHeight)
                let tabBarItem: HDTabBarItem = self.tabBarItemWithFrame(frame: frame,
                    title: tempDic![kTabBarItemTitle] as! String,
                    normalImageName: tempDic![kTabBarNormalImgName] as! String,
                    selectedImageName: tempDic![kTabBarSelectedImgName] as! String,  tabBarItemType: type)
                if itemTag == 0 {
                    tabBarItem.isSelected = true
                    tabBarItem.setTitleColor(TabBarSelectedColor, for: UIControlState.selected)
                }
                //
                tabBarItem.addTarget(self, action: #selector(itemSelected(_:)), for: UIControlEvents.touchUpInside)
                tabBarItem.tag = itemTag
                itemTag += 1
                tabBarItems?.add(tabBarItem)
                self.addSubview(tabBarItem)
            }
        }
        
    }
    
    func tabBarItemWithFrame(frame: CGRect, title: String, normalImageName: String, selectedImageName: String, tabBarItemType: String) -> HDTabBarItem {
        
        let item: HDTabBarItem = HDTabBarItem.init(frame: frame)
        item.setTitle(title, for: UIControlState.normal)
        item.setTitle(title, for: UIControlState.selected)
        item.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        item.setTitleColor(TabBarNormalColor, for: UIControlState.normal)
        //
        item.setImage(UIImage.init(named: normalImageName), for: UIControlState.normal)
        item.setImage(UIImage.init(named: selectedImageName), for: UIControlState.selected)
        item.itemType = tabBarItemType
        
        return item
    }
    
   @objc func itemSelected(_ sender: HDTabBarItem) {
        self.setSelectedIndex(index: sender.tag)
}
    
    func setSelectedIndex(index: NSInteger) {
        for item in self.tabBarItems! {
            let temp = item as! HDTabBarItem
            if temp.tag == index {
                temp.isSelected = true
                temp.setTitleColor(TabBarSelectedColor, for: UIControlState.selected)
                //
                if HDDeclare.shared.tabBarVC != nil {
                    HDDeclare.shared.tabBarVC!.selectedIndex = index
                }
            }
            else {
                temp.isSelected = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






