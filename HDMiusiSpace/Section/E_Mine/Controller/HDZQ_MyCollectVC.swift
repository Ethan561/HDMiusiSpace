//
//  HDZQ_MyCollectVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyCollectVC: HDItemBaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    private var menuIndex = 0
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x:0, y: 0, width: ScreenWidth, height: 44), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 18)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.red
        page.backgroundColor = UIColor.white
        page.layer.shadowColor = UIColor.lightGray.cgColor
        page.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        page.layer.shadowOpacity = 0.2
        page.permutationWay = SPPageMenuPermutationWay.scrollAdaptContent
        page.itemPadding = 55
        return page
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        let menuTitleArr = ["资讯","展览","攻略","精选专题","轻听随看"]
        self.view.addSubview(pageMenu)
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        addContentSubViewsWithArr(titleArr: menuTitleArr)
        title = "我的收藏"
    }
}

extension HDZQ_MyCollectVC:SPPageMenuDelegate {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.scrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.pageMenu.bridgeScrollView = self.scrollView
        for (i, _) in titleArr.enumerated() {
            switch i {
            case 0://资讯
                let baseVC:HDZQ_MyCollectSubVC = HDZQ_MyCollectSubVC()
                self.addChildViewController(baseVC)
                baseVC.type = 1
                self.scrollView.addSubview(self.childViewControllers[0].view)
            case 1://展览
                let baseVC:HDZQ_MyCollectSubVC = HDZQ_MyCollectSubVC()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            case 2://展览
                let baseVC:HDZQ_MyCollectSubVC = HDZQ_MyCollectSubVC()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            case 3://展览
                let baseVC:HDZQ_MyCollectSubVC = HDZQ_MyCollectSubVC()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            case 4://展览
                let baseVC:HDZQ_MyCollectSubVC = HDZQ_MyCollectSubVC()
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
        let contentScrollView: UIScrollView = scrollView
        // 如果上一次点击的button下标与当前点击的buton下标之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }else {
            contentScrollView.setContentOffset(CGPoint.init(x: (Int(contentScrollView.frame.size.width)*toIndex), y: 0), animated: true)
        }
        let targetViewController:UIViewController = self.childViewControllers[toIndex]
        if targetViewController.isViewLoaded == true {
            return;
        }
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight-44)
        contentScrollView.addSubview(targetViewController.view)
    }
}

