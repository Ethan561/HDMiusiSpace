//
//  HDZQ_OthersCenterVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/30.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_OthersCenterVC: HDItemBaseVC {
    public var toid = 0
    public var model = OtherDynamic()
    private var dynamics = [MyDynamic]()
    private var htmls =  [NSAttributedString]()
    private var take = 10
    private var skip = 0
    @IBOutlet weak var tableView: UITableView!
    let tabHeader = HDZQ_PersonOthersHeaderView.createViewFromNib() as! HDZQ_PersonOthersHeaderView
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    
    lazy var commentView: HDZQ_CommentActionView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_CommentActionView", owner: nil, options: nil)?.last as? HDZQ_CommentActionView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tmp?.reportDelegate = self
        return tmp!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDynamicData(toid: toid)
        addRefresh()
        self.title = "个人主页"
        
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 34))
        publishBtn.setImage(UIImage.init(named: "xz_icon_more_black_default"), for: .normal)
        publishBtn.addTarget(self, action: #selector(showErrorView), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        tabHeader.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 190)
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 190))
        v.addSubview(tabHeader)
//        tableView.tableHeaderView = v
        self.view.addSubview(v)
    }
    
    func refreshTableView(models:[MyDynamic]) {
        
        if self.skip > 0 {
            self.dynamics.append(contentsOf: models)
        } else {
            self.dynamics = models
        }
        
        for i in 0..<self.dynamics.count {
            let m = self.dynamics[i]
            var attrStr: NSAttributedString? = nil
            if let anEncoding = m.comment!.data(using: .unicode) {
                attrStr = try? NSAttributedString(data: anEncoding, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                self.htmls.append(attrStr!)
            }
        }
        
        if self.dynamics.count > 0 {
            self.tableView.reloadData()
        } else {
            self.tableView.reloadData()
            self.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.tableView.ly_showEmptyView()
        }
        
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
        if models.count == 0 {
            self.tableView.es.noticeNoMoreData()
        }
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
        requestOthersDynamicData(toid: toid)
    }
    
    private func loadMore() {
        skip = skip + take
        requestOthersDynamicData(toid: toid)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeFeedbackChooseTip()
    }
    
    func refreshUI() {
        tabHeader.avatar.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        tabHeader.nickNameL.text = model.nickname
        tabHeader.desLabel.text = model.profile
        tabHeader.followNumberL.text = "\(model.focus_num)"
        tabHeader.collectNumberL.text = "\(model.favorite_num)"
        if model.sex == nil {
            tabHeader.genderImg.image = nil
        }else if model.sex == 1 {
            tabHeader.genderImg.image = UIImage.init(named: "icon_men")
        } else {
            tabHeader.genderImg.image = UIImage.init(named: "icon_women")
        }
        if model.is_focus == 1 {
            tabHeader.followBtn.setTitle("已关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.tabHeader.followBtn.size), for: .normal)

        } else {
            tabHeader.followBtn.setTitle("+关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.tabHeader.followBtn.size), for: .normal)

        }
        

        tabHeader.followBtn.addTouchUpInSideBtnAction { (btn) in
            self.followAction(id: self.model.toid!, cate_id: "3", api_token: HDDeclare.shared.api_token ?? "")
        }
        
        if model.is_vip == 1 {
            tabHeader.vipImg.isHidden = false
        } else {
            tabHeader.vipImg.isHidden = true
        }
    }
    
    func followAction(id:String, cate_id:String, api_token:String) {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 1 {
                    self.tabHeader.followBtn.setTitle("已关注", for: .normal)
                    self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.tabHeader.followBtn.size), for: .normal)
                }else {
                    self.tabHeader.followBtn.setTitle("+关注", for: .normal)
                    self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.tabHeader.followBtn.size), for: .normal)

                }
                self.model.is_focus = is_focus
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    func requestDynamicData(toid:Int) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getOtherDynamicIndex(api_token: HDDeclare.shared.api_token ?? "", toid: toid), success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                let model:OtherDynamicData = try jsonDecoder.decode(OtherDynamicData.self, from: result)
                self.model = model.data ?? OtherDynamic()
                self.requestOthersDynamicData(toid: toid)
                self.refreshUI()
            } catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (error, msg) in
            
        }
    }
    
    func requestOthersDynamicData(toid:Int) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getOthersDynamicList(uid: toid, skip: skip,take:take), success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                let model:OtherDynamicList = try jsonDecoder.decode(OtherDynamicList.self, from: result)
                self.refreshTableView(models:  model.data!)
            } catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (error, msg) in
            
        }
    }
    
    @objc func showErrorView() {
        tapErrorBtnAction()
    }
}

