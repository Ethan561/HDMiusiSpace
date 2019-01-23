//
//  HDLY_ReceiveMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_ReceiveMsgVC: HDItemBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArr = [DynamicMsgModelData]()
    var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收到的动态消息"
        tableView.separatorStyle = .none
        
        self.dataRequest()
        addRefresh()
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV
    }
    
    func dataRequest()  {
        
        let token = HDDeclare.shared.api_token
        if token == nil {
            //token = "123456"
            self.pushToLoginVC(vc: self)
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterDynamicList(skip: skip, take: 10, api_token: token!) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.ly_endLoading()
            self.tableView.es.stopPullToRefresh()
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_DynamicMsgModel = try jsonDecoder.decode(HDLY_DynamicMsgModel.self, from: result)
                if model.data != nil {
                    self.dataArr = model.data!
                    self.tableView.reloadData()
                }
            }
            catch let error {
                LOG("\(error)")
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
        let token = HDDeclare.shared.api_token
        if token == nil {
            //token = "123456"
            self.pushToLoginVC(vc: self)
            return
        }
        self.tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterDynamicList(skip: skip, take: 10, api_token: token!) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_DynamicMsgModel = try jsonDecoder.decode(HDLY_DynamicMsgModel.self, from: result)
                if model.data?.count ?? 0 > 0 {
                    self.tableView.es.stopLoadingMore()
                    self.dataArr += model.data!
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
}


extension HDLY_ReceiveMsgVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_ReceiveMsgCell2") as? HDLY_ReceiveMsgCell2
        if dataArr.count > 0 {
            let model = dataArr[indexPath.row]
//            1普通评论点赞 2普通评论回复 3展览评星点赞 4展览评星回复 5关注 6问题答复
            if model.cateID == 2 ||  model.cateID == 4 || model.cateID == 6 {
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "HDLY_ReceiveMsgCell1") as? HDLY_ReceiveMsgCell1
                cell1?.avatarBtn.kf.setImage(with: URL.init(string: model.avatar!), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell1?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                    if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                        self?.pushToLoginVC(vc: self!)
                    } else {
                        self?.pushToOthersPersonalCenterVC(model.uid ?? 0)
                    }
                })
                cell1?.titleL.text = model.title
                cell1?.contentL.text = model.des
                cell1?.dateL.text = model.createdAt

                return cell1!
            }else {
                cell?.titleL.text = model.title
                cell?.contentL.text = model.des
                cell?.dateL.text = model.createdAt
                cell?.avatarBtn.kf.setImage(with: URL.init(string: model.avatar!), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                    if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                        self?.pushToLoginVC(vc: self!)
                    } else {
                        self?.pushToOthersPersonalCenterVC(model.uid ?? 0)
                    }
                })
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        //1普通评论点赞 2普通评论回复 3展览评星点赞 4展览评星回复 5关注 6问题答复
        if model.cateID == 2 ||  model.cateID == 4 || model.cateID == 6 {
            return 160
        }
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = dataArr[indexPath.row]
        if model.cateID == 2 ||  model.cateID == 4 || model.cateID == 6 {
            seeTheReplyAction(model: model)
        }
    }
    
    func seeTheReplyAction(model: DynamicMsgModelData) {
        //parent_cate_id:关联的内容类别id:1资讯，2轻听随看，3展览,4精选专题,5攻略,6课程,7用户关注
        if model.parent_cate_id == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld", model.parent_id ?? 0)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.parent_cate_id == 2 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            if model.parent_id != nil {
                desVC.listen_id = "\(model.parent_id!)"
            }
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.parent_cate_id == 4 {
            let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            if model.parent_id != nil {
                desVC.topic_id = "\(model.parent_id!)"
            }
            desVC.fromRootAChoiceness = false
            self.navigationController?.pushViewController(desVC, animated: true)
        }
        else if model.parent_cate_id == 3 {
            //展览详情
            let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
            let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            if model.parent_id != nil {
                vc.exhibition_id = model.parent_id
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.parent_cate_id == 5 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            if model.parent_id != nil {
                vc.topic_id = "\(model.parent_id!)"
            }
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.parent_cate_id == 6 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
            vc.courseId = String.init(format: "%ld", model.parent_id ?? 0)
            vc.showAnswerQuestion = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}



class HDLY_ReceiveMsgCell1: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarBtn.layer.cornerRadius = 22
        avatarBtn.layer.masksToBounds = true
        
    }
}


class HDLY_ReceiveMsgCell2: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var avatarBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarBtn.layer.cornerRadius = 22
        avatarBtn.layer.masksToBounds = true
        
    }
}
