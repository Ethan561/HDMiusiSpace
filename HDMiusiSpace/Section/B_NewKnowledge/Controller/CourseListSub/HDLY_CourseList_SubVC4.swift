//
//  HDLY_CourseList_SubVC4.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_SubVC4: HDItemBaseVC,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    var infoModel: CourseMessageList?
    var courseId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        bgView.layer.cornerRadius = 19
        bottomView.configShadow(cornerRadius: 0, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.init(width: 0, height: -5))
        let empV = EmptyConfigView.NoDataEmptyView()
        self.tableView.ly_emptyView = empV

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
        tableView.ly_startLoading()
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseMessageList(skip: "0", take: "100", api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in

            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")

            let jsonDecoder = JSONDecoder()
            do {
                let model:CourseMessageList = try jsonDecoder.decode(CourseMessageList.self, from: result)
                self.infoModel = model
                self.tableView.reloadData()
                self.tableView.ly_endLoading()
            }
            catch let error {
                LOG("\(error)")
                self.tableView.ly_endLoading()
            }
            
        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    @IBAction func leaveMsgBtnAction(_ sender: Any) {
        let vc:HDLY_LeaveMsg_VC = HDLY_LeaveMsg_VC.init()
        vc.courseId = self.courseId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension HDLY_CourseList_SubVC4 {
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
        if infoModel?.data != nil {
            return infoModel!.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if infoModel?.data != nil {
            guard let commentModel:CourseMessageModel = self.infoModel?.data[indexPath.row] else {
                return  0.01
            }
            if let text = commentModel.content {
                let textH = text.getContentHeight(font: UIFont.systemFont(ofSize: 14), width: ScreenWidth-85)
                return textH + 90
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = HDLY_LeaveMsg_Cell.getMyTableCell(tableV: tableView)
        if self.infoModel?.data != nil {
            guard let commentModel:CourseMessageModel = self.infoModel?.data[index] else {
                return  cell!
            }
            if commentModel.avatar != nil {
                cell?.avatarBtn.kf.setImage(with: URL.init(string: commentModel.avatar!), for: .normal, placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell?.avatarBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    self?.pushToOthersPersonalCenterVC(commentModel.uid.int)
                }
            })
            
            cell?.contentL.text = commentModel.content
            cell?.timeL.text = commentModel.time
            cell?.likeBtn.setTitle(commentModel.likeNum.string, for: UIControlState.normal)
            if commentModel.isLike == 0 {
                cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
            }else {
                cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
            }
            cell?.likeBtn.addTouchUpInSideBtnAction({ [weak self] (btn) in
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self?.pushToLoginVC(vc: self!)
                } else {
                    CoursePublicViewModel.doLikeRequest(id: commentModel.messageID.string, cate_id: "7", vc: self!, success: { (result) in
                        if self?.infoModel!.data[index].isLike == 0 {
                            self?.infoModel!.data[index].isLike = 1
                            self?.infoModel!.data[index].likeNum.int = (self?.infoModel!.data[index].likeNum.int)! + 1
                            cell?.likeBtn.setImage(UIImage.init(named: "点赞"), for: UIControlState.normal)
                            cell?.likeBtn.setTitle(self?.infoModel!.data[index].likeNum.string, for: .normal)
                        }else {
                            self?.infoModel!.data[index].isLike = 0
                            self?.infoModel!.data[index].likeNum.int = (self?.infoModel!.data[index].likeNum.int)! - 1
                            cell?.likeBtn.setImage(UIImage.init(named: "点赞1"), for: UIControlState.normal)
                            cell?.likeBtn.setTitle(self?.infoModel!.data[index].likeNum.string, for: .normal)
                        }
                    }, failure: { (error, msg) in })
                }
            })
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


