//
//  HDLY_SystemMsgVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_SystemMsgVC: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统消息"
        // Do any additional setup after loading the view.
    }
    

}

extension HDLY_SystemMsgVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_SystemMsgCell2") as? HDLY_SystemMsgCell2
            return cell!
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "HDLY_SystemMsgCell1") as? HDLY_SystemMsgCell1
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 180
        }
        return 135
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

