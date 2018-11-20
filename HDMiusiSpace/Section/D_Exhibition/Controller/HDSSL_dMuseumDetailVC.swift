//
//  HDSSL_dMuseumDetailVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/13.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dMuseumDetailVC: HDItemBaseVC ,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate , HDLY_MuseumInfoType4Cell_Delegate, HDLY_AudioPlayer_Delegate , HDLY_MuseumInfoType5Cell_Delegate{
    
    @IBOutlet weak var bannerBg: UIView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var topImgView: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var errorBtn: UIButton!
    
    var webViewH: CGFloat = 0
    var areaWebViewH: CGFloat = 0
    var museumId: Int = 0
    var infoModel: ExhibitionMuseumData?
    let player = HDLY_AudioPlayer.shared
    
    var playItem:HDLY_FreeListenItem?
    var playModel:DMuseumListenList?
    
    lazy var testWebV: UIWebView = {
        let webV = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
        webV.isOpaque = false
        return webV
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hd_navigationBarHidden = true
        myTableView.separatorStyle = .none
        dataRequest()
//        player.delegate = self

    }
    
    @IBAction func action_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_tapTopButton(_ sender: UIButton) {
        print(sender.tag)
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        if parent == nil {
            player.stop()
        }
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
        if self.infoModel?.areaHTML != nil {
            self.testWebV.loadRequest(URLRequest.init(url: URL.init(string: self.infoModel!.areaHTML!)!))
        }
        
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
    
//    UIView *view = [[UIView alloc] initWithFrame:[head frame]];
//    head.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [view addSubview:head];
//    return view;
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 45))
            
            let header = HDLY_dMuseumHeader.createViewFromNib() as! HDLY_dMuseumHeader
            header.frame = headerView.bounds
            headerView.addSubview(header)
            
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
                if model.type == 1 {//同馆展览
                    header.titleL.text = model.exhibition?.categoryTitle
                }
                else if model.type == 2 {
                    header.titleL.text = model.raiders?.categoryTitle
                }else if model.type == 3 {//相关活动
                    header.titleL.text = "相关活动"
                    header.moreBtn.isHidden = true
                }else if model.type == 4 {
                    header.titleL.text = model.featured?.categoryTitle
                }else if model.type == 5 {
                    header.titleL.text = model.listen?.categoryTitle
                    header.moreBtn.setTitle("查看全部", for: .normal)
                }
            }
            return headerView
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
            return areaWebViewH
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
                return 200*ScreenWidth/375.0
            }else if model.type == 5 {//免费听
                return (ScreenWidth - 20 * 3)/2.0 + 30
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
            guard let url = self.infoModel?.areaHTML else {
                return cell!
            }
            cell?.webView.loadRequest(URLRequest.init(url: URL.init(string: url)!))
            return cell!
        }
        else {
            if self.infoModel?.dataList != nil {
                let model = self.infoModel!.dataList![indexPath.section - 2]
                if model.type == 1 {//同馆展览
                    let cell = HDSSL_sameMuseumCell.getMyTableCell(tableV: tableView)
                    cell?.listArray = model.exhibition?.list
                    cell?.BlockTapItemFunc(block: { (m) in
                        self.showExhibitionDetailVC(exhibitionID: m.exhibitionID)
                    })
                    return cell!
                    
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
                    cell.delegate = self
                    if model.featured?.list != nil {
                            cell.listArray = model.featured!.list
                    }
                    return cell
                }else if model.type == 5 {//免费听
                    let cell:HDLY_MuseumInfoType5Cell = HDLY_MuseumInfoType5Cell.getMyTableCell(tableV: tableView)
                    if model.listen?.list != nil {
                        cell.listArray = model.listen!.list
                    }
                    cell.delegate = self
                    cell.playModel = playModel
                    player.delegate = cell
                    
                    return cell
                }
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 1 {
            if self.infoModel?.dataList != nil {
                let model = self.infoModel!.dataList![indexPath.section - 2]
                if model.type == 2 {//展览攻略
                    if model.raiders?.strategyID != nil {
                        self.showRelatedStrategyVC(exhibitionID: model.raiders!.strategyID!)
                    }
                } else if model.type == 3 {//相关活动
                    
                }
            }
        }
    }
    
    //HDLY_MuseumInfoType4Cell_Delegate
    
    func didSelectItemAt(_ model:DMuseumFeaturedList, _ cell: HDLY_MuseumInfoType4Cell) {
        showRecomendDetailVC(classID: model.classID ?? 0)
    }
    
    //HDLY_MuseumInfoType5Cell_Delegate
    func didSelectItemAt(_ model:DMuseumListenList, _ cell: HDLY_FreeListenItem) {
        self.playItem = cell
        if model.title == playModel?.title {
            if player.state == .playing {
                player.pause()
                cell.playBtn.isSelected = false
                playModel?.isPlaying = false
            }else {
                player.play()
                cell.playBtn.isSelected = true
                playModel?.isPlaying = true

            }
        } else {
            guard let video = model.audio else {return}
            if video.isEmpty == false && video.contains(".mp3") {
                player.play(file: Music.init(name: "", url:URL.init(string: video)!))
                player.url = video
                self.playModel = model
                cell.playBtn.isSelected = true
                playModel?.isPlaying = true

            }
        }
//        self.myTableView.reloadData()
//        //刷新表格视图的分区的头视图
//        let sec = self.infoModel!.dataList!.count + 1
//        self.myTableView.reloadSections(IndexSet.init(integer: sec), with: .none)
        self.myTableView.reloadRows(at: [IndexPath.init(row: 0, section: self.infoModel!.dataList!.count + 1)], with: .none)
        
    }
    
}


