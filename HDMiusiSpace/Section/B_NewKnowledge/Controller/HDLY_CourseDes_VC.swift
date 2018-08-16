//
//  HDLY_CourseDes_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/14.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

let kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"

class HDLY_CourseDes_VC: HDItemBaseVC ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    
    lazy var controlView:ZFPlayerControlView = {
        let controlV = ZFPlayerControlView.init()
        controlV.fastViewAnimated = true
        return controlV
    }()
    
    lazy var player:ZFPlayerController =  {
        let playerC = ZFPlayerController.init(playerManager: ZFAVPlayerManager(), containerView: self.containerView)
        return playerC
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarHCons.constant = kStatusBarHeight+24
        self.hd_navigationBarHidden = true
        
        //
        self.player.controlView = self.controlView
        // 设置退到后台继续播放
        self.player.pauseWhenAppResignActive = false
        
        weak var _self = self
        self.player.orientationWillChange = { (player,isFullScreen) -> (Void) in
            _self?.setNeedsStatusBarAppearanceUpdate()
        }
        
        // 播放完自动播放下一个
        self.player.playerDidToEnd = { (asset) -> () in
            
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player.isViewControllerDisappear = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.isViewControllerDisappear = true

    }
    
    
    @IBAction func playClick(_ sender: UIButton) {
        self.player.assetURL = NSURL.init(string: "http://192.168.10.158/__video/2_0001.mp4")! as URL
        self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
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


extension HDLY_CourseDes_VC{
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


