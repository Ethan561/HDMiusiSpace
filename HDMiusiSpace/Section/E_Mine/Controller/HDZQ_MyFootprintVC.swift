//
//  HDZQ_MyFootprintVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyFootprintVC: HDItemBaseVC {

//    private var
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 400
    }
}

extension HDZQ_MyFootprintVC {
    func requestFootPrintData() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFootPrint(api_token: HDDeclare.shared.api_token ?? "", skip: 0, take: 10), success: { (result) in
            
        }) { (error, msg) in
            
        }
    }
}

extension HDZQ_MyFootprintVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_FoorprintCell") as? HDZQ_FoorprintCell
        if indexPath.row == 0 {
            cell?.topLineView.isHidden = true
        } else {
            cell?.topLineView.isHidden = false
        }
        return cell!
    }
}

extension HDZQ_MyFootprintVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}


class HDZQ_FoorprintCell: UITableViewCell {
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var cardDateLabel: UILabel!
    @IBOutlet weak var exhibitionTitleLabel: UILabel!
    @IBOutlet weak var exhibitionLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
