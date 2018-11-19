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
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    
    var webViewH: CGFloat = 0
    var museumId: Int = 0
    var infoModel: ExhibitionMuseumData?
    let audioPlayer = HDLY_AudioPlayer.shared
    
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
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
        var token:String = ""
        if HDDeclare.shared.loginStatus == .kLogin_Status_Login {
            token = HDDeclare.shared.api_token!
        }
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .exhibitionMuseumInfo(museum_id: museumId, api_token: token), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:HDLY_ExhibitionMuseumModel = try! jsonDecoder.decode(HDLY_ExhibitionMuseumModel.self, from: result)
            
            self.infoModel = model.data
            if self.infoModel != nil {
//              self.kVideoCover = self.infoModel!.data.img
                self.getWebHeight()
                self.topImgView.kf.setImage(with: URL.init(string: self.infoModel!.img!), placeholder: UIImage.init(named: ""))
                self.myTableView.reloadData()
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
        guard let url = self.infoModel?.museumHTML else {
            return
        }
        self.testWebV.delegate = self
        self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: url)!))
    }
    
    
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.infoModel?.dataList != nil {
            return self.infoModel!.dataList!.count + 2
        }
        return 2
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return 45
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let header = HDLY_dMuseumHeader.createViewFromNib() as! HDLY_dMuseumHeader
            header.backgroundColor = UIColor.white
            header.moreBtn.tag = 100 + section
            header.moreBtn.addTarget(self, action: #selector(moreBtnAction(_:)), for: UIControlEvents.touchUpInside)
            if section == 1 {
                header.titleL.text = "平面展示图"
                header.moreBtn.isHidden = true
                return header
            }
            if self.infoModel?.dataList != nil {
                let model = self.infoModel!.dataList![section-2]
                if model.type == 1 {
                    header.titleL.text = model.exhibition?.categoryTitle
                }
                else if model.type == 2 {
                    header.titleL.text = model.raiders?.categoryTitle
                }else if model.type == 3 {
              
                }else if model.type == 4 {
                    header.titleL.text = model.featured?.categoryTitle
                }else if model.type == 5 {
                    header.titleL.text = model.listen?.categoryTitle
                }
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
            return 6
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        
        if indexPath.section == 0 {
            if index == 0 {
                return 70
            }else if index == 1 {
                return 85
            }else if index == 2 || index == 3 {
                return 40
            }else if index == 4 {
                return 88
            }else if index == 5 {
                return webViewH
            }
        }
        else if indexPath.section == 1 {
            return 400
        }
        else {
            
            let model = self.infoModel!.dataList![indexPath.section - 2]
            if model.type == 1 {//同馆展览
                return 300
            }
            else if model.type == 2 {//展览攻略
                return 330
            }else if model.type == 3 {//相关活动
                return 375
            }else if model.type == 4 {//精选推荐
                return 160*ScreenWidth/375.0
            }else if model.type == 5 {//免费听
                return 160*ScreenWidth/375.0
            }
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = HDLY_MuseumInfoTitleCell.getMyTableCell(tableV: tableView) as HDLY_MuseumInfoTitleCell
            cell.titleL.text = self.infoModel?.title
                return cell
            }
            else if indexPath.row == 1 {
                let cell = HDSSL_Sec0_Cell1.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell1
                cell.cell_timeL.text = self.infoModel?.time
                return cell
            }
            else if indexPath.row == 4 { //标签视图
                let cell = HDLY_MuseumTagsCell.getMyTableCell(tableV: tableView)
                cell?.imgArr = self.infoModel?.iconList
                return cell!
            }
            else if indexPath.row == 5 {
                let cell = HDLY_CourseWeb_Cell.getMyTableCell(tableV: tableView)
                guard let url = self.infoModel?.museumHTML else {
                    return cell!
                }
                cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
                return cell!
            }
            else  {
                let cell = HDSSL_Sec0_cellNormal.getMyTableCell(tableV: tableView) as HDSSL_Sec0_cellNormal
                var name: String?
                var title: String?
                
                if indexPath.row == 2 {
                    name = "费用："
                    title = self.infoModel?.price
                }else if indexPath.row == 3 {
                    name = "地址："
                    title = self.infoModel?.address
                }
                cell.cell_nameL.text = name
                cell.cell_titleL.text = title
                return cell
            }
        }
        else if indexPath.section == 1 {
            let cell = HDLY_MuseumInfoImgCell.getMyTableCell(tableV: tableView)
            if infoModel?.areaImg != nil {
                cell?.imgV.kf.setImage(with: URL.init(string:(infoModel!.areaImg!)), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
            }
            return cell!
        }
        else {
            if self.infoModel?.dataList != nil {
                let model = self.infoModel!.dataList![indexPath.section - 2]
                if model.type == 1 {//同馆展览
                    let cell:HDLY_MuseumInfoType1Cell = HDLY_MuseumInfoType1Cell.getMyTableCell(tableV: tableView)
                    if model.exhibition?.list != nil {
                        cell.listArray = model.exhibition!.list
                    }
                    return cell
                }
                else if model.type == 2 {//展览攻略
                    let cell = HDLY_MuseumInfoType2Cell.getMyTableCell(tableV: tableView)
                    cell?.model = model.raiders
                    return cell!
                }else if model.type == 3 {//相关活动
                    let cell = HDLY_MuseumInfoType3Cell.getMyTableCell(tableV: tableView)
                    
                    return cell!
                }else if model.type == 4 {//精选推荐
                    let cell: HDLY_MuseumInfoType4Cell  = HDLY_MuseumInfoType4Cell.getMyTableCell(tableV: tableView)
                    if model.featured?.list != nil {
                        cell.listArray = model.featured!.list
                    }
                    return cell
                }else if model.type == 5 {//免费听
                    let cell:HDLY_MuseumInfoType5Cell = HDLY_MuseumInfoType5Cell.getMyTableCell(tableV: tableView)
                    if model.listen?.list != nil {
                        cell.listArray = model.listen!.list
                    }
                    return cell
                }
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension HDSSL_dMuseumDetailVC {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (webView == self.testWebV) {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("webViewH: \(webViewH)")
        }
        self.myTableView.reloadData()
//        self.myTableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
    }
    
}


extension HDSSL_dMuseumDetailVC {
    
    @objc func moreBtnAction(_ sender: UIButton) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseList_VC") as! HDLY_CourseList_VC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
}




