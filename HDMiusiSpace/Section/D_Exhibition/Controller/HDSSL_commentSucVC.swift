//
//  HDSSL_commentSucVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentSucVC: HDItemBaseVC {
    //传递参数
    var commentId: Int? //发布成功，返回评论id
    var htmlShareUrl:String? //发布成功，返回分享地址
    
    @IBOutlet weak var btn_sharePaper: UIButton!
    @IBOutlet weak var btn_shareMyComment: UIButton!
    @IBOutlet weak var dTableView: UITableView!
    
    var isShowMore: Bool = false
    
    //mvvm
    var viewModel: HDSSL_commentVM = HDSSL_commentVM()
    var dataArray: [HDSSL_uncommentModel]? = Array.init()
    
    var paperPath: String? //画报地址
    var shareView: HDLY_ShareView?
    
    
    override func viewDidLoad() {
        isHideBackBtn = true
        super.viewDidLoad()

        loadMyView()
        
        //
        bindViewModel()
        
        //请求数据
        viewModel.request_getNerverCommentList(skip: 0, take: 100, vc: self)
    }
    //mvvm
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //展览data
        viewModel.dataList.bind { (array) in
            
            weakSelf?.dealData(data: array)
            
        }
        
        //画报
        viewModel.paperModel.bind { (paper) in
            
            weakSelf?.jumpPaperVC(model: paper)
            
        }
        
    }
    func jumpPaperVC(model: HDSSL_PaperModel)  {
        
        self.paperPath = model.data!
        
        let commentSvc = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_shareCommentVC") as! HDSSL_shareCommentVC
        commentSvc.imgPath = self.paperPath
        commentSvc.commentId = self.commentId
        self.navigationController?.pushViewController(commentSvc, animated: true)
    }
    func dealData(data:[HDSSL_uncommentModel]) {
        //
        self.dataArray = data
        dTableView.reloadData()
        
    }
    func loadMyView(){
        self.title = "评论成功"
        
        let closeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(action_close), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = item
        
        btn_shareMyComment.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
        btn_shareMyComment.layer.borderWidth = 1.0
        
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.tableFooterView = getTableFooter()
    }
    @objc func action_close(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func action_showMore(){
        //
        print("更多待评论")
        isShowMore = true
        dTableView.reloadData()
        dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    @IBAction func action_sharePaper(_ sender: Any) {
        //1、请求生成图片、2、跳页显示画报
        request_createPaper()
        
    }
    @IBAction func action_shareMyComment(_ sender: Any) {
        //分享
        //分享
        let tipView: HDLY_ShareView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
        shareView = tipView
        
    }
    
    func request_createPaper() {
        //
        viewModel.request_createPaper(api_token: HDDeclare.shared.api_token!, commentId: self.commentId!, vc: self)
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
extension HDSSL_commentSucVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //展示更多
        if isShowMore == true {
            return (dataArray?.count)!
        }
        //最多3条
        if (dataArray?.count)! > 3 {
            return 3
        }else {
            return (dataArray?.count)!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 10))
        view.backgroundColor = UIColor.HexColor(0xF0F0F0)
        return view
    }

    func getTableFooter() -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
        view.backgroundColor = UIColor.white
        
        let line = UIView.init(frame: CGRect.init(x: 15, y: 0, width: ScreenWidth-30, height: 1))
        line.backgroundColor = UIColor.HexColor(0xEEEEEE)
        view.addSubview(line)
        
        let showMoreBtn = UIButton.init(frame: CGRect.init(x: ScreenWidth-100, y: 1, width: 80, height: 40))
        showMoreBtn.setTitle("更多待评论", for: .normal)
        showMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        showMoreBtn.setTitleColor(UIColor.black, for: .normal)
        showMoreBtn.addTarget(self, action: #selector(action_showMore), for: .touchUpInside)
        view.addSubview(showMoreBtn)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HDSSL_neverCommentCell.getMyTableCell(tableV: tableView) as HDSSL_neverCommentCell
        cell.tag = indexPath.row
        cell.BlockTapBtnFunc { (index) in
            //去评论
            print(index)
        }
        if self.dataArray!.count > 0 {
            let model = dataArray![indexPath.row]
            cell.model = model
        }
        
        return cell
        
    }
    
    
}
//MARK:--- 分享
extension HDSSL_commentSucVC: UMShareDelegate {
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard let url  = self.htmlShareUrl else {
            return
        }
        
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = url
        let shareObject = UMShareWebpageObject.shareObject(withTitle: "缪斯空间", descr: "归属感，缪斯空间", thumImage: thumbURL)
        
        //设置网页地址
        shareObject?.webpageUrl = url
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject
        
        weak var weakS = self
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { data, error in
            if error != nil {
                //UMSocialLog(error)
                LOG(error)
                weakS?.shareView?.alertWithShareError(error!)
            } else {
                if (data is UMSocialShareResponse) {
                    let resp = data as? UMSocialShareResponse
                    //分享结果消息
                    LOG(resp?.message)
                    //第三方原始返回的数据
                    print(resp?.originalResponse ?? 0)
                } else {
                    LOG(data)
                }
                HDAlert.showAlertTipWith(type: .onlyText, text: "分享成功")
                HDLY_ShareGrowth.shareGrowthRequest()
                weakS?.shareView?.removeFromSuperview()
            }
        }
        
    }
}
