//
//  HDZQ_OthersCenterVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/30.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_OthersCenterVC: HDItemBaseVC {
    public var toid = 0
    public var model = OtherDynamic()
    private var htmls =  [NSAttributedString]()
    @IBOutlet weak var tableView: UITableView!
    let tabHeader = HDZQ_PersonOthersHeaderView.createViewFromNib() as! HDZQ_PersonOthersHeaderView
    
    var feedbackChooseTip: HDLY_FeedbackChoose_View?
    var showFeedbackChooseTip = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDynamicData(toid: toid)
        self.title = "个人中心"
        
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 34))
        publishBtn.setImage(UIImage.init(named: "xz_icon_more_black_default"), for: .normal)
        publishBtn.addTarget(self, action: #selector(showErrorView), for: .touchUpInside)
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        tabHeader.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 190)
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 190))
        v.addSubview(tabHeader)
        tableView.tableHeaderView = v
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        closeFeedbackChooseTip()
    }
    
    func refreshUI() {
        tabHeader.avatar.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        tabHeader.nickNameL.text = model.nickname
        tabHeader.desLabel.text = model.profile
        tabHeader.followNumberL.text = "\(model.focus_num)"
        tabHeader.collectNumberL.text = "\(model.favorite_num)"
        if model.sex == 0 {
            tabHeader.genderImg.image = nil
        }else if model.sex == 1 {
            tabHeader.genderImg.image = UIImage.init(named: "icon_men")
        } else {
            tabHeader.genderImg.image = UIImage.init(named: "icon_women")
        }
        if model.is_focus == 1 {
            tabHeader.followBtn.setTitle("已关注", for: .normal)
        } else {
            tabHeader.followBtn.setTitle("+关注", for: .normal)
        }
        
        tabHeader.followBtn.addTouchUpInSideBtnAction { (btn) in
            self.followAction(id: self.model.toid!, cate_id: "3", api_token: HDDeclare.shared.api_token ?? "")
        }
        
        if model.is_vip == 1 {
            tabHeader.vipImg.isHidden = false
        } else {
            tabHeader.vipImg.isHidden = true
        }
        tableView.reloadData()
        
    }
    
    func followAction(id:String,cate_id:String,api_token:String) {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .doFocusRequest(id: id, cate_id: cate_id, api_token: api_token), showHud: false, loadingVC: self, success: { (result) in
            
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            if let is_focus:Int = (dic!["data"] as! Dictionary)["is_focus"] {
                if is_focus == 1 {
                    self.tabHeader.followBtn.setTitle("已关注", for: .normal)
                }else {
                    self.tabHeader.followBtn.setTitle("+关注", for: .normal)
                }
                self.model.is_focus = is_focus
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    func requestDynamicData(toid:Int) {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getOtherDynamicIndex(api_token: HDDeclare.shared.api_token ?? "", toid: toid), success: { (result) in
            let jsonDecoder = JSONDecoder()
            do {
                let model:OtherDynamicData = try jsonDecoder.decode(OtherDynamicData.self, from: result)
                self.model = model.data ?? OtherDynamic()
                for i in 0..<self.model.dynamic_list.count {
                    let m = self.model.dynamic_list[i]
                    var attrStr: NSAttributedString? = nil
                    if let anEncoding = m.comment!.data(using: .unicode) {
                        attrStr = try? NSAttributedString(data: anEncoding, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                        self.htmls.append(attrStr!)
                    }
                }
                self.refreshUI()
            } catch let error {
                LOG("解析错误：\(error)")
            }
        }) { (error, msg) in
            
        }
    }
    
    @objc func showErrorView() {
        tapErrorBtnAction()
    }
}

extension HDZQ_OthersCenterVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.dynamic_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dynamic = self.model.dynamic_list[indexPath.row]
        let cell = HDLY_MyDynamicCell.getMyTableCell(tableV: tableView)
        cell?.avaImgV.kf.setImage(with: URL.init(string: dynamic.avatar!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        cell?.contentL.attributedText = self.htmls[indexPath.row]
        cell?.timeL.text = dynamic.created_at
        cell?.nameL.text = dynamic.nickname
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension HDZQ_OthersCenterVC {
    
    func tapErrorBtnAction() {
        if showFeedbackChooseTip == false {
            let  tipView = HDLY_FeedbackChoose_View.createViewFromNib()
            feedbackChooseTip = tipView as? HDLY_FeedbackChoose_View
            feedbackChooseTip?.frame = CGRect.init(x: ScreenWidth-20-120, y: 45, width: 120, height: 100)
            feedbackChooseTip?.tapBtn1.setTitle("反馈", for: .normal)
            feedbackChooseTip?.tapBtn2.setTitle("报错", for: .normal)
            self.navigationController?.view.addSubview(feedbackChooseTip!)
            showFeedbackChooseTip = true
            weak var weakS = self
            feedbackChooseTip?.tapBlock = { (index) in
                weakS?.feedbackChooseAction(index: index)
            }
        } else {
            closeFeedbackChooseTip()
        }
    }
    
    func closeFeedbackChooseTip() {
        feedbackChooseTip?.tapBlock = nil
        feedbackChooseTip?.removeFromSuperview()
        showFeedbackChooseTip = false
    }
    
    func feedbackChooseAction(index: Int) {
        if index == 1 {
            //反馈
            let vc = UIStoryboard(name: "RootE", bundle: nil).instantiateViewController(withIdentifier: "HDLY_Feedback_VC") as! HDLY_Feedback_VC
            vc.typeID = "0"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }else {
            if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                self.pushToLoginVC(vc: self)
                return
            }
            //报错
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ReportError_VC") as! HDLY_ReportError_VC
            
            vc.articleID = String(toid)
            vc.typeID = "8"
            self.navigationController?.pushViewController(vc, animated: true)
            closeFeedbackChooseTip()
        }
    }
    
}

