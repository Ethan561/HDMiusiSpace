//
//  HDLY_MessageCenterVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MessageCenterVC: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    var model = HDLY_NotiMsgModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息中心"
        tableView.separatorStyle = .none
        dataRequest()
    }
    
    func dataRequest()  {
        var token = HDDeclare.shared.api_token
        if token == nil {
            token = ""
        }
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .messageCenter(api_token: token!) , showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let m:HDLY_NotiMsgModel = try! jsonDecoder.decode(HDLY_NotiMsgModel.self, from: result)
            self.model = m
            self.tableView.reloadData()
            
        }) { (errorCode, msg) in
            
        }
    }
    
}

extension HDLY_MessageCenterVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_MessageCenterCell") as? HDLY_MessageCenterCell
        if indexPath.row == 0 {
            //系统消息
            cell?.titleL.text = "系统消息"
            cell?.imgV.image = UIImage.init(named: "xi_icon_xtxi")
            if self.model.data?.systemMsgNum ?? 0 > 0 {
                cell?.countL.isHidden = false
                cell?.timeL.isHidden = false
                cell?.countL.text = "\(self.model.data?.systemMsgNum ?? 0)"
                cell?.timeL.text = model.data?.systemMsgTime
                cell?.subTitleL.text = model.data?.systemMsgTitle
            }else {
                cell?.timeL.text = model.data?.systemMsgTime
                cell?.subTitleL.text = model.data?.systemMsgTitle
            }
            
        } else {
            //动态消息
            cell?.titleL.text = "收到的动态消息"
            cell?.imgV.image = UIImage.init(named: "xi_icon_dtxi")
            cell?.lineView.isHidden = true
            if self.model.data?.dynamicMsgNum ?? 0 > 0 {
                cell?.countL.isHidden = false
                cell?.timeL.isHidden = false
                cell?.countL.text = "\(self.model.data?.dynamicMsgNum ?? 0)"
                cell?.timeL.text = model.data?.dynamicMsgTime
                cell?.subTitleL.text = model.data?.dynamicMsgTitle
            } else {
                cell?.timeL.text = model.data?.dynamicMsgTime
                cell?.subTitleL.text = model.data?.dynamicMsgTitle
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SystemMsgVC") as! HDLY_SystemMsgVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReceiveMsgVC") as! HDLY_ReceiveMsgVC
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
    
}



class HDLY_MessageCenterCell: UITableViewCell {
    
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subTitleL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        countL.layer.cornerRadius = 10
        countL.layer.masksToBounds = true
        
        timeL.isHidden = true
        countL.isHidden = true
    }
    
    
}

