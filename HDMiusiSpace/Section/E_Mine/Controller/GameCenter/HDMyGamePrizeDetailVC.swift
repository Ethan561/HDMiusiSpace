//
//  HDMyGamePrizeDetailVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2020/8/7.
//  Copyright © 2020 hengdawb. All rights reserved.
//

import UIKit

class HDMyGamePrizeDetailVC: HDItemBaseVC {
    private var tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension HDMyGamePrizeDetailVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
