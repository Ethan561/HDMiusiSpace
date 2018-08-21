//
//  HDLY_CourseDes_VC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/14.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDLY_CourseDes_VC: HDItemBaseVC ,UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate {

    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var listenBgView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    var infoModel: CourseModel?
    var kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    
    lazy var controlView:ZFPlayerControlView = {
        let controlV = ZFPlayerControlView.init()
        controlV.fastViewAnimated = true
        return controlV
    }()
    
    lazy var player:ZFPlayerController =  {
        let playerC = ZFPlayerController.init(playerManager: ZFAVPlayerManager(), containerView: self.containerView)
        return playerC
    }()
    
    var webView = WKWebView()
    var webViewH:CGFloat = 0
    
    lazy var testWebV: WKWebView = {
        let webV = WKWebView.init(frame: CGRect.zero)
        webV.navigationDelegate = self
        return webV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBarHCons.constant = kStatusBarHeight+24
        self.hd_navigationBarHidden = true
        myTableView.separatorStyle = .none
        listenBgView.layer.cornerRadius = 25
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
        dataRequest()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.player.isViewControllerDisappear = false
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player.isViewControllerDisappear = true
        UIApplication.shared.statusBarStyle = .default

    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func playClick(_ sender: UIButton) {
        self.player.assetURL = NSURL.init(string: "http://192.168.10.158/__video/2_0001.mp4")! as URL
        self.controlView.showTitle("", coverURLString: kVideoCover, fullScreenMode: ZFFullScreenMode.landscape)
    }
    
    @IBAction func listenBtnAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "PushTo_HDLY_CourseList_VC_line", sender: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.back()
    }
    
    func dataRequest()  {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseInfo(api_token: TestToken, id: "1"), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseModel = try! jsonDecoder.decode(CourseModel.self, from: result)
            self.infoModel = model
            if self.infoModel != nil {
                self.kVideoCover = self.infoModel!.data.img
                self.getWebHeight()
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    func getWebHeight() {
        guard let url = self.infoModel?.data.url else {
            return
        }
        self.testWebV.load(URLRequest.init(url: URL.init(string: url)!))
        self.myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_CourseDes_VC {
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
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if index == 0 {
            return 182*ScreenWidth/375.0
        }else if index == 1 {
            return webViewH
        }else if index == 2 {
            return 200*ScreenWidth/375.0
        }else if index == 3 {
            return 280*ScreenWidth/375.0
        }else if index == 4 {
            return 145*ScreenWidth/375.0
        }else if index == 5 {
            return 220*ScreenWidth/375.0
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = infoModel?.data
        
        if index == 0 {
            let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
            cell?.titleL.text = model?.title
            cell?.nameL.text = model?.teacher
            cell?.desL.text = model?.tdes
            
            return cell!
        }
        else if index == 1 {
            let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
            self.webView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height:CGFloat(webViewH))
            cell?.addSubview(webView)
            guard let url = self.infoModel?.data.url else {
                return cell!
            }
            self.webView.load(URLRequest.init(url: URL.init(string: url)!))

            return cell!
        }
        else if index == 2 {
            let cell = HDLY_CourseTeacher_Cell.getMyTableCell(tableV: tableView)
            cell?.introduceL.text = model?.tcontent
            cell?.nameL.text = model?.teacher
            cell?.desL.text = model?.tdes
            
            return cell!
        }else if index == 3 {
            let cell = HDLY_CourseComment_Cell.getMyTableCell(tableV: tableView)

            return cell!
        }else if index == 4 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
            cell?.contentL.text = model?.buynotice
            return cell!
        }else if index == 5 {
            let cell = HDLY_CourseRecmd_Cell.getMyTableCell(tableV: tableView)
            cell?.listArray = model?.recommend
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: ---- WKNavigationDelegate ----

extension HDLY_CourseDes_VC {
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("_____完成加载_____")
        //禁止长按手势操作
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        //js方法获取高度
        webView.evaluateJavaScript("Math.max(document.body.scrollHeight, document.body.offsetHeight, document.documentElement.clientHeight, document.documentElement.scrollHeight, document.documentElement.offsetHeight)") { (result, error) in
            let height = result
            self.webViewH = CGFloat(height as! Float)
        }
    }
    //加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("_____加载失败_____")
        
    }
    
    
    
}


extension HDLY_CourseDes_VC {
    
    
    @objc func moreBtnAction(_ sender: UIButton) {

        
    }
    
    
}

