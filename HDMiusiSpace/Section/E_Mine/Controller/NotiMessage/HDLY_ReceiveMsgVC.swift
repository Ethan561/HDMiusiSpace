//
//  HDLY_ReceiveMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

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
                cell1?.avatarImgV.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell1?.titleL.text = model.title
                cell1?.contentL.text = model.des
                cell1?.dateL.text = model.createdAt

                return cell1!
            }else {
                cell?.avatarImgV.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.titleL.text = model.title
                cell?.contentL.text = model.des
                cell?.dateL.text = model.createdAt
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

        
    }
    
    
}


class HDLY_ReceiveMsgCell1: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImgV.layer.cornerRadius = 22
        avatarImgV.layer.masksToBounds = true
        
    }
}


class HDLY_ReceiveMsgCell2: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImgV.layer.cornerRadius = 22
        avatarImgV.layer.masksToBounds = true
        
    }
}
