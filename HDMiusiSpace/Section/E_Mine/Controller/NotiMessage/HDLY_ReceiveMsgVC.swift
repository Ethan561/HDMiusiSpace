//
//  HDLY_ReceiveMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ReceiveMsgVC: HDItemBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收到的动态消息"
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDLY_ReceiveMsgVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_MessageCenterCell") as? HDLY_MessageCenterCell
        if indexPath.row == 0 {
            cell?.imgV.image = UIImage.init(named: "xi_icon_xtxi")
            
        } else {
            cell?.imgV.image = UIImage.init(named: "xi_icon_dtxi")
            cell?.lineView.isHidden = true
            cell?.timeL.isHidden = false
            cell?.countL.isHidden = false
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
        }
    }
    
}


class HDLY_ReceiveMsgCell1: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


class HDLY_ReceiveMsgCell2: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
