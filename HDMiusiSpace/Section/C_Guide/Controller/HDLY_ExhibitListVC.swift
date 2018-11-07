//
//  HDLY_ExhibitListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ExhibitListVC: HDItemBaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var topImgV: UIImageView!
    
    let player = HDLY_AudioPlayer.shared
    var isNeedBuy = false
    var infoModel: CourseChapter?
    var courseId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = CGFloat(kTopHeight)
        self.courseId = "25"
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
            self.tableView.reloadData()
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    
    @IBAction func backAction(_ sender: UIButton) {
        self.back()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil {
            player.stop()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_ExhibitListVC:UITableViewDataSource, UITableViewDelegate {
    
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if infoModel?.data.sectionList != nil {
            return infoModel!.data.sectionList.count
        }
        return 0
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
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
        if infoModel?.data.sectionList != nil {
            guard let model = infoModel?.data.sectionList[section] else {
                return 0
            }
            return model.chapterList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_ExhibitCell.getMyTableCell(tableV: tableView, indexP: indexPath)
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
        let video = listModel.video
        if video.isEmpty == false && video.contains(".mp3") {
            player.play(file: Music.init(name: "", url:URL.init(string: video)!))
            player.url = video
        }
    }
    
    
    
}
