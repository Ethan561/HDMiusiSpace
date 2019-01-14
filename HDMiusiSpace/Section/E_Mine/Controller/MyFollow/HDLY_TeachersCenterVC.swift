//
//  HDLY_TeachersCenterVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh
class HDLY_TeachersCenterVC: HDItemBaseVC {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    private var classList =  [TeacherClassList]()
    private var news =  [PlatNewsList]()
    public var type = 1 // 1教师, 2机构
    public var detailId = 0 //

    private var viewModel = HDZQ_MyViewModel()
    @IBOutlet weak var tableView: UITableView!
    let tabHeader = HDZQ_PersonOthersHeaderView.createViewFromNib() as! HDZQ_PersonOthersHeaderView
    private var take = 10
    private var skip = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = CGRect.init(x: 0, y: 44, width: ScreenWidth, height: ScreenHeight - kTopHeight-44)
        view.addSubview(self.tableView)
        if type != 1 {
            tableView.separatorStyle = .none
        }
        if type == 1 {
            self.title = "讲师主页"
        } else {
            self.title = "机构主页"
        }
        addRefresh()
        bindViewModel()
        tabHeader.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 215)
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 215))
        v.addSubview(tabHeader)
        self.view.addSubview(v)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData() {
        let token = HDDeclare.shared.api_token ?? ""
        if type == 1 {
            viewModel.requestMyFollowForTeacher(apiToken: token, skip: skip, take: take, teacher_id: detailId, vc: self)
        } else {
            viewModel.requestMyFollowForPlat(apiToken: token, skip: skip, take: take, platform_id: detailId, vc: self)
        }
    }
    
    func bindViewModel() {
        
        viewModel.teacherDynamic.bind { [weak self] (data) in
            if (self?.skip)! > 0 {
                self?.classList.append(contentsOf: data.classList!)
            } else {
                self?.classList = data.classList!
                self?.refreshUIForTeacher(data)

            }
            if (self?.classList.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if data.classList!.count == 0 {
                self?.tableView.es.noticeNoMoreData()
            }
        }
        
        viewModel.platDynamic.bind { [weak self] (data) in
            if (self?.skip)! > 0 {
                self?.news.append(contentsOf: data.newsList!)
            } else {
                self?.news = data.newsList!
                self?.refreshUIForPlat(data)
            }
            if (self?.news.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if data.newsList!.count == 0 {
                self?.tableView.es.noticeNoMoreData()
            }
        }
    }
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
            self?.refresh()
        }
        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.tableView.refreshIdentifier = String.init(describing: self)
        self.tableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        requestData()
    }
    
    private func loadMore() {
        skip = skip + take
        requestData()
    }
    
    func refreshUIForTeacher(_ model: TeacherDynamicData) {
        
        tabHeader.avatar.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        tabHeader.nickNameL.text = model.title
        tabHeader.desLabel.text = model.subTitle
        tabHeader.teacherDesL.isHidden = false

        let desHeight = model.des?.getContentHeight(font: UIFont.systemFont(ofSize: 14.0), width: ScreenWidth - 40)
        
        tabHeader.frame.size.height = 215 + desHeight! - 75
        
        topConstraint.constant = 215 + desHeight! - 75
        
        tabHeader.teacherDesL.text = model.des
        tabHeader.leftView.isHidden = true
        tabHeader.rightView.isHidden = true
        tabHeader.lineView.isHidden = true
        tabHeader.genderImg.isHidden = true
        
        if model.isFocus == 1 {
            tabHeader.followBtn.setTitle("已关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.tabHeader.followBtn.size), for: .normal)

        } else {
            tabHeader.followBtn.setTitle("+关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.tabHeader.followBtn.size), for: .normal)

        }
        
        tabHeader.followBtn.addTouchUpInSideBtnAction { [weak self] (btn) in
            self?.followAction(id: "\(model.teacherID!)" , cate_id: "2", api_token: HDDeclare.shared.api_token ?? "")
        }
        tableView.reloadData()
    }
    
    func refreshUIForPlat(_ model: PlatDynamicData) {
        
        tabHeader.avatar.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        tabHeader.nickNameL.text = model.title
        tabHeader.desLabel.text = "学习机构"
        tabHeader.teacherDesL.isHidden = false

        tabHeader.teacherDesL.text = model.des
        
        let desHeight = model.des?.getContentHeight(font: UIFont.systemFont(ofSize: 14.0), width: ScreenWidth - 40)
        
        tabHeader.frame.size.height = 190 + desHeight! - 75
        
        topConstraint.constant = 190 + desHeight! - 75
        
        tabHeader.leftView.isHidden = true
        tabHeader.rightView.isHidden = true
        tabHeader.lineView.isHidden = true
        
        if model.isFocus == 1 {
            tabHeader.followBtn.setTitle("已关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.tabHeader.followBtn.size), for: .normal)

        } else {
            tabHeader.followBtn.setTitle("+关注", for: .normal)
            self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.tabHeader.followBtn.size), for: .normal)

        }
        
        tabHeader.followBtn.addTouchUpInSideBtnAction { [weak self] (btn) in
            self?.followAction(id: "\(model.platformID!)", cate_id: "1", api_token: HDDeclare.shared.api_token ?? "")
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
                    self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xCCCCCC), imgSize: self.tabHeader.followBtn.size), for: .normal)

                }else {
                    self.tabHeader.followBtn.setTitle("+关注", for: .normal)
                self.tabHeader.followBtn.setBackgroundImage(UIImage.getImgWithColor(UIColor.HexColor(0xE8593E), imgSize: self.tabHeader.followBtn.size), for: .normal)

                }
            }
            if let msg:String = dic!["msg"] as? String{
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: msg)
            }
            
        }) { (errorCode, msg) in
            
        }
    }
    
    
}

