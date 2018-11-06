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
    var dataArr =  [BItemModel]()
    
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
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getNewKnowledgeHomePage(), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    let model:BItemModel = try! jsonDecoder.decode(BItemModel.self, from: dataA)
                    self.dataArr.append(model)
                }
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index == 0 {
            return 70
        }else if index == 1 {
            return 223*ScreenWidth/375.0
        }else if index == 2 {
            return 70
        }else if index == 3 {
            return 300*ScreenWidth/320.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        if index == 0 {
            let cell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            return cell!
        }else if index == 1 {
            let cell = HDLY_GuideCard2Cell.getMyTableCell(tableV: tableView)
            cell?.delegate = self
            
            return cell!
        }else if index == 2 {
            let cell = HDLY_GuideSectionCell.getMyTableCell(tableV: tableView)
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
//            cell?.moreBtn.isHidden = true
            
            return cell!
        }
        else if index == 3 {
            let cell = HDLY_GuideMapCell.getMyTableCell(tableV: tableView)
            
            return cell!
        }
        
//        else if model.type?.int == 3 {//轻听随看
//            let cell = HDLY_Listen_Cell.getMyTableCell(tableV: tableView)
//            cell?.listArray = model.listen
//            cell?.delegate = self
//
//            return cell!
//        }else if model.type?.int == 4 {
//            let cell = HDLY_Kids_Cell1.getMyTableCell(tableV: tableView)
//            if  model.interactioncard?.img != nil  {
//                cell?.imgV.kf.setImage(with: URL.init(string: model.interactioncard!.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
//            }
//            cell?.titleL.text = model.interactioncard?.title
//            cell?.countL.text = (model.interactioncard?.views?.string)! + "人在学"
//            cell?.priceL.text = "¥" + (model.interactioncard?.price?.string == nil ? "0" :(model.interactioncard?.price?.string)!)
//
//            return cell!
//        }else if model.type?.int == 5 {
//            let cell = HDLY_Kids_Cell2.getMyTableCell(tableV: tableView)
//            cell?.dataArray = model.interactionlist
//            cell?.delegate = self
//
//            return cell!
//        }
//        else if model.type?.int == 6 {
//            let cell = HDLY_Topic_Cell.getMyTableCell(tableV: tableView)
//            cell?.listArray = model.topic
//            cell?.delegate = self
//
//            return cell!
//        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HDLY_RootCSubVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = dataArr[index]
        if model.category?.type == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_RecmdMore_VC") as! HDLY_RecmdMore_VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.category?.type == 3 {
            self.showListenView.value = true
        }
        else if model.category?.type == 4 {
            
        }
        else if model.category?.type == 6 {//换一批
            courseTopicsRequest()
        }
    }
    
    func courseTopicsRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseTopics(), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            //
            var  newTopicsArr = [BRecmdModel]()
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    let model:BRecmdModel = try! jsonDecoder.decode(BRecmdModel.self, from: dataA)
                    newTopicsArr.append(model)
                }
                var model = self.dataArr.last
                model?.topic = newTopicsArr
                self.tableView.reloadRows(at: [IndexPath.init(row: self.dataArr.count-1, section: 0)], with: UITableViewRowAnimation.none)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
}

extension HDLY_RootCSubVC:HDLY_GuideCard2Cell_Delegate {
    
    func didSelectItemAt(_ model:Int, _ cell: HDLY_GuideCard2Cell) {
        let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}




//class HDLY_RootCSubVC: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
