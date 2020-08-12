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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的游戏奖励"
        myTableView.register(UINib.init(nibName: HDMyGamePrizeCell.className, bundle: nil), forCellReuseIdentifier: "HDMyGamePrizeCell")
        myTableView.rowHeight = 160;
    }

}

extension HDMyGamePrizeListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDMyGamePrizeCell") as! HDMyGamePrizeCell
        return cell
    }
}
