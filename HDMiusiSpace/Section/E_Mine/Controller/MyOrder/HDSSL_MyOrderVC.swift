//
//  HDSSL_MyOrderVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_MyOrderVC: HDItemBaseVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var menuIndex = 0
    lazy var pageMenu: SPPageMenu = {
        let page:SPPageMenu = SPPageMenu.init(frame: CGRect.init(x:0, y: 0, width: ScreenWidth, height: 44), trackerStyle: SPPageMenuTrackerStyle.lineAttachment)
        
        page.delegate = self
        page.itemTitleFont = UIFont.init(name: "PingFangSC-Regular", size: 16)!
        page.dividingLine.isHidden = true
        page.selectedItemTitleColor = UIColor.HexColor(0x333333)
        page.unSelectedItemTitleColor = UIColor.HexColor(0x9B9B9B)
        page.tracker.backgroundColor = UIColor.red
        page.backgroundColor = UIColor.white
        page.layer.shadowColor = UIColor.lightGray.cgColor
        page.layer.shadowOffset = CGSize.init(width: 0, height: 5)
        page.layer.shadowOpacity = 0.2
        page.permutationWay = SPPageMenuPermutationWay.notScrollAdaptContent
        return page
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的订单"
        self.isShowNavShadowLayer = false
        let menuTitleArr = ["全部","待支付","已完成","已取消"]
        self.view.addSubview(pageMenu)
        self.pageMenu.setItems(menuTitleArr, selectedItemIndex: 0)
        addContentSubViewsWithArr(titleArr: menuTitleArr)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension HDSSL_MyOrderVC:SPPageMenuDelegate {
    
    // ContentSubViews
    func addContentSubViewsWithArr(titleArr:Array<String>) {
        
        self.scrollView.contentSize = CGSize.init(width: Int(ScreenWidth)*titleArr.count, height: 0)
        self.scrollView.isScrollEnabled = true
        self.scrollView.isPagingEnabled = true
        self.pageMenu.bridgeScrollView = self.scrollView
        for (i, _) in titleArr.enumerated() {
            switch i {
            case 0:
                let baseVC:HDSSL_MyOrderSubVC = HDSSL_MyOrderSubVC()
                self.addChildViewController(baseVC)
                baseVC.type = 0 
                self.scrollView.addSubview(self.childViewControllers[0].view)
            case 1:
                let baseVC:HDSSL_MyOrderSubVC = HDSSL_MyOrderSubVC()
                baseVC.type = 1
                self.addChildViewController(baseVC)
            case 2:
                let baseVC:HDSSL_MyOrderSubVC = HDSSL_MyOrderSubVC()
                baseVC.type = 2
                self.addChildViewController(baseVC)
            case 3:
                let baseVC:HDSSL_MyOrderSubVC = HDSSL_MyOrderSubVC()
                baseVC.type = 3
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
        targetViewController.view.frame = CGRect.init(x: ScreenWidth*CGFloat(toIndex), y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - 44)
        contentScrollView.addSubview(targetViewController.view)
    }
}
