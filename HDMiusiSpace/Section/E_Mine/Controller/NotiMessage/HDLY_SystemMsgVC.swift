//
//  HDLY_SystemMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_SystemMsgVC: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    var dataArr = [SystemMsgModelData]()
    var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统消息"
        tableView.separatorStyle = .none
        
        self.dataRequest()
        addRefresh()
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV
    }
    
    func dataRequest()  {
        let token = HDDeclare.shared.api_token ?? ""
        self.tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterSystemList(skip: skip, take: 10, api_token: token) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.ly_endLoading()
            self.tableView.es.stopPullToRefresh()
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDLY_SystemMsgModel = try jsonDecoder.decode(HDLY_SystemMsgModel.self, from: result)
                if model.data != nil {
                    self.dataArr = model.data!
                    self.tableView.reloadData()
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
        let token = HDDeclare.shared.api_token ?? ""
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterSystemList(skip: skip, take: 10, api_token: token) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model: HDLY_SystemMsgModel = try jsonDecoder.decode(HDLY_SystemMsgModel.self, from: result)
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


extension HDLY_SystemMsgVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_SystemMsgCell1") as? HDLY_SystemMsgCell1
        if dataArr.count > 0 {
            let model = dataArr[indexPath.row]
            if model.cateID == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_SystemMsgCell2") as? HDLY_SystemMsgCell2
                cell?.dateL.text = model.createdAt
                cell?.titleL.text = model.title
                cell?.contentL.text = model.content
                if  model.img != nil  {
                    cell?.imgV.kf.setImage(with: URL.init(string: (model.img!)), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                }
                return cell!
            }else {
                cell?.dateL.text = model.createdAt
                cell?.contentL.text = model.content
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.cateID == 2 {
            return 180
        }
        let height = model.content!.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth - 150) + 95
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = dataArr[indexPath.row]
        if model.cateID == 2 {
             //相关联的内容类别id:1课程，2轻听随看，3资讯，4展览，5活动，6 博物馆,7攻略
            if model.parent_cate_id == 1 {
                let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
                if model.parent_id != nil {
                    desVC.courseId = "\(model.parent_id!)"
                }
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            else if model.parent_cate_id == 2 {
                let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
                if model.parent_id != nil {
                    desVC.listen_id = "\(model.parent_id!)"
                }
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            else if model.parent_cate_id == 3 {
                let desVC = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
                if model.parent_id != nil {
                    desVC.topic_id = "\(model.parent_id!)"
                }
                desVC.fromRootAChoiceness = true
                self.navigationController?.pushViewController(desVC, animated: true)
            }
            else if model.parent_cate_id == 4 {
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
                //博物馆详情
                let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
                let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
                if model.parent_id != nil {
                    vc.museumId = model.parent_id!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if model.parent_cate_id == 7 {
                let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDSSL_StrategyDetialVC") as! HDSSL_StrategyDetialVC
                if model.parent_id != nil {
                    vc.strategyid = model.parent_id!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}


class HDLY_SystemMsgCell1: UITableViewCell {
    
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var dateL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

class HDLY_SystemMsgCell2: UITableViewCell {
    
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

