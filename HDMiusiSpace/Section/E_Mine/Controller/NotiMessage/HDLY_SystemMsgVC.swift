//
//  HDLY_SystemMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDLY_SystemMsgVC: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    var dataArr = [SystemMsgModelData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统消息"
        tableView.separatorStyle = .none

        // Do any additional setup after loading the view.
        self.dataRequest()
        addRefresh()
    }
    
    func dataRequest()  {
        let token = HDDeclare.shared.api_token ?? ""
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenterSystemList(skip: 0, take: 100, api_token: token) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model: HDLY_SystemMsgModel = try! jsonDecoder.decode(HDLY_SystemMsgModel.self, from: result)
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

