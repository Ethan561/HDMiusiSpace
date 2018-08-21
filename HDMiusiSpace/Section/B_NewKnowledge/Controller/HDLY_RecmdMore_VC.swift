//
//  HDLY_RecmdMore_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_RecmdMore_VC: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
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
    
    var dataArr =  [CourseListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 120
//        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.title = "精选推荐"
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        dataRequest()
    }

    func dataRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseBoutique(skip: "0", take: "10", type: "1", cate_id: "0"), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:RecmdMoreModel = try! jsonDecoder.decode(RecmdMoreModel.self, from: result)
            self.dataArr = model.data
            if self.dataArr.count > 0 {
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.isBigImg == 1 {
            return 208*ScreenWidth/375.0
        }
        return 126*ScreenWidth/375.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        if model.isBigImg == 1 {
            let cell = HDLY_Recommend_Cell2.getMyTableCell(tableV: tableView)
            cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.titleL.text = model.title
            cell?.authorL.text = model.author

            cell?.countL.text = model.purchases == 0 ? "0" :"\(model.purchases)" + "人在学"
            cell?.courseL.text = "\(model.classNum)" + "课时"
            return cell!
            
        } else {
            let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
            cell?.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
            cell?.titleL.text = model.title
            cell?.authorL.text = model.author
            cell?.countL.text = model.purchases == 0 ? "0" :"\(model.purchases)" + "人在学"
            cell?.courseL.text = "\(model.classNum)" + "课时"
            cell?.priceL.text = "¥" + "\(model.price)"
            
            return cell!
        }
        
//        return UITableViewCell.init()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

