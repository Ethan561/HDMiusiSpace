//
//  HDLY_RootCSubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/5.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh


class HDLY_RootCSubVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    
    let showListenView: Bindable = Bindable(false)
    let showKidsView: Bindable = Bindable(false)
    var dataArr =  [MuseumListData]()
    
    var type = 1 //1最近2最火    
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
    
    let sectionHeader: Array = ["精选推荐", "轻听随看", "亲子互动", "精选专题"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        self.hd_navigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()

    }
    
    func addRefresh() {
        let footer: ESRefreshProtocol & ESRefreshAnimatorProtocol = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
    }
    
    private func loadMore() {
        self.tableView.es.noticeNoMoreData()
    }
    
    @objc func pageTitleViewToTop() {
        self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
    }
    
    //监听子视图滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubTableViewDidScroll"), object: scrollView)
        //LOG("==== SubTableViewDidScroll :\(scrollView.contentOffset.y)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight) - CGFloat(kTabBarHeight)-CGFloat(PageMenuH)-15)
    }
    
    func dataRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideMuseumList(city_id: "北京市", longitude: "", latitude: "", type: type, skip: 0, take: 20), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:HDLY_MuseumListModel = try! jsonDecoder.decode(HDLY_MuseumListModel.self, from: result)
            if model.data != nil {
                self.dataArr = model.data
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_RootCSubVC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if dataArr.count > 0 {
            if index == 0 {
                return 70
            }
            let model:MuseumListData = dataArr[indexPath.section]
            if model.type == 1 {
                return 223*ScreenWidth/375.0
            }else if model.type == 2 {
                return 300*ScreenWidth/320.0
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if dataArr.count > 0 {
            let model:MuseumListData = dataArr[indexPath.section]
            
            if model.type == 1 {
                let listData = model.list
                if index == 0 {
                    let cell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
                    cell?.moreBtn.tag = 100 + indexPath.row
                    cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
                    cell?.nameLabel.text = listData?.title
                    cell?.subNameL.text = "\(listData?.count ?? 0)处展览讲解"
                    cell?.disL.text = listData?.distance
                    return cell!
                }
                
                let cell = HDLY_GuideCard2Cell.getMyTableCell(tableV: tableView)
                cell?.delegate = self
                if listData?.list != nil {
                    cell?.dataArray = listData!.list
                }

                return cell!
                
            }else if model.type == 2 {
                let mapData = model.map

                if index == 0 {
                    let cell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
                    cell?.moreBtn.isHidden = true
                    cell?.nameLabel.text = mapData?.title
                    cell?.subNameL.text = "\(mapData?.count ?? 0)处景点讲解"
                    cell?.disL.text = mapData?.distance
                    return cell!
                }
                
                let cell = HDLY_GuideMapCell.getMyTableCell(tableV: tableView)
                cell?.model = mapData
                return cell!
            }
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:MuseumListData = dataArr[indexPath.section]
        if model.type == 2 && indexPath.row == 1 {
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_MapGuideVC") as! HDLY_MapGuideVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HDLY_RootCSubVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = dataArr[index]
        if model.type == 1 {
            let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
            vc.museum_id = model.list?.museumID ?? 0
            vc.titleName = model.list?.title ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDLY_RootCSubVC:HDLY_GuideCard2Cell_Delegate {
    
    func didSelectItemAt(_ model:MuseumListModel, _ cell: HDLY_GuideCard2Cell) {
        let sb = UIStoryboard.init(name: "RootC", bundle: nil)
        if model.type == 0 {//0数字编号版 1列表版 2扫一扫版
            //typeL.text = "数字编号版"
            let vc:HDLY_NumGuideVC = sb.instantiateViewController(withIdentifier: "HDLY_NumGuideVC") as! HDLY_NumGuideVC
            vc.exhibit_num = model.id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 1 {
            //typeL.text = "列表版"
            let vc:HDLY_ExhibitListVC = sb.instantiateViewController(withIdentifier: "HDLY_ExhibitListVC") as! HDLY_ExhibitListVC
            vc.exhibition_id = model.id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if model.type == 2 {
            //typeL.text = "扫一扫版"
            let vc:HDLY_QRGuideVC = sb.instantiateViewController(withIdentifier: "HDLY_QRGuideVC") as! HDLY_QRGuideVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    
}

