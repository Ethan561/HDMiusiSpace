//
//  HDSSL_dExhibitionDetailVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/13.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

let kBannerHeight = ScreenWidth*250/375.0

class HDSSL_dExhibitionDetailVC: HDItemBaseVC {
    //接收
    var exhibition_id: Int?
    var exhibitionCellH: Double?
    var exhibitCellH: Double?
    
    
    //
    @IBOutlet weak var bannerBg: UIView!
    @IBOutlet weak var dTableView: UITableView!
    @IBOutlet weak var bannerNumL: UILabel!
    

    //
    var exdataModel: ExhibitionDetailDataModel?
    //
    var bannerView: ScrollBannerView!//banner
    var bannerImgArr: [String]? = Array.init() //轮播图数组
    var imgsArr: Array<String>?
    
    //评论
    var commentArr: [CommentListModel]? = Array.init()
    
    //mvvm
    var viewModel: HDSSL_ExDetailVM = HDSSL_ExDetailVM()
    
    //评论header
    lazy var commentHeader = HDSSL_dCommentHerder.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 75))
    //其他header
//    lazy var normalHeader = HDSSL_dHeaderNormal.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hd_navigationBarHidden = true
        
        //
        bindViewModel()
        //
        loadMyDatas()
        //banner
        setupBannerView()
        //
        setupdTableView()
    }
    
    //MARK: 加载数据
    func loadMyDatas() {
        //请求数据
        viewModel.request_getExhibitionDetail(exhibitionId: 1, vc: self)
    }
    
    //mvvm
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //展览data
        viewModel.exhibitionData.bind { (data) in
            
            weakSelf?.showViewData()
            
        }
        
    }
    //处理返回数据
    func showViewData() {
        self.exdataModel = viewModel.exhibitionData.value
        self.commentArr = exdataModel!.data?.commentList?.list //评论
        self.bannerImgArr = exdataModel?.data?.imgList //banner
        //img绝对地址
        bannerView.imgPathArr = bannerImgArr!
        imgsArr = bannerImgArr

        self.dTableView.reloadData()
    }
    
    //MARK: action
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_topButton(_ sender: UIButton) {
        print(sender.tag)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HDSSL_dExhibitionDetailVC: ScrollBannerViewDelegate {
    //MARK:---显示banner View
    func setupBannerView() {
        
        self.bannerNumL.layer.cornerRadius = 15
        self.bannerNumL.layer.masksToBounds = true
        
        bannerView = ScrollBannerView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: kBannerHeight))//750:422
        bannerBg.insertSubview(bannerView, at: 0)
        bannerView.placeholderImg = UIImage.init(named: "img_nothing")!
        bannerView.pageControlAliment = .center
        bannerView.pageControlBottomDis = 15
        
//                if bannerView.pageControl != nil {
//                    bannerView.pageControl!.isHidden = true
//                }
        
        //img相对地址
        //        if self.bannerImgArr != nil {
        //            var imgArr = Array<String>()
        //            for path in self.bannerImgArr! {
        //                let imagePath = HDDeclare.IP_Request_Header() + path
        //                imgArr.append(imagePath)
        //            }
        //            bannerView.imgPathArr = imgArr
        //            imgsArr = imgArr
        //        }
        //img绝对地址
        bannerView.imgPathArr = bannerImgArr!
        imgsArr = bannerImgArr
        bannerView.delegate = self
        bannerView.clickItemClosure = { (index) -> Void in
            LOG("闭包回调---\(index)")
        }
        
        
    }
    
    func cycleScrollView(_ scrollView: ScrollBannerView, didScorllToIndex index: Int) {
        if imgsArr != nil {
            let str = "\(index+1)/\(imgsArr!.count)"
            self.bannerNumL.text = str
        }
    }
    
    func cycleScrollView(_ scrollView: ScrollBannerView, didSelectItemAtIndex index: Int) {
        
        showBigImageAtIndex(index)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //let result = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight")
        LOG("加载完成")
    }
    
    //查看大图
    func showBigImageAtIndex(_ index: NSInteger) {
        if imgsArr != nil {
            let vc = HD_SSL_BigImageVC.init()
            vc.imageArray = imgsArr as NSArray? as! [String]
            vc.atIndex = index
            self.present(vc, animated: true, completion: nil)
            
        }
    }
}

