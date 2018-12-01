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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收到的动态消息"
        tableView.separatorStyle = .none

        self.dataRequest()
        addRefresh()
    }
    
    func dataRequest()  {
        guard let token = HDDeclare.shared.api_token else {
            return
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterDynamicList(skip: 0, take: 100, api_token: token) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:HDLY_DynamicMsgModel = try! jsonDecoder.decode(HDLY_DynamicMsgModel.self, from: result)
            if model.data != nil {
                self.dataArr = model.data!
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            //            tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            //            tableView.ly_showEmptyView()
        }
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
    
    
}


extension HDLY_ReceiveMsgVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_ReceiveMsgCell1") as? HDLY_ReceiveMsgCell1
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_ReceiveMsgCell2") as? HDLY_ReceiveMsgCell2
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 160
        }
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
        }
    }
    
}


class HDLY_ReceiveMsgCell1: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


class HDLY_ReceiveMsgCell2: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var dateL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
