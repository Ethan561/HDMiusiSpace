//
//  HDMyGamePrizeListVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2020/8/6.
//  Copyright © 2020 hengdawb. All rights reserved.
//

import UIKit

class HDMyGamePrizeListVC: HDItemBaseVC {

    @IBOutlet weak var myTableView: UITableView!
    public var list:[PrizeListModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的游戏奖励"
        myTableView.register(UINib.init(nibName: HDMyGamePrizeCell.className, bundle: nil), forCellReuseIdentifier: "HDMyGamePrizeCell")
        myTableView.rowHeight = 160;
        guard list != nil else {
            return
        }
        if self.list!.count == 0 {
            self.myTableView.reloadData()
            self.myTableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            self.myTableView.ly_showEmptyView()
        } else {
            self.myTableView.reloadData()
        }
    }
    
   

}

extension HDMyGamePrizeListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDMyGamePrizeCell") as! HDMyGamePrizeCell
        let model = self.list![indexPath.row]
        cell.orderSnLabel.text = model.order_sn
        cell.positionL.text = model.museum_name
        cell.poiL.text = model.pos_info
        cell.timeL.text = model.start_time
        cell.getPrizeTimeL.text = model.complete_time
        if model.go_status == "33" {
            cell.gettingStatusL.isHidden = false
            cell.gotPrizeImgV.isHidden = true
        } else {
            cell.gettingStatusL.isHidden = true
            cell.gotPrizeImgV.isHidden = false
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.list![indexPath.row]
        let vc = HDMyGamePrizeDetailVC()
        vc.order_sn = model.order_sn
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