extension HDSSL_dExhibitionDetailVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let arr = self.exdataModel?.data?.dataList!
        
        if arr == nil {
            return 3
        }
        return 3 + (arr?.count)!
    }
    //0基本信息5条，1展览介绍合展品介绍两个H5，2评论，3同馆展览
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 2
        }else if section == 2 {
            
            return self.commentArr!.count
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 80
            }else if indexPath.row == 1 {
                return 70
            }
            return 40
        }else if indexPath.section == 1 {
            //H5
            if indexPath.row == 0 {
                return CGFloat(self.exhibitionCellH ?? 0)
            }else if indexPath.row == 1 {
                if self.exdataModel?.data?.isExhibit == 0{
                    return 0.01
                }
                return CGFloat(self.exhibitCellH ?? 0)
            }
            
        }else if indexPath.section == 2 {
            //评论
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDSSL_dCommentCell")
            let model = self.commentArr![indexPath.row]
            
            let comH = self.getCommentCellHeight(model)
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraints()
            
            return comH
        }else {
            let arr = self.exdataModel?.data?.dataList!
            let model = arr![indexPath.section-3]
            if model.type == 1{
                return 250
            }else if model.type == 2{
                return 330
            }else if model.type == 3 {//相关活动
                return 375
            }else if model.type == 4 {//精选推荐
                return 160*ScreenWidth/375.0
            }else if model.type == 5 {//免费听
                return 160*ScreenWidth/375.0
            }

        }
        return 70
    }
    //MARK: ---------Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 85
        }
        if section > 2{
            return 44
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            //评论
            let totalNum = self.exdataModel?.data?.commentList?.total
            let picNum = self.exdataModel?.data?.commentList?.imgNum
            commentHeader.btn_all.setTitle(String.init(format: "全部(%d)",totalNum ?? 0), for: .normal)
            commentHeader.btn_havePic.setTitle(String.init(format: "有图(%d)",picNum ?? 0), for: .normal)
            return commentHeader
        }
        if section > 2 {
            let normalHeader = HDSSL_dHeaderNormal.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 44))
            
            let arr = self.exdataModel?.data?.dataList!
            let model = arr![section-3]
            
            var titleStr: String?
            
            if model.type == 1{
                titleStr = String.init(format: "同馆展览(%d)", model.exhibition?.exhibitionNum ?? 0)
            }else if model.type == 2{
                titleStr = "展览攻略"
            }else if model.type == 3{
                titleStr = "相关活动"
            }else if model.type == 4{
                titleStr = "精选推荐"
            }else if model.type == 5{
                titleStr = "免费听"
            }
            normalHeader.headerTitle.text = titleStr
            normalHeader.tag = section
            normalHeader.BlockShowmore { (index) in
                print(index)
                //查看更多
            }
            return normalHeader
        }
        return nil
    }
    
    //MARK: ---------Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            guard self.exdataModel != nil else {
                return 0.01
            }
            if (self.exdataModel?.data?.commentList?.total)! > 2 {
                return 40
            }
        }
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
            btn.backgroundColor = UIColor.white
            btn.setTitle(String.init(format: "查看更多评论（%d）", self.exdataModel?.data?.commentList?.total ?? 0), for: .normal)
            btn.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
            btn.addTarget(self, action: #selector(action_showMoreComment), for: .touchUpInside)
            
            return btn
        }
        //其他footer
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = HDSSL_Sec0_Cell0.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell0
                cell.cell_titleL.text = String.init(format: "%@", self.exdataModel?.data?.title ?? "")
                cell.cell_starNumL.text = String.init(format: "%.1f", self.exdataModel?.data?.star ?? "")
                cell.starNum = self.exdataModel?.data?.star ?? 0.0
                
                
                return cell
            }
            else if indexPath.row == 1 {
                let cell = HDSSL_Sec0_Cell1.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell1

                cell.cell_timeL.text = String.init(format: "%@", self.exdataModel?.data?.time ?? "")
                return cell
            }
            else  {
                let cell = HDSSL_Sec0_cellNormal.getMyTableCell(tableV: tableView) as HDSSL_Sec0_cellNormal
                
                var name: String?
                var title: String?
                
                if indexPath.row == 2 {
                    name = "展厅："
                    title = String.init(format: "%@", self.exdataModel?.data?.exhibitionName ?? "")
                }else if indexPath.row == 3 {
                    name = "费用："
                    title = String.init(format: "%@", self.exdataModel?.data?.price ?? "")
                }else if indexPath.row == 4 {
                    name = "地址："
                    title = String.init(format: "%@", self.exdataModel?.data?.address ?? "")
                    cell.accessoryType = .disclosureIndicator
                }
                
                cell.cell_nameL.text = name
                cell.cell_titleL.text = title
                
                return cell
            }
            
            
        }
        else if indexPath.section == 1 {
            //加载两个webView
            //展览介绍🈴️展品介绍
            if indexPath.row == 0 {
                let cell = HDSSL_Sec1Cell.getMyTableCell(tableV: tableView) as HDSSL_Sec1Cell
                let path = String.init(format: "%@", self.exdataModel?.data?.exhibitionHTML ?? "")
                cell.loadWebView(path)
                
                cell.blockHeightFunc { (height) in
                    print(height)
                    
                    weak var weakSelf = self
                    weakSelf?.reloadExhibitionCellHeight(height)
                    
                }
                return cell
            }else if indexPath.row == 1{
                let cell = HDSSL_Sec1Cell.getMyTableCell(tableV: tableView) as HDSSL_Sec1Cell
                let path = String.init(format: "%@", self.exdataModel?.data?.exhibitHTML ?? "")
                cell.loadWebView(path)
                cell.blockHeightFunc { (height) in
                    print(height)
                    
                    weak var weakSelf = self
                    weakSelf?.reloadExhibitCellHeight(height)
                    
                }
                return cell
            }
        }
        else if indexPath.section == 2 {
            weak var weakSelf = self
            
            let cell = HDSSL_dCommentCell.getMyTableCell(tableV: tableView) as HDSSL_dCommentCell
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            cell.myModel = self.commentArr![indexPath.row]
            cell.BlockTapImgItemFunc { (index,cellIndex) in
                print("点击第\(index)张图片，第\(cellIndex)个cell")
                weakSelf?.showCommentBigImgAt(cellIndex, index)
            }
            cell.BlockTapLikeFunc { (index) in
                print("点击喜欢按钮，位置\(index)")
            }
            cell.BlockTapCommentFunc { (index) in
                print("点击评论按钮，位置\(index)")
            }
            return cell
        }
        else  {
            let arr = self.exdataModel?.data?.dataList!
            let model = arr![indexPath.section-3]
            if model.type == 1{
                let cell = HDSSL_sameMuseumCell.getMyTableCell(tableV: tableView)
                cell?.listArray = model.exhibition?.list
                cell?.BlockTapItemFunc(block: { (index) in
                    print(index) //点击同馆展览
                })
                
                return cell!
            }else if model.type == 2 {//展览攻略
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
        let cell = HDSSL_Sec0_Cell0.getMyTableCell(tableV: tableView) as HDSSL_Sec0_Cell0
        return cell
        
    }
    
    func setupdTableView()  {
        //
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.tableFooterView = getTableFooterView()
    }
    //查看更多评论
    @objc func action_showMoreComment(){
        print("查看更多评论")
    }
    func getTableFooterView() -> UIView {
        let  tFooter = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 80))
        tFooter.backgroundColor = UIColor.white
        
        let tipEnd = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 20))
        tipEnd.text = "到底了～"
        tipEnd.textColor = UIColor.lightGray
        tipEnd.font = UIFont.systemFont(ofSize: 11)
        tipEnd.textAlignment = .center
        
        tFooter.addSubview(tipEnd)
        
        let guideBtn = UIButton.init(frame: CGRect.init(x: 20, y: 25, width: ScreenWidth-40, height: 50))
        guideBtn.setTitle("导览", for: .normal)
        guideBtn.setTitleColor(UIColor.white, for: .normal)
        guideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        guideBtn.layer.cornerRadius = 25
        guideBtn.backgroundColor = UIColor.HexColor(0xE8593E)
        guideBtn.addTarget(self, action: #selector(action_guide), for: .touchUpInside)
        
        tFooter.addSubview(guideBtn)
        
        return tFooter
    }
    
    @objc func action_guide(){
        print("开始导览")
    }
    //刷新webview，是否显示
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let cells = self.dTableView.visibleCells
//
//        for cell in cells {
//            if cell.isKind(of: HDSSL_Sec1Cell.self) {
//                let webCell = cell as! HDSSL_Sec1Cell
//                webCell.webview.setNeedsLayout()
//            }
//        }
//
//    }
    
}

