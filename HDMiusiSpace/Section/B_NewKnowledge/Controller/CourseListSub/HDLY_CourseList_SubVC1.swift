//
//  HDLY_CourseList_SubVC1.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol ChapterListPlayDelegate: NSObjectProtocol {
    
    func playWithCurrentPlayUrl(_ model: ChapterList)
    
}

class HDLY_CourseList_SubVC1: HDItemBaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomHCons: NSLayoutConstraint!
    @IBOutlet weak var buyBtn: UIButton!
    
    weak var delegate:ChapterListPlayDelegate?

    var isBuy = false//已购买或者是免费课程
    
    var infoModel: CourseChapter?
    var courseId: String?
    //MVVM
    let publicViewModel: CoursePublicViewModel = CoursePublicViewModel()
    var orderTipView: HDLY_CreateOrderTipView?
    
    var isPlaying =  false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var selectRow = -1
    var selectSection = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.、
        buyBtn.layer.cornerRadius = 27
        tableView.delegate = self
        tableView.dataSource = self
        self.bottomHCons.constant = 0
        let emptyView:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_nothing", titleStr: "还没有内容呢～", detailStr: "", btnTitleStr: "") {
            
        }
        emptyView.contentViewY = 0
        emptyView.titleLabTextColor = UIColor.lightGray
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        self.tableView.ly_emptyView = emptyView
        
        dataRequest()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAction), name: NSNotification.Name.init(rawValue: "HDLYCourseDesVC_NeedRefresh_Noti"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseChapterInfo(api_token: token, id: idnum), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseChapter = try! jsonDecoder.decode(CourseChapter.self, from: result)
            self.infoModel = model
            
            if self.infoModel?.data.isFree == 0 {//1免费，0不免费
                if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                    if self.infoModel!.data.yprice != nil {
                        let priceString = NSMutableAttributedString.init(string: "原价¥\(self.infoModel!.data.yprice!)")
//                        let ypriceAttribute =
//                            [NSAttributedStringKey.foregroundColor : UIColor.HexColor(0xFFD0BB),//颜色
//                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),//字体
//                                NSAttributedStringKey.strikethroughStyle: NSNumber.init(value: 1)//删除线
//                                ] as [NSAttributedStringKey : Any]
//                        priceString.addAttributes(ypriceAttribute, range: NSRange(location: 0, length: priceString.length))
//                        //
//                        let vipPriceString = NSMutableAttributedString.init(string: "会员价¥\(self.infoModel!.data.price!) ")
//                        let vipPriceAttribute =
//                            [NSAttributedStringKey.foregroundColor : UIColor.white,//颜色
//                                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),//字体
//                                ] as [NSAttributedStringKey : Any]
//                        vipPriceString.addAttributes(vipPriceAttribute, range: NSRange(location: 0, length: vipPriceString.length))
//                        vipPriceString.append(priceString)
                        self.buyBtn.setTitle("原价¥\(self.infoModel!.data.yprice!)", for: .normal)
                        self.buyBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
                    }
                    self.bottomHCons.constant = 74
                    self.isBuy = false
                }else {
                    self.bottomHCons.constant = 0
                    self.bottomView.isHidden = true
                    self.isBuy = true
                }
            } else {
                self.bottomHCons.constant = 0
                self.bottomView.isHidden = true
                self.isBuy = true
            }
            self.tableView.ly_endLoading()
            self.tableView.reloadData()

        }) { (errorCode, msg) in
            self.tableView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.tableView.ly_showEmptyView()
            self.tableView.ly_endLoading()

        }
    }
    
    @objc func refreshAction() {
        dataRequest()
    }
    
    @IBAction func buyBtnAction(_ sender: Any) {
        buyGoodsAction()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HDLY_CourseList_SubVC1 {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if infoModel?.data.sectionList != nil {
            return infoModel!.data.sectionList.count
        }
        return 0
    }
    
    //header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 50))
        let listHeader:HDLY_CourseList_Header = HDLY_CourseList_Header.createViewFromNib() as! HDLY_CourseList_Header
        listHeader.frame = headerV.bounds
        headerV.addSubview(listHeader)
        if infoModel?.data.sectionList != nil {
            guard let model = infoModel?.data.sectionList[section] else {
                return headerV
            }
            listHeader.titleL.text = model.title
            listHeader.subTitleL.text = "共\(model.chapterNum.string)小节"
        }
        
        return headerV
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
        if infoModel?.data.sectionList != nil {
            guard let model = infoModel?.data.sectionList[section] else {
                return 0
            }
            return model.chapterList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDLY_CourseList_Cell.getMyTableCell(tableV: tableView, indexP: indexPath)
        if infoModel?.data.sectionList != nil {
            guard let sectionModel = infoModel?.data.sectionList[indexPath.section] else {
                return cell!
            }
            let listModel = sectionModel.chapterList[indexPath.row]
            cell!.nameL.text = listModel.title
            cell!.timeL.text = listModel.timeLong
            cell!.nameL.textColor = UIColor.HexColor(0x4A4A4A)
            cell!.timeL.textColor = UIColor.HexColor(0x9B9B9B)
            cell!.tipImgV.image = UIImage.init(named: "xz_daoxue_play")

            let width = listModel.title.getContentWidth(font: UIFont.systemFont(ofSize: 14), height: 21)
            if width > ScreenWidth - 190 {
                cell!.nameWidthCons.constant = ScreenWidth - 190
            }
            if self.isBuy == false {
                //0收费 1免费 2vip免费
                if listModel.freeType == 0 {
                    cell!.tagL.isHidden = true
                    cell!.tipImgV.image = UIImage.init(named: "xz_icon_suo")
                }
                else if listModel.freeType == 1 {
                    cell!.tagL.isHidden = false
                    cell!.tagL.text = "试听"
                    cell!.tagL.backgroundColor = UIColor.HexColor(0xC1B6AE)
                    cell!.tagL.textColor = UIColor.white
                    
                    cell!.tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                    cell!.nameL.textColor = UIColor.HexColor(0x4A4A4A)
                    cell!.timeL.textColor = UIColor.HexColor(0x9B9B9B)
                    //有播放或者暂停状态的
                    if indexPath.row == selectRow && indexPath.section == selectSection {
                        cell?.nameL.textColor = UIColor.HexColor(0xE8593E)
                        cell?.timeL.textColor = UIColor.HexColor(0xE8593E)
                        if isPlaying == true {//播放
                            cell?.tipImgV.image = UIImage.init(named: "icon_pause_white")
                        }else {//暂停
                            cell?.tipImgV.image = UIImage.init(named: "icon_paly_white")
                        }
                    }
                }
                else if listModel.freeType == 2 {
                    cell!.tagL.isHidden = false
                    cell!.tagL.backgroundColor = UIColor.HexColor(0xD8B98D)
                    cell!.tagL.textColor = UIColor.white
                    cell!.tagL.text = "SVIP"
                    cell!.tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                }
                
            }else {//已购买
                cell?.tagL.isHidden = true
                cell?.tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                //有播放或者暂停状态的
                if indexPath.row == selectRow && indexPath.section == selectSection {
                    cell?.nameL.textColor = UIColor.HexColor(0xE8593E)//红色展示
                    cell?.timeL.textColor = UIColor.HexColor(0xE8593E)
                    if isPlaying == true {//播放
                        cell?.tipImgV.image = UIImage.init(named: "icon_pause_white")
                    }else {//暂停
                        cell?.tipImgV.image = UIImage.init(named: "icon_paly_white")
                    }
                }
            }
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionModel = infoModel?.data.sectionList[indexPath.section] else {
            return
        }
        let listModel = sectionModel.chapterList[indexPath.row]
    
        if self.isBuy == false {
            //0收费 1免费 2vip免费
            if listModel.freeType == 0 {
                
            }
            else if listModel.freeType == 1 {
                selectRow = indexPath.row
                selectSection = indexPath.section
                delegate?.playWithCurrentPlayUrl(listModel)
                
            }
            else if listModel.freeType == 2 {

            }
        } else {
            selectRow = indexPath.row
            selectSection = indexPath.section
            delegate?.playWithCurrentPlayUrl(listModel)
        }
    }
    
    
    
}

extension  HDLY_CourseList_SubVC1{
    func buyGoodsAction() {
        if  self.infoModel?.data  != nil {
            if self.infoModel?.data.isBuy == 0 {//0未购买，1已购买
                if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
                    self.pushToLoginVC(vc: self)
                    return
                }
                //获取订单信息
                guard let goodId = self.infoModel?.data.articleID.int else {
                    return
                }
                publicViewModel.orderGetBuyInfoRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: goodId, self)
                return
                
            }
        }
    }
    
    //显示支付弹窗
    func showOrderTipView( _ model: OrderBuyInfoData) {
        let tipView: HDLY_CreateOrderTipView = HDLY_CreateOrderTipView.createViewFromNib() as! HDLY_CreateOrderTipView
        guard let win = kWindow else {
            return
        }
        tipView.frame = win.bounds
        win.addSubview(tipView)
        orderTipView = tipView
        
        tipView.titleL.text = model.title
        if model.price != nil {
            tipView.priceL.text = "¥\(model.price!)"
            tipView.spaceCoinL.text = model.spaceMoney
            tipView.sureBtn.setTitle("支付\(model.price!)空间币", for: .normal)
        }
        weak var _self = self
        tipView.sureBlock = {
            _self?.orderBuyAction(model)
        }
        
    }
    
    func orderBuyAction( _ model: OrderBuyInfoData) {
        guard let goodId = self.infoModel?.data.articleID.int else {
            return
        }
        if Float(model.spaceMoney!) ?? 0 < Float(model.price!) ?? 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.pushToMyWalletVC()
                self.orderTipView?.removeFromSuperview()
            }
            return
        }
        publicViewModel.createOrderRequest(api_token: HDDeclare.shared.api_token!, cate_id: 1, goods_id: goodId, pay_type: 1, self)
        
    }
    
    //显示支付结果
    func showPaymentResult(_ model: OrderResultData) {
        guard let result = model.isNeedPay else {
            return
        }
        if result == 2 {
            orderTipView?.successView.isHidden = false
//            self.dataRequest()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HDLYCourseDesVC_NeedRefresh_Noti"), object: nil)

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                self.orderTipView?.sureBlock = nil
                self.orderTipView?.removeFromSuperview()
            }
        }
        
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //获取订单支付信息
        publicViewModel.orderBuyInfo.bind { (model) in
            weakSelf?.showOrderTipView(model)
        }
        
        //生成订单并支付
        publicViewModel.orderResultInfo.bind { (model) in
            weakSelf?.showPaymentResult(model)
        }
        
    }
}