extension HDLY_TeachersCenterVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1 {
            return classList.count
        } else {
            return news.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == 1 {
            return 126*ScreenWidth/375.0
        } else {
            return 175
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 48))
        header.backgroundColor = UIColor.white
        let top = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 8))
        top.backgroundColor = UIColor.HexColor(0xF0F0F0)
        header.addSubview(top)
        let label = UILabel.init(frame: CGRect.init(x: 20, y: 18, width: 200, height: 20))
        if type == 1 {
            label.text = "讲师课程"
        } else {
            label.text = "他的动态"
        }
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == 1 {
            let cell = HDLY_Recommend_Cell1.getMyTableCell(tableV: tableView)
            if classList.count > 0 {
                let model = classList[indexPath.row]
                if  model.img != nil  {
                    cell?.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: (cell?.imgV)!), options: nil, progressBlock: nil, completionHandler: nil)
                }

                cell?.titleL.text = model.title
                cell?.authorL.text = String.init(format: "%@  %@", (model.teacherName)! ,(model.teacherTitle)!)
                cell?.countL.text = model.purchases == nil ? "0" : "\(model.purchases!)" + "人在学"
                cell?.courseL.text = model.classNum == nil ? "0" : "\(model.classNum!)" + "课时"
                if model.fileType == 1 {//mp3
                    cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_audio_black_default")
                }else {
                    cell?.typeImgV.image = UIImage.init(named: "xinzhi_icon_video_black_default")
                }
                if model.isFree == 0 {
                    cell?.priceL.textColor = UIColor.HexColor(0xE8593E)
                    if model.price != nil {
                        cell?.priceL.text = "¥" + "\(model.price!)"
                    }
                }else {
                    cell?.priceL.text = "免费"
                    cell?.priceL.textColor = UIColor.HexColor(0x4A4A4A)
                }
            }
            
            return cell!
            
        } else {
            let cell = HDLY_MyDynamicCell.getMyTableCell(tableV: tableView)
            if self.news.count > 0 {
                let model = news[indexPath.row]
                cell?.titleLTopCons.constant = 16
                cell?.desView.isHidden = true
                cell?.moreBtn.isHidden = true
                cell?.publishLabel.text = "发布了文章"
                //
                cell?.avaImgV.kf.setImage(with: URL.init(string: model.avatar!), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
                cell?.contentL.isHidden = true
                cell?.timeL.text = model.createdAt
                cell?.nameL.text = model.platformTitle
                if model.img != nil {
                    cell?.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell!.imgV))
                }
                cell?.titleL.text = model.title
                cell?.locL.text = String.init(format: "%@|%@", model.keywords!, model.platformTitle!)
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 2 {//资讯
            let model = news[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
            vc.topic_id = String.init(format: "%ld", model.articleID ?? 0)
            vc.fromRootAChoiceness = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {//课程
            let model = classList[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
            vc.courseId = "\(model.classID!)"
            vc.isFromTeacherCenter = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}