extension HDSSL_dExhibitionDetailVC{
    //获取评论cell的高度
    func getCommentCellHeight(_ model: CommentListModel) -> CGFloat {
        let content = String.init(format: "%@", model.content)
        
        let kkSpace: CGFloat = 10.0
        let kkWidth: CGFloat = CGFloat((UIScreen.main.bounds.width-55-20)/3.0)
        
        //头像、间距等高度
        let otherH = 48.0 + 30.0
        //文本
        let size = content.getLabSize(font: UIFont.systemFont(ofSize: 11), width: ScreenWidth - 55)
        //图片
        var imgH: CGFloat? = 0.0
        if (model.imgList?.count)! > 0 {
            imgH = (kkSpace + kkWidth) * CGFloat(((model.imgList?.count)!-1)/3+1)
        }else {
            imgH = 20.0
        }
        
        return imgH! + size.height + CGFloat(otherH)
    }
    //刷新展览介绍cell高度
    func reloadExhibitionCellHeight(_ height: Double) {
        if self.exhibitionCellH == nil {
            self.exhibitionCellH = height
            self.dTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        }else if self.exhibitionCellH! < height {
            self.exhibitionCellH = height
            self.dTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        }
        
    }
    //刷新展品介绍cell高度
    func reloadExhibitCellHeight(_ height: Double) {
        if self.exhibitCellH == nil{
            self.exhibitCellH = height
            self.dTableView.reloadRows(at: [IndexPath.init(row: 1, section: 1)], with: .none)
        }
        if self.exhibitCellH! < height {
            self.exhibitCellH = height
            self.dTableView.reloadRows(at: [IndexPath.init(row: 1, section: 1)], with: .none)
        }
        
    }
    
    //显示评论图片大图
    func showCommentBigImgAt(_ cellLoc: Int,_ index: Int) {
        let model = self.commentArr![cellLoc]
        
        if model.imgList != nil {
            let vc = HD_SSL_BigImageVC.init()
            vc.imageArray = model.imgList
            vc.atIndex = index
            self.present(vc, animated: true, completion: nil)
            
        }
    }
}

