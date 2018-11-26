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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息中心"
        tableView.separatorStyle = .none
        
    }
    
}

extension HDLY_MessageCenterVC : UITableViewDataSource, UITableViewDelegate {
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

