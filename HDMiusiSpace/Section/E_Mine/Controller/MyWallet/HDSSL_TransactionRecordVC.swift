//
//  HDSSL_TransactionRecordVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_TransactionRecordVC: HDItemBaseVC {
    @IBOutlet weak var dTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "交易记录"
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
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
extension HDSSL_TransactionRecordVC: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
        let monthLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 300, height: 40))
        monthLabel.text = "2018年8月"
        
        headerview.addSubview(monthLabel)
        
        
        return headerview
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        let cell = HDSSL_recordCell.getMyTableCell(tableV: tableView) as HDSSL_recordCell
//        if self.dataArr.count > 0 {
//            let model = dataArr[indexPath.row]
//            cell.model = model
//        }
        return cell
    }
    
    
}
