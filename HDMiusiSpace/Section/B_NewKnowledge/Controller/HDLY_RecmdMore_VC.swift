//
//  HDLY_RecmdMore_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import Kingfisher
//import ESPullToRefresh
class HDLY_RecmdMore_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight)), style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    var dataArr =  [CourseListModel]()
    var skip = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
//        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "精选推荐"
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        dataRequest()
        addRefresh()
    }

    func dataRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBoutique(skip: "\(skip)", take: "10", type: "1", cate_id: "0"), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()
            let jsonDecoder = JSONDecoder()
            do {
                let model:RecmdMoreModel = try jsonDecoder.decode(RecmdMoreModel.self, from: result)
                self.dataArr = model.data
                if self.dataArr.count > 0 {
                    self.tableView.reloadData()
                }else {
                    let empV = EmptyConfigView.NoDataEmptyView()
                    self.tableView.ly_emptyView = empV
                    self.tableView.ly_showEmptyView()
                }
            }
            catch let error {
                LOG("\(error)")
                self.tableView.es.stopPullToRefresh()
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()
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
    
    
    @objc func refreshAction() {
        skip = 0
        dataRequest()
    }
    
    private func loadMore() {
        skip = skip + 10
        dataRequestLoadMore()
    }
    
    func dataRequestLoadMore()  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBoutique(skip: "\(skip)", take: "10", type: "1", cate_id: "0"), showHud: true, loadingVC: self, success: { (result) in
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_RecmdMore_VC {
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
            
            cell?.countL.text = model.purchases == 0 ? "0人在学" :"\(model.purchases)" + "人在学"
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

            cell?.countL.text = model.purchases == 0 ? "0人在学" :"\(model.purchases)" + "人在学"
            cell?.courseL.text = "\(model.classNum)" + "课时"
            if model.fileType == 1 {//mp3
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
            }else {
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
            }
            cell?.setPriceLabel1(model: model)
            if model.course_top?.int  == 1 {
                cell?.newTipL.text = "新课程"
                cell?.newTipL.isHidden = false
            }else {
               if model.is_top?.int  == 1 {
                    cell?.newTipL.isHidden = false
                }else {
                    cell?.newTipL.isHidden = true
                }
                cell?.newTipL.text = "新课时"
            }       
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        let id = "\(model.classID)"
        self.pushCourseListWithBuyInfo(courseId: id, vc: self)
        
        /*
        //获取课程购买信息
        guard let token = HDDeclare.shared.api_token else {
            self.pushToLoginVC(vc: self)
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBuyInfo(api_token: token, id: "\(model.classID)"), showHud: false, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
            let is_buy: Int  = dataDic["is_buy"] as! Int
            if is_buy == 1 {//已购买
                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
                vc.courseId = "\(model.classID)"
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
                vc.courseId = "\(model.classID)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (errorCode, msg) in
            
        }*/
        
    }

}

