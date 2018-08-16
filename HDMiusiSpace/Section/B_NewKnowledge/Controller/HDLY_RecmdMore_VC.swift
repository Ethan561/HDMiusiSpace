//
//  HDLY_RecmdMore_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_RecmdMore_VC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(kTopHeight)), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    let sectionHeader:Array = ["精选推荐", "轻听随看", "亲子互动", "精选专题"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = false

        self.tableView.rowHeight = 120
//        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "精选推荐"
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_RecmdMore_VC {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //header
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = RecommendHeader.createViewFromNib() as? RecommendHeader
        header?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 45)
        header!.nameLabel.text =  sectionHeader[section]
        header?.backgroundColor = UIColor.white
        return nil
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sec = indexPath.section;
        let row = indexPath.row;
        if (row == 3) {
            return 208*ScreenWidth/375.0
        }
        return 126*ScreenWidth/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 3 {
                let cell = HDLY_Recommend_Cell2.getMyTableCell(tableV: tableView)
                //                cell?.imgURLArray = self.topImgArr
                //                cell?.delegate = self as HD_RootA_Top_Cell_Delegate
                
                return cell!
            } else {
                let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
                //                cell?.delegate = self as HD_RootA_4_Btn_CellDelegate
                return cell!
            }
        }
        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

