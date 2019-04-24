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
    var isHideBackBtn: Bool = false
    public var isShowNavShadowLayer = true
    
    lazy var scrollNavTitleView: HDScrollNaviTitleView = {
        let v = HDScrollNaviTitleView.init(frame: CGRect.init(x: 60, y: 0, width: ScreenWidth - 120, height: 44))
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHideBackBtn == true {
            return
        }
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
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        leftBarBtn.setImage(UIImage.init(named: "nav_back"), for: UIControlState.normal)
        leftBarBtn.setTitle("  ", for: .normal)
        leftBarBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)

    }
    
    func setupNavigationBar() {
        //设置导航条背景颜色
        let navigationBar: UINavigationBar = (self.navigationController?.navigationBar)!
        navigationBar.setBackgroundImage(UIImage.init(named: "nav_barX"), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage.init()
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if isShowNavShadowLayer {
            //1.设置阴影颜色
            navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
            
            //2.设置阴影偏移范围
            navigationBar.layer.shadowOffset = CGSize.zero
            navigationBar.layer.shadowRadius = 3
            
            //3.设置阴影颜色的透明度
            navigationBar.layer.shadowOpacity = 0.5

        } else {
            navigationBar.layer.shadowColor = UIColor.white.cgColor
        }
        
    }

    var navTitle: String?  {
        didSet {
            let name = navTitle ?? "  "
            self.scrollNavTitleView.titleName = name
            self.scrollNavTitleView.titleFont = UIFont.boldSystemFont(ofSize: 18)
            self.scrollNavTitleView.titleColor = UIColor.HexColor(0x333333)
            self.navigationItem.titleView = self.scrollNavTitleView
        }
    }

    func titleRelease() {
        scrollNavTitleView.removeTimer()
        scrollNavTitleView.removeFromSuperview()
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
    
    func pushToOthersPersonalCenterVC(_ uid: Int) {
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDZQ_OthersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDZQ_OthersCenterVC") as! HDZQ_OthersCenterVC
        vc.toid = uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToWKWebVC(vc: UIViewController, url:String, titleName: String ) {
//        let webVC = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDLY_WKWeb_VC") as! HDLY_WKWeb_VC
//        webVC.urlPath = url
//        webVC.titleName = titleName
//        vc.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func pushToMyWalletVC() {
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDSSL_MyWalletVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_MyWalletVC") as! HDSSL_MyWalletVC
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //检测是否点击web页面卡片
    func didTapWebCard(_ type: Int, _ articleId: Int) {// 1 课程 2 展览 3 博物馆
        if type == 1 {
//            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//            desVC.courseId = "\(articleId)"
//            self.navigationController?.pushViewController(desVC, animated: true)
            
            let courseId =  "\(articleId)" ?? "0"
            self.pushCourseListWithBuyInfo(courseId: courseId, vc: self)
        }
        else if type == 2 {
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            vc.exhibition_id = articleId
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == 3 {
            //博物馆详情
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
            vc.museumId = articleId
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if type == 4 {
            //轻听随看
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            desVC.listen_id = String.init(format: "%ld", articleId)
            self.navigationController?.pushViewController(desVC, animated: true)
        }

    }
    
    func didSelectItemAtPagerViewCell(model: BbannerModel , vc: UIViewController) {
        //cate_id: 轮播图类型1课程，2轻听随看，3资讯，4展览，5活动
        if model.cate_id?.int == 1 {
//            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//            desVC.courseId = model.mid?.string
//            vc.navigationController?.pushViewController(desVC, animated: true)
            
            let courseId =   model.mid?.string ?? "0"
            self.pushCourseListWithBuyInfo(courseId: courseId, vc: vc)
        }
        else if model.cate_id?.int == 2 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            desVC.listen_id = model.mid?.string
            vc.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cate_id?.int == 3 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            desVC.topic_id = model.mid?.string
            desVC.fromRootAChoiceness = true
            vc.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.cate_id?.int == 4 {
            //展览详情
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            vc.exhibition_id = model.mid?.int
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cate_id?.int == 5 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = model.mid?.string
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //判断课程是否购买
    func pushCourseListWithBuyInfo(courseId: String, vc: UIViewController) {
        //获取课程购买信息
        guard let token = HDDeclare.shared.api_token else {
            self.pushToLoginVC(vc: vc)
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBuyInfo(api_token: token, id: courseId), showHud: false, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            let is_buy: Int  = dataDic["is_buy"] as! Int
            if is_buy == 1 {//已购买
                let courseListVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
                courseListVC.courseId = courseId
                courseListVC.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(courseListVC, animated: true)
            }else {//未购买
                let courseDesVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
                courseDesVC.courseId = courseId
                courseDesVC.hidesBottomBarWhenPushed = true
                vc.navigationController?.pushViewController(courseDesVC, animated: true)
            }
        }) { (errorCode, msg) in
            
        }
    }
    // 跳转到第三方
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: { (success) in
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
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


class HDScrollNaviTitleView: UIView {
    
    var titleName: String = "" {
        didSet {
            showTitleName()
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            
        }
    }
    
    var titleColor: UIColor = UIColor.black {
        didSet {
            
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView.init()
        sv.isPagingEnabled = false
        sv.showsHorizontalScrollIndicator = false
        sv.bounces = false
        return sv
    }()
    
    lazy var labelFirst: UILabel = {
        let lab = UILabel.init()
        lab.textAlignment = .center
        return lab
    }()
    
    lazy var labelSecond: UILabel = {
        let lab = UILabel.init()
        lab.textAlignment = .center
        return lab
    }()
    

    let padding: CGFloat  = 0.5
    let labelMargin: CGFloat = 10
    var textWidth:CGFloat = 0
    
    //MARK: ====
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.labelFirst.textColor = titleColor
        self.labelSecond.textColor = titleColor
        
        self.labelFirst.font = titleFont
        self.labelSecond.font = titleFont
        
        let textW = titleName.getContentWidth(font: titleFont)
        
        textWidth = textW + labelMargin + scrollView.frame.size.width
        scrollView.frame = self.bounds
        
        if textW <= self.frame.size.width {
            scrollView.contentSize = self.frame.size
            labelFirst.frame = self.bounds
            labelSecond.removeFromSuperview()
        } else {
            scrollView.contentSize = CGSize.init(width: textW * 2 + labelMargin + scrollView.frame.size.width, height: self.frame.size.height)
            labelFirst.frame = CGRect.init(x: 0, y: 0, width: textW, height: self.frame.size.height)
            labelSecond.frame = CGRect.init(x: textW + labelMargin, y: 0, width: textW, height: self.frame.size.height)

            if myTimer == nil {
                addTimer()
            }
        }
        
        
    }
    
    
    func setupChildView() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.labelFirst)
        self.scrollView.addSubview(self.labelSecond)
    }
    
    func showTitleName() {
        setupChildView()
        if titleName.count > 0 {
            self.labelFirst.text = titleName
            self.labelSecond.text = titleName
        }
    }
    
    var myTimer: Timer?
    
    //MARK: ==== timer ===
    func addTimer() {
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
        guard let tm = myTimer else {
            return
        }
        RunLoop.current.add(tm, forMode: RunLoopMode.commonModes)
    }
    
    @objc func runTimer() {
        var x = self.scrollView.contentOffset.x
        x += padding
        if x <= self.textWidth && (x + padding) >= self.textWidth {
            x = 0
        }
        self.scrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: false)
    }
    
    func removeTimer() {
        myTimer?.invalidate()
        myTimer = nil
    }
    
    deinit {
        removeTimer()
    }
    
}












