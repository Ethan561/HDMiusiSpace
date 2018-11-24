//
//  HDLY_CourseList_SubVC1.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol ChapterListPlayDelegate: NSObjectProtocol {
    
    func playWithCurrentPlayUrl(_ model: ChapterList)
    
}

class HDLY_CourseList_SubVC1: HDItemBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    
    weak var delegate:ChapterListPlayDelegate?

    var isNeedBuy = false

    var infoModel: CourseChapter?
    var courseId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.、
        buyBtn.layer.cornerRadius = 27
        tableView.delegate = self
        tableView.dataSource = self
        self.bottomHCons.constant = 0
        dataRequest()
        
    }
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseChapterInfo(api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseChapter = try! jsonDecoder.decode(CourseChapter.self, from: result)
            self.infoModel = model
            
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    self.buyBtn.setTitle("原价¥\(self.infoModel!.data.price.string)", for: .normal)
                    self.bottomHCons.constant = 74
                    self.isNeedBuy = true
                }else {
                    self.bottomHCons.constant = 0
                    self.bottomView.isHidden = true
                    self.isNeedBuy = false
                }
            } else {
                self.bottomHCons.constant = 0
                self.bottomView.isHidden = true
                self.isNeedBuy = false

            }
            self.tableView.reloadData()
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_CourseList_SubVC1 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if infoModel?.data.sectionList != nil {
            return infoModel!.data.sectionList.count
        }
        return 0
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
        if infoModel?.data.sectionList != nil {
            guard let model = infoModel?.data.sectionList[section] else {
                return headerV
            }
            listHeader.titleL.text = model.title
            listHeader.subTitleL.text = "共\(model.chapterNum.string)小节"
        }
        
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
        if infoModel?.data.sectionList != nil {
            guard let model = infoModel?.data.sectionList[section] else {
                return 0
            }
            return model.chapterList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_CourseList_Cell.getMyTableCell(tableV: tableView, indexP: indexPath)
        if infoModel?.data.sectionList != nil {
            guard let sectionModel = infoModel?.data.sectionList[indexPath.section] else {
                return cell!
            }
            var listModel = sectionModel.chapterList[indexPath.row]
            listModel.isNeedBuy = self.isNeedBuy
            cell?.model = listModel
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionModel = infoModel?.data.sectionList[indexPath.section] else {
            return
        }
        let listModel = sectionModel.chapterList[indexPath.row]
        if self.isNeedBuy == true {
            //0收费 1免费 2vip免费
            if listModel.freeType == 0 {
                
            }
            else if listModel.freeType == 1 {
                delegate?.playWithCurrentPlayUrl(listModel)
            }
            else if listModel.freeType == 2 {
                delegate?.playWithCurrentPlayUrl(listModel)
            }
        }else {
            delegate?.playWithCurrentPlayUrl(listModel)
        }
    }
    
    
    
}


