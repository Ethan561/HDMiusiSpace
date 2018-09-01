//
//  HDLY_CourseList_SubVC3.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_SubVC3: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var leaveMsgView: UIView!
    @IBOutlet weak var leaveMsgBgV: UIView!
    
    let audioPlayer = HDLY_AudioPlayer.shared

    var infoModel: CourseQuestion?
    var courseId: String?
    
    var playingIndex: String?
    
    //
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    var webViewH:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyBtn.layer.cornerRadius = 27
        buyBtn.isHidden = true
        leaveMsgBgV.layer.cornerRadius = 19
        //
        bottomHCons.constant = 56
        bottomView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        audioPlayer.showFloatingBtn = false

        dataRequest()
//        audioPlayer.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer.stop()
    }

    @IBAction func buyBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func questionBtnAction(_ sender: UIButton) {
        let vc:HDLY_LeaveQuestion_VC = HDLY_LeaveQuestion_VC.init()
        vc.courseId = self.courseId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func dataRequest()  {
        guard let idnum = self.courseId else {
            return
        }
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseQuestionList(skip: "0", take: "100", api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseQuestion = try! jsonDecoder.decode(CourseQuestion.self, from: result)
            self.infoModel = model
            self.getWebHeight()
            self.tableView.reloadData()
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HDLY_CourseList_SubVC3 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if infoModel?.data.list != nil {
            return infoModel!.data.list.count+1
        }
        return 1
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            let titleH = secModel.title.getContentHeight(font: UIFont.init(name: "PingFangSC-Medium", size: 14)!, width: ScreenWidth-80)
            let contentH = secModel.content.getContentHeight(font: UIFont.init(name: "PingFangSC-Regular", size: 14)!, width: ScreenWidth-80)
            return titleH+contentH+108
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return HDLY_QuestionTip_Header.createViewFromNib() as! HDLY_QuestionTip_Header
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            let header = HDLY_QuestionContent_Header.createViewFromNib() as!  HDLY_QuestionContent_Header
            header.questionL.text = secModel.title
            header.contentL.text = secModel.content
            header.timeL.text = secModel.createdAt
            header.likeBtn.setTitle(secModel.likes!.string, for: UIControlState.normal)
            header.nameL.text = secModel.nickname
            if secModel.avatar.isEmpty == false {
                header.avaImgV.kf.setImage(with: URL.init(string: secModel.avatar), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            if secModel.isLike?.int == 0 {
                header.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
            }else {
                header.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
            }
            return header
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
        if section == 0 {
            return 2
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            if secModel.returnInfo.count > 0 {
                return secModel.returnInfo.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row

        if section == 0 {
            if row == 0 {
                return webViewH
            }else {
                return 42
            }
        }
        if infoModel?.data.list != nil && section > 0{
            let secModel = infoModel!.data.list[section-1]
            if secModel.returnInfo.count > 0 {
                let returnInfo = secModel.returnInfo[row]
                if returnInfo.type == 1 {//1文字2语音
                    let contentH = secModel.content.getContentHeight(font: UIFont.init(name: "PingFangSC-Regular", size: 14)!, width: ScreenWidth-147)
                    return contentH + 108
                }else {
                    return  145
                }
            }
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 0 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = self.infoModel?.data.url else {
                    return cell!
                }
                cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                
                return cell!
            }else if row == 1 {
                let cell = HDLY_QuestionNumTitle_Cell.getMyTableCell(tableV: tableView)
                cell?.noticeL.isHidden = true
                cell?.noticeImgV.isHidden = true
                
                if infoModel?.data != nil {
                    cell?.countL.text = "讲师共回答了\(infoModel!.data.answerNum)个问题"
                }
                
                return cell!
            }
        }else {
            
            if infoModel?.data.list != nil && section > 0{
                let secModel = infoModel!.data.list[section-1]
                if secModel.returnInfo.count > 0 {
                    let returnInfo:QuestionReturnInfo = secModel.returnInfo[row]
                    if returnInfo.type == 1 {//1文字2语音
                        let cell = HDLY_AnswerText_Cell.getMyTableCell(tableV: tableView)
                        if returnInfo.teacherImg.isEmpty == false {
                            cell?.avaImgV.kf.setImage(with: URL.init(string: returnInfo.teacherImg), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                            cell?.nameL.text = returnInfo.teacherName
                            cell?.contentL.text = returnInfo.content
                            cell?.timeL.text = returnInfo.createdAt
                        }
                        return cell!
                    }else {
                        let cell = HDLY_AnswerAudio_Cell.getMyTableCell(tableV: tableView)
                        cell?.avaImgV.kf.setImage(with: URL.init(string: returnInfo.teacherImg), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                        cell?.nameL.text = returnInfo.teacherName
                        cell?.timeL.text = returnInfo.createdAt
                        cell?.audioTimeL.text = returnInfo.timeLong
                        cell?.delegate = self
                        cell?.model = returnInfo
                        let currentIndex = "\(section)\(row)"
                        if playingIndex != nil {
                            if playingIndex! == currentIndex  {
                                cell?.startAnimating()
                            }else {
                                cell?.stopAnimating()
                            }
                        }
                        return cell!
                    }
                }
            }
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension HDLY_CourseList_SubVC3: UIWebViewDelegate ,AnswerAudioDelegate {
    
    func voiceBubbleStratOrStop(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo) {
        if model.video.isEmpty == true || model.video.contains(".mp3") == false {
            return
        }
        if playingIndex != nil {
            let indexPath: IndexPath = self.tableView.indexPath(for: cell)!
            let currentIndex = "\(indexPath.section)\(indexPath.row)"
            
            if playingIndex! == currentIndex  {
                
                if audioPlayer.state == .playing {
                    self.pause(cell, model)
                } else {
                    if audioPlayer.state == .paused {
                        audioPlayer.play()
                        cell.startAnimating()

                    }else {
                        play(cell, model)
                    }
                }
            }else {
                play(cell, model)
            }
            
        }else { //直接播放
            play(cell, model)
        }
    }
    
    func play(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo) {
        let indexPath: IndexPath = self.tableView.indexPath(for: cell)!
        let indexStr = "\(indexPath.section)\(indexPath.row)"
        self.playingIndex = indexStr
        
        cell.startAnimating()
        audioPlayer.play(file: Music.init(name: "", url: URL.init(string: model.video)!))
        HDFloatingButtonManager.manager.floatingBtnView.closeAction()

    }
    
    func pause(_ cell: HDLY_AnswerAudio_Cell, _ model: QuestionReturnInfo) {
        audioPlayer.pause()
        cell.stopAnimating()
    }
    
    //
    func getWebHeight() {
        guard let url = self.infoModel?.data.url else {
            return
        }
        self.testWebV.delegate = self
        self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView == self.testWebV) {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("\(webViewH)")
        }
        self.tableView.reloadData()
    }
    
    
    //
}

