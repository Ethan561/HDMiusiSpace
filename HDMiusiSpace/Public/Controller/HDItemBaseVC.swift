//
//  HDItemBaseVC.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class HDItemBaseVC: UIViewController {
    
//    var refreshHeader: MJRefreshNormalHeader?
//    var refreshFooter: MJRefreshAutoNormalFooter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLeftBarButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setupNavigationBar()
        navigationController?.navigationBar.titleTextAttributes = [kCTFontAttributeName:TitleFont] as [NSAttributedStringKey : Any]
            
            //[NSForegroundColorAttributeName:UIColor.white]
//
//        navigationController?.navigationBar.barTintColor = UIColor(red: 66/256.0, green: 176/256.0, blue: 216/256.0, alpha: 1)
//
//        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    func addLeftBarButtonItem() {
        let leftBarBtn = UIButton.init(type: UIButtonType.custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBarBtn.setImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
//        leftBarBtn.setTitle("back", for: .normal)
        leftBarBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)

    }
    
    func setupNavigationBar() {
        //设置导航条背景颜色
        let navigationBar: UINavigationBar = (self.navigationController?.navigationBar)!
        navigationBar.setBackgroundImage(UIImage.init(named: "nav_barX"), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage.init()
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //1.设置阴影颜色
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        
        //2.设置阴影偏移范围
        navigationBar.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        
        //3.设置阴影颜色的透明度
        navigationBar.layer.shadowOpacity = 0.2
        
    }


   @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    //MARK:  --- refresh ---
    func setupRefreshHeader(header: MJRefreshNormalHeader) {
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        header.isAutomaticallyChangeAlpha = true
        // 隐藏时间
        header.lastUpdatedTimeLabel.isHidden = true
        // 设置文字
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("正在刷新...", for: .refreshing)
    }
    
    func setupRefreshFooter(footer: MJRefreshAutoNormalFooter) {
//        footer.setTitle("点击或上拉加载更多", for: .refreshing)
        footer.setTitle("加载更多 ...", for: .refreshing)
        footer.setTitle("没有更多内容了", for: .noMoreData)
//        footer.isAutomaticallyChangeAlpha = true
//        footer.isAutomaticallyRefresh = true
//        footer.triggerAutomaticallyRefreshPercent = 0.5;
        
    }
 */
    
    func pushToLoginVC(vc: UIViewController) {
        let logVC = UIStoryboard(name: "LogInSection", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SmsLogin_VC") as! HDItemBaseVC
        vc.navigationController?.pushViewController(logVC, animated: true)
    }
    
    func pushToWKWebVC(vc: UIViewController, url:String, titleName: String ) {
//        let webVC = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDLY_WKWeb_VC") as! HDLY_WKWeb_VC
//        webVC.urlPath = url
//        webVC.titleName = titleName
//        vc.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func didSelectItemAtPagerViewCell(model: BbannerModel , vc: UIViewController) {
        //cate_id: 轮播图类型1课程，2轻听随看，3资讯，4展览，5活动
        if model.cate_id?.int == 1 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
            desVC.courseId = model.mid?.string
            vc.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cate_id?.int == 2 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            desVC.listen_id = model.mid?.string
            vc.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cate_id?.int == 3 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDectail_VC") as! HDLY_TopicDectail_VC
            desVC.topic_id = model.mid?.string
            desVC.fromRootAChoiceness = true
            vc.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cate_id?.int == 4 {
            
        }
        else if model.cate_id?.int == 5 {
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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

