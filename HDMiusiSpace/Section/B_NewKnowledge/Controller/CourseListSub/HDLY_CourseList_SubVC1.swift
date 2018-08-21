//
//  HDLY_CourseList_SubVC1.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_SubVC1: HDItemBaseVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyBtn: UIButton!
    
    @IBAction func buyBtnAction(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        buyBtn.layer.cornerRadius = 28
        // Do any additional setup after loading the view.、
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDLY_CourseList_SubVC1 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
        let listHeader:HDLY_CourseList_Header = HDLY_CourseList_Header.createViewFromNib() as! HDLY_CourseList_Header
        listHeader.frame = headerV.bounds
        headerV.addSubview(listHeader)
        return headerV
    }
    
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    //row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_CourseList_Cell.getMyTableCell(tableV: tableView)
        if ScreenWidth - (cell?.tagL.right)! < 65 {
//            cell?.tagL.right = ScreenWidth - 65
            cell?.tagTrailCons.priority = UILayoutPriority(rawValue: 1000)
            cell?.tagTrailCons.constant = 8
        }

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

