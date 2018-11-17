//
//  HDSSL_dMuseumDetailVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/13.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dMuseumDetailVC: HDItemBaseVC ,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate {
    
    @IBOutlet weak var bannerBg: UIView!
    
    @IBOutlet weak var statusBarHCons: NSLayoutConstraint!
    @IBOutlet weak var myTableView: UITableView!

    

    var courseId:String?
    var focusBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    var infoModel: CourseModel?
    var isMp3Course = false
    
    var kVideoCover = "https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"
    
    lazy var controlView:ZFPlayerControlView = {
        let controlV = ZFPlayerControlView.init()
        controlV.fastViewAnimated = true
        return controlV
    }()
    
    let audioPlayer = HDLY_AudioPlayer.shared

    
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    var webViewH:CGFloat = 0
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        
        self.courseId = "28"
        dataRequest()
        
    }
    
    @IBAction func action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_tapTopButton(_ sender: UIButton) {
        print(sender.tag)
    }
    
}


extension HDSSL_dMuseumDetailVC {
    
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseInfo(api_token: token, id: idnum), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseModel = try! jsonDecoder.decode(CourseModel.self, from: result)
            self.infoModel = model

            if self.infoModel != nil {
//                self.kVideoCover = self.infoModel!.data.img
                self.getWebHeight()
//                if self.infoModel?.data.isFavorite == 1 {
//                    self.likeBtn.setImage(UIImage.init(named: "Star_red"), for: UIControlState.normal)
//                }else {
//                    self.likeBtn.setImage(UIImage.init(named: "Star_white"), for: UIControlState.normal)
//                }
            }
            
        }) { (errorCode, msg) in
//            self.myTableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
//            self.myTableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    func getWebHeight() {
        guard let url = self.infoModel?.data.url else {
            return
        }
        self.testWebV.delegate = self
        self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }
    
    
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0.01
            }
            if count > 0 {
                return 120
            }
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return nil
            }
            if count > 0 {
                let header = HDLY_CourseComment_Header.createViewFromNib() as! HDLY_CourseComment_Header
//                header.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: UIControlEvents.touchUpInside)
                return header
            }
        }
        return nil
    }
    //footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0.01
            }
            if count > 0 {
                return 60
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return nil
            }
            if count > 0 {
                return HDLY_CourseComment_Footer.createViewFromNib() as! HDLY_CourseComment_Footer
            }
        }
        return nil
    }
    
    //row
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        if section == 1 {
            guard let count = infoModel?.data.recommendsMessage?.count else {
                return 0
            }
            return count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        if indexPath.section == 0 {
            if index == 0 {
                return 182*ScreenWidth/375.0
            }else if index == 1 {
                return webViewH
            }else if index == 2 {
                if infoModel?.data.teacherContent != nil {
                    let textH = infoModel?.data.teacherContent.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
                    return textH! + 145 + 10
                }
                return 140
            }
        }
        else if indexPath.section == 1 {
            guard let recommendsMessage = infoModel?.data.recommendsMessage else {
                return 0.01
            }
            let  model  = recommendsMessage[index]
            if model.content != nil {
                let textH = model.content!.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-125)
                return textH + 50
            }
            return 0.01
        }
        else if indexPath.section == 2 {
            guard let buynotice = infoModel?.data.buynotice else {
                return 80
            }
            let textH = buynotice.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-40)
            return textH + 80 + 15
        }
        else if indexPath.section == 3 {
            return 220*ScreenWidth/375.0
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let model = infoModel?.data
        
        if indexPath.section == 0 {
            if index == 0 {
                let cell = HDLY_CourseTitle_Cell.getMyTableCell(tableV: tableView)
                if model?.timg != nil {
                    cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.timg)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell?.titleL.text = model?.title
                cell?.nameL.text = model?.teacherName
                cell?.desL.text = model?.teacherTitle
//                cell?.focusBtn.addTarget(self, action: #selector(focusBtnAction), for: UIControlEvents.touchUpInside)
                focusBtn = cell?.focusBtn
                if model?.isFocus == 1 {
                    focusBtn.setTitle("已关注", for: .normal)
                }else {
                    focusBtn.setTitle("+关注", for: .normal)
                }
                
                return cell!
            }
            else if index == 1 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = self.infoModel?.data.url else {
                    return cell!
                }
                cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                return cell!
            }
            else if index == 2 {
                let cell = HDLY_CourseTeacher_Cell.getMyTableCell(tableV: tableView)
                if model?.timg != nil {
                    cell?.avatarImgV.kf.setImage(with: URL.init(string: (model?.timg)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell?.nameL.text = model?.teacherName
                cell?.desL.text = model?.teacherTitle
                cell?.introduceL.text = model?.teacherContent
                return cell!
            }
        }
        else if indexPath.section == 1 {
            let cell = HDLY_CourseComment_Cell.getMyTableCell(tableV: tableView)
            guard let recommendsMessage = infoModel?.data.recommendsMessage else {
                return cell!
            }
            let  model  = recommendsMessage[index]
            cell?.contentL.text = model.content
            cell?.nameL.text = model.nickname
            if model.avatar != nil {
                cell?.avaImgV.kf.setImage(with: URL.init(string:(model.avatar)!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            return cell!
        }
        else if indexPath.section == 2 {
            let cell = HDLY_BuyNote_Cell.getMyTableCell(tableV: tableView)
            cell?.contentL.text = model?.buynotice
            
            return cell!
        }
        else if indexPath.section == 3 {
            let cell = HDLY_CourseRecmd_Cell.getMyTableCell(tableV: tableView)
            cell?.listArray = model?.recommendsList
            return cell!
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HDSSL_dMuseumDetailVC {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView == self.testWebV) {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("\(webViewH)")
        }
        self.myTableView.reloadData()
    }
    
}


extension HDSSL_dMuseumDetailVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
        vc.courseId = self.courseId
        vc.showLeaveMsg = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func focusBtnAction()  {
        if let idnum = infoModel?.data.teacherID.string {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            doFocusRequest(api_token: HDDeclare.shared.api_token!, id: idnum, cate_id: "2")
        }
    }
    
    //关注
    func doFocusRequest(api_token: String, id: String, cate_id: String)  {
        
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 1 {
                    self.infoModel!.data.isFocus = 1
                    self.focusBtn.setTitle("已关注", for: .normal)
                }else {
                    self.infoModel!.data.isFocus  = 0
                    self.focusBtn.setTitle("+关注", for: .normal)
                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
}




