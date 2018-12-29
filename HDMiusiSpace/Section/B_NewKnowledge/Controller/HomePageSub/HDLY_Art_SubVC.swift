//
//  HDLY_Art_SubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_Art_SubVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    var dataArr =  [CourseListModel]()
    var isNewest: Bool = false
    var cateID: String = "0"
    var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV
        
        if isNewest == true {
            dataRequest(type: "2", cate_id: cateID)
        }else {
            dataRequest(type: "3", cate_id: cateID)
        }
        addRefresh()
    }
    
    @objc func pageTitleViewToTop() {
        self.tableView.contentOffset = CGPoint.zero
    }
    
    //监听子视图滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubTableViewDidScroll"), object: scrollView)
        //   LOG("==== SubTableViewDidScroll :\(scrollView.contentOffset.y)")
        
    }
    
     @objc func dataRequest(type: String , cate_id: String)  {
        self.tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBoutique(skip: "\(skip)", take: "10", type: type, cate_id: cate_id), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.ly_endLoading()
            self.tableView.es.stopPullToRefresh()
            let jsonDecoder = JSONDecoder()
            let model:RecmdMoreModel = try! jsonDecoder.decode(RecmdMoreModel.self, from: result)
            self.dataArr = model.data
            if self.dataArr.count > 0 {
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    @objc func refreshAction() {
        skip = 0
        if isNewest == true {
            dataRequest(type: "2", cate_id: cateID)
        }else {
            dataRequest(type: "3", cate_id: cateID)
        }
    }
    
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshAction()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    private func loadMore() {
        skip = skip + 10
        if isNewest == true {
            dataRequestLoadMore(type: "2", cate_id: cateID)
        }else {
            dataRequestLoadMore(type: "3", cate_id: cateID)
        }
    }
    
    func dataRequestLoadMore(type: String , cate_id: String)   {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBoutique(skip: "\(skip)", take: "10", type: type, cate_id: cate_id), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            
            do {
                let model:RecmdMoreModel = try jsonDecoder.decode(RecmdMoreModel.self, from: result)
                if model.data.count > 0 {
                    self.tableView.es.stopLoadingMore()
                    self.dataArr += model.data
                    self.tableView.reloadData()
                } else {
                    self.tableView.es.noticeNoMoreData()
                }
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.es.stopLoadingMore()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(PageMenuH)-CGFloat(kTabBarHeight)-CGFloat(kTopHeight)-10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



extension HDLY_Art_SubVC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    //row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.isBigImg == 1 {
            return 208*ScreenWidth/375.0
        }
        return 126*ScreenWidth/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        if model.isBigImg == 1 {
            let cell = HDLY_Recommend_Cell2.getMyTableCell(tableV: tableView)
            cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.titleL.text = model.title
            cell?.authorL.text = String.init(format: "%@  %@",model.teacher_name, model.teacher_title)

            cell?.countL.text = model.purchases == 0 ? "0" :"\(model.purchases)" + "人在学"
            cell?.courseL.text = "\(model.classNum)" + "课时"
            if model.fileType == 1 {//mp3
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
            }else {
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
            }
            
            return cell!
            
        } else {
            let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
            cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.titleL.text = model.title
            cell?.authorL.text = String.init(format: "%@  %@",model.teacher_name, model.teacher_title)
            cell?.countL.text = model.purchases == 0 ? "0" :"\(model.purchases)" + "人在学"
            cell?.courseL.text = "\(model.classNum)" + "课时"
//            cell?.priceL.text = "¥" + "\(model.price)"
            if model.fileType == 1 {//mp3
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
            }else {
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
            }
            if model.isFree == 0 {
                cell?.priceL.text = "¥" + "\(model.price)"
                cell?.priceL.textColor = UIColor.HexColor(0xE8593E)

            }else {
                cell?.priceL.text = "免费"
                cell?.priceL.textColor = UIColor.HexColor(0x4A4A4A)
            }
            
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArr[indexPath.row]
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        vc.courseId = "\(model.classID)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}








