//
//  HDLY_Recommend_SubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
let PushTo_HDLY_RecmdMore_VC_Line = "PushTo_HDLY_RecmdMore_VC_Line"

class HDLY_Recommend_SubVC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,HDLY_Listen_Cell_Delegate,HDLY_Topic_Cell_Delegate,HDLY_Kids_Cell2_Delegate{
    
    
    let showListenView: Bindable = Bindable(false)
    let showKidsView: Bindable = Bindable(false)
    var dataArr =  [BItemModel]()
    var topicNew: [BRecmdModel]?
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.listName = "新知-推荐"
        
        return tableView
    }()
    
    let sectionHeader: Array = ["精选推荐", "轻听随看", "亲子互动", "精选专题"]
    var player = HDFloatingButtonManager.manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        self.hd_navigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        addRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataRequest()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.showFloatingBtn = true
        if player.state == .paused {
            HDFloatingButtonManager.manager.floatingBtnView.showType = .FloatingButtonPause
            HDFloatingButtonManager.manager.floatingBtnView.show = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.showFloatingBtn = false
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
        self.tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getNewKnowledgeHomePage, showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            self.dataArr.removeAll()
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    do {
                        let model:BItemModel = try jsonDecoder.decode(BItemModel.self, from: dataA)
                        self.dataArr.append(model)
                    }
                    catch let error {
                        LOG("\(error)")
                    }
                }
                self.tableView.reloadData()
                self.tableView.es.stopLoadingMore()
            }else {
                let empV = EmptyConfigView.NoDataEmptyView()
                self.tableView.ly_emptyView = empV
                self.tableView.ly_showEmptyView()
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_Recommend_SubVC {
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
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.type?.int == 0 {
            return 45
        }else if model.type?.int == 1 {
            return 126*ScreenWidth/375.0
        }else if model.type?.int == 2 {
            return 208*ScreenWidth/375.0
        }else if model.type?.int == 3 && model.listen?.count ?? 0 > 0{
            return 240*ScreenWidth/375.0
        }else if model.type?.int == 4 {
            return 280*ScreenWidth/375.0
        }else if model.type?.int == 5 && model.interactionlist?.count ?? 0 > 0 {
            return 260*ScreenWidth/375.0
        }
        else if model.type?.int == 6 {
            return 160*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        if model.type?.int == 0 {
            let cell = RecommendSectionCell.getMyTableCell(tableV: tableView)
            cell?.nameLabel.text = model.category?.title
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            if model.category?.type == 5 {
                cell?.moreL.text = ""
            } else if model.category?.type == 6 {
                let m = dataArr[indexPath.row + 1]
                if m.topic_num?.int ?? 0 >= 4 {
                    cell?.moreL.text = "换一批"
                }else {
                    cell?.moreL.text = ""
                }
            } else {
                cell?.moreL.text = "更多"
            }
            cell?.contentTitle =  ""
            
            return cell!
        }else if model.type?.int == 1 {
            let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
            if  model.boutiquelist?.img != nil  {
                cell?.imgV.kf.setImage(with: URL.init(string: model.boutiquelist!.img!), placeholder: UIImage.grayImage(sourceImageV: (cell?.imgV)!), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            if model.boutiquelist?.course_top?.int  == 1 {
                cell?.newTipL.text = "新课程"
                cell?.newTipL.isHidden = false
            }else {
               if model.boutiquelist?.is_top?.int  == 1 {
                    cell?.newTipL.isHidden = false
                }else {
                    cell?.newTipL.isHidden = true
                }
                cell?.newTipL.text = "新课时"
            }
            
            cell?.titleL.text = model.boutiquelist?.title
            cell?.contentTitle = model.boutiquelist?.title
            cell?.authorL.text = String.init(format: "%@  %@", (model.boutiquelist?.teacher_name)! ,(model.boutiquelist?.teacher_title)!)
            cell?.countL.text = model.boutiquelist?.views?.string == nil ? "0人在学" :(model.boutiquelist?.views?.string)! + "人在学"
            cell?.courseL.text = model.boutiquelist?.classnum?.string == nil ? "0课时" :(model.boutiquelist?.classnum?.string)! + "课时"
            if model.boutiquelist?.file_type?.int == 1 {//mp3
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
            }else {
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
            }
            cell?.setPriceLabel(model: model)
            return cell!
        }else if model.type?.int == 2 {
            let cell = HDLY_Recommend_Cell2.getMyTableCell(tableV: tableView)
            if  model.boutiquecard?.img != nil  {
                cell?.imgV.kf.setImage(with: URL.init(string: model.boutiquecard!.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.titleL.text = model.boutiquecard?.title
            cell?.contentTitle =  model.boutiquecard?.title
            
            cell?.authorL.text = String.init(format: "%@  %@", (model.boutiquecard?.teacher_name)! ,(model.boutiquecard?.teacher_title)!)
            cell?.countL.text = model.boutiquecard?.views?.string == nil ? "0人在学" :(model.boutiquecard?.views?.string)! + "人在学"
            cell?.courseL.text = model.boutiquecard?.classnum?.string == nil ? "0课时" :(model.boutiquecard?.classnum?.string)! + "课时"
            if model.boutiquecard?.file_type?.int == 1 {//mp3
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
            }else {
                cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
            }
            return cell!
        }else if model.type?.int == 3 {//轻听随看
            let cell = HDLY_Listen_Cell.getMyTableCell(tableV: tableView)
            cell?.listArray = model.listen
            cell?.delegate = self
            cell?.contentTitle =  ""
            
            return cell!
        }else if model.type?.int == 4 {
            let cell = HDLY_Kids_Cell1.getMyTableCell(tableV: tableView)
            if  model.interactioncard?.img != nil  {
                cell?.imgV.kf.setImage(with: URL.init(string: model.interactioncard!.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.titleL.text = model.interactioncard?.title
            cell?.countL.text = String.init(format: "%ld人在学", model.interactioncard?.views?.int ?? 0)
            if model.interactioncard?.price != nil {
                cell?.priceL.text = "¥" + "\(model.interactioncard!.price!)"
            }
            cell?.contentTitle =  model.interactioncard?.title
            
            return cell!
        }else if model.type?.int == 5 && model.interactionlist?.count ?? 0 > 0{
            let cell = HDLY_Kids_Cell2.getMyTableCell(tableV: tableView)
            cell?.dataArray = model.interactionlist
            cell?.delegate = self
            cell?.contentTitle =  ""
            
            return cell!
        }
        else if model.type?.int == 6 {
            let cell = HDLY_Topic_Cell.getMyTableCell(tableV: tableView)
            if self.topicNew != nil {
                cell?.listArray = topicNew!
            }else {
                cell?.listArray = model.topic
            }
            cell?.delegate = self
            cell?.contentTitle =  ""
            
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        
        let model = dataArr[indexPath.row]
        
        var courseId: String?
        if model.type?.int == 0 {
            
        }else if model.type?.int == 1 {
            courseId = model.boutiquelist?.article_id?.string
        }else if model.type?.int == 2 {
            courseId = model.boutiquecard?.article_id?.string
        }else if model.type?.int == 3 {//轻听随看
            
        }else if model.type?.int == 4 {
            courseId = model.interactioncard?.article_id?.string
            
        }else if model.type?.int == 5 {
            
        }
        else if model.type?.int == 6 {
            
        }
        let id = courseId ?? "0"
        self.pushCourseListWithBuyInfo(courseId: id, vc: self)
        
        /*
         //获取课程购买信息
         guard let token = HDDeclare.shared.api_token else {
         self.pushToLoginVC(vc: self)
         return
         }
         HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBuyInfo(api_token: token, id: courseId ?? "0"), showHud: false, success: { (result) in
         let dic = HD_LY_NetHelper.dataToDictionary(data: result)
         LOG("\(String(describing: dic))")
         let dataDic:Dictionary<String,Any> = dic?["data"] as! Dictionary<String, Any>
         let is_buy: Int  = dataDic["is_buy"] as! Int
         if is_buy == 1 {//已购买
         let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
         vc.courseId = courseId
         self.navigationController?.pushViewController(vc, animated: true)
         }else {
         vc.courseId = courseId
         self.navigationController?.pushViewController(vc, animated: true)
         }
         
         }) { (errorCode, msg) in
         
         }*/
        
    }
}

extension HDLY_Recommend_SubVC {
    
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
            let m = dataArr[index + 1]
            if m.topic_num?.int ?? 0 >= 4 {
                courseTopicsRequest()
            }
        }
    }
    
    func courseTopicsRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseTopics, showHud: true, loadingVC: self, success: { (result) in
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
                    do {
                        let dataA: Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                        let model: BRecmdModel = try jsonDecoder.decode(BRecmdModel.self, from: dataA)
                        newTopicsArr.append(model)
                    } catch let error {
                        LOG("\(error)")
                    }
                }
                self.topicNew = newTopicsArr
                self.tableView.reloadRows(at: [IndexPath.init(row: self.dataArr.count-1, section: 0)], with:UITableView.RowAnimation.none)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
}

extension HDLY_Recommend_SubVC {
    
    // 轻听随看
    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Listen_Cell) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
        vc.listen_id = model.article_id?.string
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapItemPlayBtnAt(_ model:BRecmdModel) {
        playingAction(model)
    }
    
    func playingAction(_ model: BRecmdModel) {
        guard let url = model.voice else {
            return
        }
        if player.state == .playing && player.url == url {
            return
        }
        
        var voicePath = model.voice!
        if voicePath.contains("m4a") {
            voicePath = model.voice!.replacingOccurrences(of: "m4a", with: "wav")
        }
        player.play(file: Music.init(name: "", url:URL.init(string: voicePath)!))
        player.url = url
        HDFloatingButtonManager.manager.floatingBtnView.show = true
        HDFloatingButtonManager.manager.listenID = String.init(format: "%ld", model.article_id?.int ?? 0)
        HDFloatingButtonManager.manager.url = voicePath
        HDFloatingButtonManager.manager.iconUrl =  model.icon
    }
    
    //精选专题
    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Topic_Cell) {
        
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
        vc.topic_id = model.article_id?.string
        vc.isZhuanaTi = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //亲子互动
    func didSelectItemAt(_ model:BRecmdModel, _ cell: HDLY_Kids_Cell2) {
        //        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        //        vc.courseId = model.article_id?.string
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        let courseId = model.article_id?.string ?? "0"
        self.pushCourseListWithBuyInfo(courseId: courseId, vc: self)
    }
    
}


