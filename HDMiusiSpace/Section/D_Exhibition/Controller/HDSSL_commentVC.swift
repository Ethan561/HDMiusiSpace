//
//  HDSSL_commentVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentVC: HDItemBaseVC {

    @IBOutlet weak var dTableView: UITableView!
    var exdataModel: ExhibitionDetailDataModel?
    var starNumber : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI
        loadMyViews()
        loadTableView()
        //Data
        
    }
    
    func loadMyViews() {
        self.title = "评论"
        
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        publishBtn.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
        publishBtn.addTarget(self, action: #selector(action_publish), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
    }
    
    //actions
    @objc func action_publish(){
        print("发布")
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
extension HDSSL_commentVC: UITableViewDataSource,UITableViewDelegate {
    func loadTableView() {
        dTableView.delegate = self
        dTableView.dataSource = self
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
             return 410
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = HDSSL_commentTextCell.getMyTableCell(tableV: tableView) as HDSSL_commentTextCell
            cell.BlockBackStarNumber { (number) in
                print("评分%.1f",number)
                self.starNumber = number  //保存评分
            }
            return cell
        }else {
            let cell = HDSSL_commentImgCell.getMyTableCell(tableV: tableView) as HDSSL_commentImgCell
            
            
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

