//
//  HDZQ_MyCoursesSubVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/23.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDZQ_MyCoursesSubVC: HDItemBaseVC {
    
    private var courses =  [MyCollectCourseModel]()
    public var type = 1 // 1,2
    private var viewModel = HDZQ_MyViewModel()
    
    private var take = 10
    private var skip = 0
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavShadowLayer = false
        tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - kTopHeight)
        view.addSubview(self.tableView)
        addRefresh()
        bindViewModel()
        requestData()
        
    }
    
    func requestData() {
        if type == 1 {
            viewModel.requestMyStudyCourses(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        } else if type == 2 {
            viewModel.requestMyBuyCourses(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        } else {
            viewModel.requestMyCollectCourses(apiToken: HDDeclare.shared.api_token ?? "", skip: skip, take: take, type: type, vc: self)
        }
    }
    
    func bindViewModel() {
        viewModel.bugCourses.bind { [weak self] (models) in
            self?.refreshTableView(models: models)
        }
        viewModel.collectCourses.bind { [weak self] (models) in
            self?.refreshTableView(models: models)
        }
        viewModel.studyCourses.bind { [weak self] (models) in
           self?.refreshTableView(models: models)
        }
    }
    
    func refreshTableView(models:[MyCollectCourseModel]) {
        if models.count > 0 {
            self.courses = models
            self.tableView.reloadData()
        } else {
            self.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.tableView.ly_showEmptyView()
        }
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        take = 10
        requestData()
    }
    
    private func loadMore() {
        skip = 0
        take = take + 10
        requestData()
    }
    
}

extension HDZQ_MyCoursesSubVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126*ScreenWidth/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = courses[indexPath.row]
        let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
     
            cell?.imgV.kf.setImage(with: URL.init(string:model.img), placeholder: UIImage.grayImage(sourceImageV: (cell?.imgV)!), options: nil, progressBlock: nil, completionHandler: nil)
    
        cell?.titleL.text = model.title
        cell?.authorL.text = String.init(format: "%@  %@", model.teacherName ,model.teacherTitle)
        cell?.countL.text = "\(model.studyNum)" + "人再学"
        cell?.courseL.text = "\(model.classNum)" + "课时"
        if model.fileType == 1 {
            cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
        } else {
            cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
        }
        if model.isFree == 0 {
            cell?.priceL.text = "¥\(model.price)"
            cell?.priceL.textColor = UIColor.HexColor(0xE8593E)
            
        }else {
            cell?.priceL.text = "免费"
            cell?.priceL.textColor = UIColor.HexColor(0x4A4A4A)
        }
        
        return cell!
    
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
