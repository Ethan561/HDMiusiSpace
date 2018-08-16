//
//  HDLY_Recommend_SubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

let PushTo_HDLY_RecmdMore_VC_Line = "PushTo_HDLY_RecmdMore_VC_Line"

class HDLY_Recommend_SubVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    let showListenView: Bindable = Bindable(false)
    let showKidsView: Bindable = Bindable(false)
    var dataArr =  [BItemModel]()
    
    //tableView
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: UITableViewStyle.grouped)
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
        self.tableView.rowHeight = 120
        self.tableView.frame = view.bounds
        self.view.addSubview(self.tableView)
        self.hd_navigationBarHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.dataRequest()
        
    }
    
    @objc func pageTitleViewToTop() {
        self.tableView.contentOffset = CGPoint.zero
    }
    
    //监听子视图滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubTableViewDidScroll"), object: scrollView)
        //LOG("==== SubTableViewDidScroll :\(scrollView.contentOffset.y)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(PageMenuH)-CGFloat(kTabBarHeight)-CGFloat(kTopHeight)-10)
    }
    
    func dataRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .getNewKnowledgeHomePage(), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let dataA:Array<Dictionary<String,Any>> = dic?["data"] as! Array<Dictionary>
            
            if dataA.count > 0  {
                for  tempDic in dataA {
                    let dataDic = tempDic as Dictionary<String, Any>
                    //JSON转Model：
                    let dataA:Data = HD_LY_NetHelper.jsonToData(jsonDic: dataDic)!
                    let model:BItemModel = try! jsonDecoder.decode(BItemModel.self, from: dataA)
                    self.dataArr.append(model)
                }
                self.tableView.reloadData()
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_Recommend_SubVC {
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
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.row]
        if model.type?.int == 0 {
            return 45
        }else if model.type?.int == 1 {
            return 126*ScreenWidth/375.0
        }else if model.type?.int == 2 {
            return 208*ScreenWidth/375.0
        }else if model.type?.int == 3 {
            return 240*ScreenWidth/375.0
        }else if model.type?.int == 4 {
            return 280*ScreenWidth/375.0
        }else if model.type?.int == 5 {
            return 260*ScreenWidth/375.0
        }
        else if model.type?.int == 6 {
            return 160*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArr[indexPath.row]
        if model.type?.int == 0 {
            let cell = RecommendSectionCell.getMyTableCell(tableV: tableView)
            cell?.nameLabel.text = model.category?.title
            if model.category?.type == 4 {
                cell?.moreL.text = ""
            } else if model.category?.type == 6 {
                cell?.moreL.text = "换一换"
            }else {
                cell?.moreL.text = "更多"
            }
            cell?.moreBtn.tag = 100 + indexPath.row
            cell?.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: .touchUpInside)
            return cell!
        }else if model.type?.int == 1 {
            let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
            if  model.boutiquelist?.img != nil  {
                cell?.imgV.kf.setImage(with: URL.init(string: model.boutiquelist!.img!), placeholder: UIImage.init(named: "jxtj_img1"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.titleL.text = model.boutiquelist?.title
            cell?.authorL.text = model.boutiquelist?.des
            cell?.countL.text = (model.boutiquelist?.views?.string)! + "人在学"
            cell?.courseL.text = (model.boutiquelist?.classnum?.string)! + "课时"
            cell?.priceL.text = "¥" + (model.boutiquelist?.classnum?.string)!

            return cell!
        }else if model.type?.int == 2 {
            let cell = HDLY_Recommend_Cell2.getMyTableCell(tableV: tableView)
            if  model.boutiquecard?.img != nil  {
                cell?.imgV.kf.setImage(with: URL.init(string: model.boutiquecard!.img!), placeholder: UIImage.init(named: "jxtj_img1"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.titleL.text = model.boutiquecard?.title
            cell?.authorL.text = model.boutiquecard?.des
            cell?.countL.text = (model.boutiquecard?.views?.string)! + "人在学"
            cell?.courseL.text = (model.boutiquecard?.classnum?.string)! + "课时"
            return cell!
        }else if model.type?.int == 3 {
            let cell = HDLY_Listen_Cell.getMyTableCell(tableV: tableView)
            return cell!
        }else if model.type?.int == 4 {
            let cell = HDLY_Kids_Cell1.getMyTableCell(tableV: tableView)
            return cell!
        }else if model.type?.int == 5 {
            let cell = HDLY_Kids_Cell2.getMyTableCell(tableV: tableView)
            return cell!
        }
        else if model.type?.int == 6 {
            let cell = HDLY_Topic_Cell.getMyTableCell(tableV: tableView)
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension HDLY_Recommend_SubVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let index = sender.tag - 100
        let model = dataArr[index]
        if model.category?.type == 1 {
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_RecmdMore_VC") as! HDLY_RecmdMore_VC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if model.category?.type == 3 {
            self.showListenView.value = true
            
        }
        else if model.category?.type == 4 {
            
        }
        else if model.category?.type == 6 {//换一批
            
        }
        
    }
    
    
}

