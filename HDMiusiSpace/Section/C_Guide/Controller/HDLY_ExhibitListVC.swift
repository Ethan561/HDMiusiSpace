//
//  HDLY_ExhibitListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import ESPullToRefresh

class HDLY_ExhibitListVC: HDItemBaseVC, HDLY_AudioPlayer_Delegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var topImgV: UIImageView!
    
    let player = HDLY_AudioPlayer.shared
    var infoModel: HDLY_ExhibitList?
    var dataArr =  [HDLY_ExhibitListM]()
    
    var exhibition_id = 0
    private var currentModel = HDLY_ExhibitListM()
    var selectRow = -1
    //
    var isUpload = false
    let uploadVM = HDLY_RootCVM()
    var page = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = CGFloat(kTopHeight)
        dataRequest()
        addRefresh()
        player.delegate = self
        
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV
    }
    
    func dataRequest()  {
        let token:String =  HDDeclare.shared.api_token ?? ""
        self.tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitList(exhibition_id: exhibition_id, skip: page, take: 20, api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            self.tableView.es.stopPullToRefresh()
            self.tableView.ly_endLoading()
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_ExhibitList = try jsonDecoder.decode(HDLY_ExhibitList.self, from: result)
                self.infoModel = model
                self.dataArr = model.data.exhibitList
                self.tableView.reloadData()
                self.topImgV.kf.setImage(with: URL.init(string: model.data.img), placeholder: UIImage.grayImage(sourceImageV: self.topImgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refreshAction()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    
    @objc func refreshAction() {
        page = 0
        dataRequest()
    }
    
    private func loadMore() {
        page = page + 10
        dataRequestLoadMore()
    }
    
    func dataRequestLoadMore()  {
        let token:String =  HDDeclare.shared.api_token ?? ""
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitList(exhibition_id: exhibition_id, skip: page, take: 20, api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_ExhibitList = try jsonDecoder.decode(HDLY_ExhibitList.self, from: result)
                if model.data.exhibitList.count > 0 {
                    self.tableView.es.stopLoadingMore()
                    self.dataArr += model.data.exhibitList
                    self.tableView.reloadData()
                } else {
                    self.tableView.es.noticeNoMoreData()
                }
            }
            catch let error {
                LOG("\(error)")
            }
            
        }) { (errorCode, msg) in
            self.tableView.es.stopLoadingMore()
        }
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
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_ExhibitCell.getMyTableCell(tableV: tableView, indexP: indexPath)
        if dataArr.count > 0 {
            let listModel = dataArr[indexPath.row]
            cell?.model = listModel
            if selectRow == indexPath.row {
                cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
                if player.state == .playing {
                    cell?.tipImgV.image = UIImage.init(named: "dl_icon_pause")
                }else {
                    cell?.tipImgV.image = UIImage.init(named: "dl_icon_paly")
                }
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow = indexPath.row
        let cell:HDLY_ExhibitCell? = self.tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as? HDLY_ExhibitCell

        let listModel = dataArr[indexPath.row]
        guard let video = listModel.audio else {
            return
        }
        if listModel.title == currentModel.title {
            cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
            if player.state == .playing {
                player.pause()
                cell?.tipImgV.image = UIImage.init(named: "dl_icon_paly")
            }else {
                player.play()
                cell?.tipImgV.image = UIImage.init(named: "dl_icon_pause")
            }
        } else {
            if video.isEmpty == false && video.contains(".mp3") {
                player.play(file: Music.init(name: "", url:URL.init(string: video)!))
                player.url = video
                currentModel = listModel
                cell?.tipImgV.image = UIImage.init(named: "dl_icon_pause")
                cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
                isUpload = false
            }
        }
    }
    
}

//MARK: --- Player Control ---
extension HDLY_ExhibitListVC {
    
    func finishPlaying() {
        let cell0:HDLY_ExhibitCell? = self.tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as? HDLY_ExhibitCell
        cell0?.setSelected(false, animated: true)
        if selectRow + 1 < dataArr.count {
            selectRow = selectRow + 1
            let cell:HDLY_ExhibitCell? = self.tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as? HDLY_ExhibitCell
            let listModel = dataArr[selectRow]
            guard let video = listModel.audio else {
                return
            }
            if listModel.title == currentModel.title {
                cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
                if player.state == .playing {
                    player.pause()
                    cell?.tipImgV.image = UIImage.init(named: "dl_icon_paly")
                }else {
                    player.play()
                    cell?.tipImgV.image = UIImage.init(named: "dl_icon_pause")
                }
            } else {
                if video.isEmpty == false && video.contains(".mp3") {
                    player.play(file: Music.init(name: "", url:URL.init(string: video)!))
                    player.url = video
                    currentModel = listModel
                    cell?.tipImgV.image = UIImage.init(named: "dl_icon_pause")
                    cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
                    isUpload = false
                }
            }
        }
    }
    
    func playerTime(_ currentTime:String,_ totalTime:String,_ progress:Float) {
        
        let cell:HDLY_ExhibitCell? = self.tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as! HDLY_ExhibitCell?
        cell?.timeL.text = "\(currentTime)/\(totalTime)"
        
        if progress > 0.5 && isUpload == false {
            isUpload = true
            let token:String? = HDDeclare.shared.api_token
            if token != nil {
                uploadVM.uploadFootprintRequest(api_token: token!, exhibit_id: cell?.model?.exhibitID ?? 0, self)
                
            }
        }
        
    }
    
}



