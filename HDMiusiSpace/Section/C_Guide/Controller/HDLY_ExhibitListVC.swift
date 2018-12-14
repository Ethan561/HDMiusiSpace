//
//  HDLY_ExhibitListVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ExhibitListVC: HDItemBaseVC, HDLY_AudioPlayer_Delegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var navbarCons: NSLayoutConstraint!
    @IBOutlet weak var topImgV: UIImageView!
    
    let player = HDLY_AudioPlayer.shared
    var infoModel: HDLY_ExhibitList?
    var exhibition_id = 0
    private var currentModel = HDLY_ExhibitListM()
    var selectRow = -1
    //
    var isUpload = false
    let uploadVM = HDLY_RootCVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        navbarCons.constant = CGFloat(kTopHeight)
        dataRequest()
        player.delegate = self

    }
    
    func dataRequest()  {
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .guideExhibitList(exhibition_id: exhibition_id, skip: 0, take: 20, api_token: token), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            do {
                let model:HDLY_ExhibitList = try jsonDecoder.decode(HDLY_ExhibitList.self, from: result)
                self.infoModel = model
                self.tableView.reloadData()
                self.topImgV.kf.setImage(with: URL.init(string: model.data.img), placeholder: UIImage.grayImage(sourceImageV: self.topImgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            catch let error {
                LOG("\(error)")
            }
            
            
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
        return infoModel?.data.exhibitList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_ExhibitCell.getMyTableCell(tableV: tableView, indexP: indexPath)
        if infoModel?.data.exhibitList != nil {
            let listModel = infoModel!.data.exhibitList[indexPath.row]
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

        let listModel = infoModel!.data.exhibitList[indexPath.row]
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
        let cell:HDLY_ExhibitCell? = self.tableView.cellForRow(at: IndexPath.init(row: selectRow, section: 0)) as? HDLY_ExhibitCell
        cell?.setSelected(false, animated: true)

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



