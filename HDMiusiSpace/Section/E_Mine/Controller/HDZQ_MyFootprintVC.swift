//
//  HDZQ_MyFootprintVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyFootprintVC: HDItemBaseVC {
    private var tipView = HDLY_ShareView()
    private var dayList = [FootprintModel]()
    private var lastIndex : IndexPath?
    private var lastRow : Int?
    private var currentIndex : String?
    private var shareModel :FPContent?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "导览足迹"
        requestFootPrintData()
    }
    
    deinit {
         let player = HDLY_AudioPlayer.shared
        player.stop()
    }
    
}

extension HDZQ_MyFootprintVC {
    func requestFootPrintData() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyFootPrint(api_token: HDDeclare.shared.api_token ?? "", skip: 0, take: 10), success: { (result) in
            let jsonDecoder = JSONDecoder()
            guard let model:FootprintData = try? jsonDecoder.decode(FootprintData.self, from: result) else { return }
            self.dayList = model.data
            self.tableView.reloadData()
        }) { (error, msg) in
            
        }
    }
}

extension HDZQ_MyFootprintVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayList[section].list_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.dayList[indexPath.section].list_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_FoorprintCell") as? HDZQ_FoorprintCell
        cell?.exhibitionLabel.text = model.museum_title
        cell?.exhibitionTitleLabel.text = model.exhibition_title
        cell?.setupExhibitView(model:model)
        cell?.setupCellViews(model: model)
        cell?.index = indexPath
        cell?.currentIndex = self.currentIndex
        cell?.delegate = self
        cell?.shareBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
            self?.tipView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
            self?.tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            self?.tipView.delegate = self
            if kWindow != nil {
                kWindow!.addSubview((self?.tipView)!)
            }
            self?.shareModel = model
        })
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = dayList[section]
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? HDZQ_FPSectionHeaderView
        if header == nil {
            header = HDZQ_FPSectionHeaderView.init(reuseIdentifier: "sectionHeader")
        }
        header!.setDateData(date:date.look_date!)
        if section == 0 {
            header?.topLineView.isHidden = true
        } else {
            header?.topLineView.isHidden = false
        }
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.dayList[indexPath.section].list_data[indexPath.row]
        if model.class_list.count > 0 {
            return CGFloat(90 + 55 * model.exhibit_list.count + 45 + 150 + 20)
        } else {
            return CGFloat(90 + 55 * model.exhibit_list.count + 20)
        }
    }
}

extension HDZQ_MyFootprintVC: UMShareDelegate {
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard self.shareModel != nil else { return }
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = shareModel?.exhibition_share_html
        let shareObject = UMShareWebpageObject.shareObject(withTitle: shareModel?.exhibition_title, descr: shareModel?.museum_title, thumImage: nil)
        shareObject?.webpageUrl = thumbURL
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { data, error in
            if error != nil {
                //UMSocialLog(error)
                LOG(error)
            } else {
                if (data is UMSocialShareResponse) {
                    var resp = data as? UMSocialShareResponse
                    //分享结果消息
                    LOG(resp?.message)
                    self.tipView.removeFromSuperview()
                    //第三方原始返回的数据
                    print(resp?.originalResponse)
                } else {
                    LOG(data)
                }
            }
        }
    }
}

//MARK:使seactionheader跟随tableview一起滑动
extension HDZQ_MyFootprintVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 45 //这里是我的headerView和footerView的高度
        if tableView.contentOffset.y <= sectionHeaderHeight && tableView.contentOffset.y >= 0 {
            tableView.contentInset = UIEdgeInsetsMake(-tableView.contentOffset.y, 0, 0, 0)
        } else if tableView.contentOffset.y >= sectionHeaderHeight {
            tableView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0)
        }
    }
}

extension HDZQ_MyFootprintVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension HDZQ_MyFootprintVC : HDZQ_FPExhibitPlayActionDelegate {
    func exhibitPlayAction(index: IndexPath,row:Int,idxStrig:String,url:String) {
        let indexPath = IndexPath.init(row: index.row, section: index.section)
        let cell =  tableView.cellForRow(at: indexPath) as? HDZQ_FoorprintCell
        cell?.currentIndex = idxStrig
        // 更新当前点击的cell
        let indexPath1 = IndexPath.init(row: row, section: 0)
        cell?.exhibitContentView.reloadRows(at: [indexPath1], with: .none)
        
        //更新当前cell里面上一个播放的btn
        if lastRow != nil && lastRow != row && lastIndex == index {
            let indexPath2 = IndexPath.init(row: lastRow!, section: 0)
            cell?.exhibitContentView.reloadRows(at: [indexPath2], with: .none)
        }
        
        // 更新其他cell里面上一个播放的btn
        if lastIndex != nil && lastIndex != index && idxStrig != "" {
            let cell1 =  tableView.cellForRow(at: lastIndex!) as? HDZQ_FoorprintCell
            cell1?.currentIndex = ""
            cell1?.exhibitContentView.reloadData()
        }
        self.lastRow = row
        self.lastIndex = index
        self.currentIndex = idxStrig
        
         let player = HDLY_AudioPlayer.shared
        if idxStrig != "" {
            let URLS = URL.init(string: url)
            player.delegate = self
            if player.fileno == url {
                player.play()
            } else {
               player.play(file: Music.init(name: "", url: URLS!))
               player.fileno =  url
            }
        } else {
            player.pause()
        }
        
    }
}

extension HDZQ_MyFootprintVC : HDLY_AudioPlayer_Delegate {
    func finishPlaying() {
        
        let cell1 = tableView.cellForRow(at: lastIndex!) as? HDZQ_FoorprintCell
        cell1?.currentIndex = ""
        let indexPath1 = IndexPath.init(row: self.lastRow!, section: 0)
        cell1?.exhibitContentView.reloadRows(at: [indexPath1], with: .none)
//        self.currentIndex = nil
//        self.lastRow = nil
//        self.lastIndex = nil
        
    }
    func playerTime(_ currentTime: String, _ totalTime: String, _ progress: Float) {
        print(progress)
    }
}