extension HDZQ_OthersCenterVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dynamics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dynamic = self.dynamics[indexPath.row]
        let cell = HDLY_MyDynamicCell.getMyTableCell(tableV: tableView)
        cell?.avaImgV.kf.setImage(with: URL.init(string: dynamic.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        cell?.contentL.attributedText = self.htmls[indexPath.row]
        cell?.timeL.text = dynamic.createdAt
        cell?.nameL.text = dynamic.nickname
        cell?.moreBtn.isHidden = true
        if dynamic.cateID == 10 {
            cell?.titleLTopCons.constant = 10
            cell?.desView.isHidden = false
            guard let infoM = dynamic.exhibitionInfo else { return cell!}
            if infoM.img != nil {
                cell?.imgV.kf.setImage(with: URL.init(string: infoM.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
            }
            cell?.titleL.text = infoM.title
            cell?.locL.text = infoM.address
            if infoM.iconList?.count ?? 0 > 0 {
                let iconTitleString: NSMutableAttributedString = NSMutableAttributedString.init()
                for icon in infoM.iconList! {
                    let urlStr = NSURL(string: icon)
                    let data = NSData(contentsOf: urlStr! as URL)
                    let image = UIImage(data: data! as Data)
                    let attach = NSTextAttachment()
                    let width = image!.size.width * 16 / image!.size.height
                    attach.bounds = CGRect.init(x: 2, y: 0, width: width, height: 16)
                    attach.image = image
                    let imgStr = NSAttributedString.init(attachment: attach)
                    iconTitleString.append(imgStr)
                    iconTitleString.append(NSAttributedString.init(string: " "))
                }
                cell?.des1L.attributedText = iconTitleString
            }
            let star: Float! = Float(infoM.star ?? "0")
            var imgStr = ""
            if star == 0 {
                cell?.des1L.text = "暂无评分"
            }else if star < 2 {
                imgStr = "exhibitionCmt_1_5"
            }else if star >= 2 && star < 4 {
                imgStr = "exhibitionCmt_2_5"
            }else if star >= 4 && star < 6 {
                imgStr = "exhibitionCmt_3_5"
            }else if star >= 6 && star < 8 {
                imgStr = "exhibitionCmt_4_5"
            }else if star >= 8 {
                imgStr = "exhibitionCmt_5_5"
            }
            //
            let starTitleString: NSMutableAttributedString = NSMutableAttributedString.init()
            let starImg = UIImage.init(named: imgStr)
            let attach = NSTextAttachment()
            attach.bounds = CGRect.init(x: 2, y: 0, width: 12, height: 12)
            attach.image = starImg
            let starimgStr = NSAttributedString.init(attachment: attach)
            starTitleString.append(starimgStr)
            starTitleString.append(NSAttributedString.init(string: " "))
            starTitleString.append(NSAttributedString.init(string: infoM.star ?? "0"))
            cell?.des2L.attributedText = starTitleString
        } else {
            cell?.titleLTopCons.constant = 16
            cell?.desView.isHidden = true
            //1资讯，2轻听随看,4精选专题,5攻略,  10展览
            if  dynamic.cateID == 1 {
                if let newsInfo = dynamic.newsInfo {
                    if newsInfo.img != nil {
                        cell?.imgV.kf.setImage(with: URL.init(string: newsInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                    }
                    cell?.titleL.text = newsInfo.title
                    cell?.locL.text = String.init(format: "%@|%@", newsInfo.keywords ?? "",newsInfo.platTitle ?? "")
                }
            }
            else if  dynamic.cateID == 2 {
                if let listenInfo = dynamic.listenInfo {
                    if listenInfo.img != nil {
                        cell?.imgV.kf.setImage(with: URL.init(string: listenInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                    }
                    cell?.titleL.text = listenInfo.title
                    cell?.locL.text = String.init(format: "%d人听过", listenInfo.listening!)
                }
            }
            else if  dynamic.cateID == 4 {
                if let topicInfo = dynamic.topicInfo {
                    if topicInfo.img != nil {
                        cell?.imgV.kf.setImage(with: URL.init(string: topicInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                    }
                    cell?.titleL.text = topicInfo.title
                    cell?.locL.text = "精选专题"
                }
            }
            else if  dynamic.cateID == 5 {
                if let strategyInfo = dynamic.strategyInfo {
                    if strategyInfo.img != nil {
                        cell?.imgV.kf.setImage(with: URL.init(string: strategyInfo.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                    }
                    cell?.titleL.text = strategyInfo.title
                    cell?.locL.text = ""
                }
                
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 48))
        header.backgroundColor = UIColor.white
        let top = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 8))
        top.backgroundColor = UIColor.HexColor(0xF0F0F0)
        header.addSubview(top)
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 18, width: 200, height: 20))
        if model.sex == 0 {
           label.text = "ta的动态"
        } else if model.sex == 1 {
            label.text = "他的动态"
        } else {
            label.text = "她的动态"
        }
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dynamics[indexPath.row]
        if model.cateID == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld", model.newsInfo?.articleID ?? 0)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cateID == 2 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            vc.listen_id = String.init(format: "%ld", model.listenInfo?.articleID ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cateID == 4 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld", model.topicInfo?.articleID ?? 0)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cateID == 5 {
            let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_StrategyDetialVC") as! HDSSL_StrategyDetialVC
            vc.strategyid = model.strategyInfo?.articleID ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.cateID == 10 {
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            vc.exhibition_id = model.topicInfo?.articleID ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HDZQ_OthersCenterVC {
    
    func tapErrorBtnAction() {
        if showFeedbackChooseTip == false {
            let  tipView = HDLY_FeedbackChoose_View.createViewFromNib()
            feedbackChooseTip = tipView as? HDLY_FeedbackChoose_View
            feedbackChooseTip?.frame = CGRect.init(x: ScreenWidth-20-120, y: 10, width: 120, height: 50)
            feedbackChooseTip?.tapBtn1.setTitle("举报", for: .normal)
            feedbackChooseTip?.tapBtn2.isHidden = true
            self.view.addSubview(feedbackChooseTip!)
            showFeedbackChooseTip = true
            weak var weakS = self
            feedbackChooseTip?.tapBlock = { (index) in
                weakS?.feedbackChooseAction(index: 2)
            }
        } else {
            closeFeedbackChooseTip()
        }
    }
    
    func closeFeedbackChooseTip() {
        feedbackChooseTip?.tapBlock = nil
        feedbackChooseTip?.removeFromSuperview()
        showFeedbackChooseTip = false
    }
    
    func feedbackChooseAction(index: Int) {
        
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getErrorOption(id: String(toid), cate_id: "8"), success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            let jsonDecoder = JSONDecoder()
            //JSON转Model：
            let model:ReportErrorModel = try! jsonDecoder.decode(ReportErrorModel.self, from: result)
            var strs = [String]()
            var reportType = [Int]()
            model.data?.optionList.forEach({ (m) in
                strs.append(m.optionTitle)
                reportType.append(m.optionID)
            })
            
            self.commentView.dataArr = strs
            self.commentView.reportType = reportType
            self.commentView.tableHeightConstraint.constant = CGFloat(50 * strs.count)
            self.commentView.type = 1
            self.commentView.tableHeightConstraint.constant = CGFloat((self.commentView.dataArr.count)*50)
            self.commentView.tableView.reloadData()
            kWindow?.addSubview(self.commentView)
            self.commentView.tableView.reloadData()
        }) { (errorCode, msg) in
            
        }
        
        
//        if index == 1 {
//            //反馈
//            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Feedback_VC") as! HDLY_Feedback_VC
//            vc.typeID = "0"
//            self.navigationController?.pushViewController(vc, animated: true)
//            closeFeedbackChooseTip()
//        }else {
//            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
//                self.pushToLoginVC(vc: self)
//                return
//            }
//            //报错
//            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
//
//            vc.articleID = String(toid)
//            vc.typeID = "8"
//            self.navigationController?.pushViewController(vc, animated: true)
//            closeFeedbackChooseTip()
//        }
    }
    
}

extension HDZQ_OthersCenterVC: MyReportProtocol {
    func reportActionSelected(type: Int, index: Int, comment: String, reportType: Int?) {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .sendError(api_token: HDDeclare.shared.api_token ?? "", option_id_str: String(reportType!), parent_id: String(toid), cate_id: "8", content: self.commentView.dataArr[index], uoload_img: [""]), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            HDAlert.showAlertTipWith(type: .onlyText, text: "提交成功")
            self.commentView.removeFromSuperview()
        }) { (errorCode, msg) in
            
        }
    }
    
}