extension HDSSL_dMuseumDetailVC {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.request?.url?.absoluteString == self.infoModel?.museumHTML {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.webViewH = CGFloat(webViewHStr.floatValue + 10)
            LOG("webViewH: \(webViewH)")
        }
        if webView.request?.url?.absoluteString == self.infoModel?.areaHTML {
            let  webViewHStr:NSString = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;")! as NSString
            self.areaWebViewH = CGFloat(webViewHStr.floatValue + 10)
            
        }
        self.myTableView.reloadData()
//        self.myTableView.reloadRows(at: [IndexPath.init(row: 5, section: 0)], with: .none)
    }
    
}


extension HDSSL_dMuseumDetailVC {
    //更多界面
    @objc func moreBtnAction(_ sender: UIButton) {
        let section = sender.tag - 100
        if section > 1 {
            if self.infoModel?.dataList != nil {
                let model = self.infoModel!.dataList![section-2]
                if model.type == 1 {//同馆展览
                    let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDLY_SameExhibitionListVC") as! HDLY_SameExhibitionListVC
                    vc.museumId = self.museumId
                    vc.titleName = "同馆展览-" + self.infoModel!.title!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if model.type == 2 {//参观攻略更多
                    let vc = UIStoryboard(name: "RootD", bundle: nil).instantiateViewController(withIdentifier: "HDLY_StrategyListVC") as! HDLY_StrategyListVC
                    vc.museumId = self.museumId
                    vc.titleName = "展览攻略"
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if model.type == 3 {//相关活动
  
                }else if model.type == 4 {//精选推荐
                    let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_RecmdMore_VC") as! HDLY_RecmdMore_VC
                    self.navigationController?.pushViewController(vc, animated: true)

                }else if model.type == 5 {//免费听
                    let vc = UIStoryboard(name: "RootC", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ExhibitionListVC") as! HDLY_ExhibitionListVC
                    vc.museum_id = self.museumId
                    vc.titleName = self.infoModel?.title ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    func showExhibitionDetailVC(exhibitionID: Int) {
        //展览详情
        let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
        let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
        vc.exhibition_id = exhibitionID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //展览攻略详情
    func showRelatedStrategyVC(exhibitionID: Int)  {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDectail_VC") as! HDLY_TopicDetail_VC
        vc.topic_id = "\(exhibitionID)"
        vc.fromRootAChoiceness = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //精选推荐详情
    func showRecomendDetailVC(classID: Int) {
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
        vc.courseId = "\(classID)"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}




