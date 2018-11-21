//
//  HDSSL_commentListVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentListVC: HDItemBaseVC {

    var listType: Int?  //1全部，2有图
    var exhibition_id: Int?
    
    @IBOutlet weak var btn_all: UIButton!
    @IBOutlet weak var btn_pic: UIButton!
    @IBOutlet weak var dTableView: UITableView!
    
    var myModel : ExComListModel? //data所有返回数据
    var allCommentCount: Int? //全部评论
    var picCommentCount: Int? //有图评论
    var commentArray:[ExCommentModel] = Array.init() //评论数组
    
    //mvvm
    var viewModel: HDSSL_commentVM = HDSSL_commentVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
        
        bindViewModel()
        
        //请求数据
        viewModel.request_getExhibitionCommentList(type: 1, skip: 0, take: 10, exhibitionID: self.exhibition_id!, vc: self)
    }
    
    func loadMyViews() {
        self.title = "全部评论"
        dTableView.delegate = self
        dTableView.dataSource = self
    }
    
    //
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        viewModel.exComListModel.bind { (model) in
            weakSelf?.dealMyDatas(model)
        }
        
    }
    func dealMyDatas(_ model:ExComListModel) -> Void {
        //
        self.myModel = model
        self.allCommentCount = model.total
        self.picCommentCount = model.imgNum
        self.commentArray = model.list!
        
        btn_all.setTitle(String.init(format: "全部(%d)", allCommentCount ?? 0), for: .normal)
        btn_pic.setTitle(String.init(format: "有图(%d)", picCommentCount ?? 0), for: .normal)

        dTableView.reloadData()
        
    }
    
    //切换列表
    @IBAction func action_tapButton(_ sender: UIButton) {
        print(sender.tag)
        //请求数据
        viewModel.request_getExhibitionCommentList(type: sender.tag, skip: 0, take: 10, exhibitionID: self.exhibition_id!, vc: self)
    }
    
    //显示评论图片大图
    func showCommentBigImgAt(_ cellLoc: Int,_ index: Int) {
        let model = self.commentArray[cellLoc]
        
        if model.imgList != nil {
            let vc = HD_SSL_BigImageVC.init()
            vc.imageArray = model.imgList
            vc.atIndex = index
            self.present(vc, animated: true, completion: nil)
            
        }
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
extension HDSSL_commentListVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let model: ExCommentModel = self.commentArray[section]
        
        return (model.commentList?.count)! + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.commentArray[indexPath.section]
        
        if indexPath.row == 0 {
            //评论
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDSSL_dCommentCell")
            
            let comH = self.getCommentCellHeight(model)
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraints()
            
            return comH
        }
        else {
            //评论回复
            let cell = tableView.dequeueReusableCell(withIdentifier: "HDSSL_commentReplyCell")
            
            let replymodel = model.commentList![indexPath.row-1]
            let comH = self.getReplyCommentCellHeight(replymodel)
            
            cell?.setNeedsUpdateConstraints()
            cell?.updateConstraints()
            
            return comH
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = self.commentArray[indexPath.section]
        
        if indexPath.row == 0 {
            weak var weakSelf = self
            
            let cell = HDSSL_dCommentCell.getMyTableCell(tableV: tableView) as HDSSL_dCommentCell
            cell.tag = indexPath.section
            cell.selectionStyle = .none
            cell.listModel = model
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
        } else {
            let modelreply = model.commentList![indexPath.row-1]
            
            let cell = HDSSL_commentReplyCell.getMyTableCell(tableV: tableView) as HDSSL_commentReplyCell
            cell.myModel = modelreply
            cell.BlockTapLikeButtonFunc { (model) in
                //点赞回复，调用接口
                
            }
            
            return cell
        }
        
        
    }

    //获取评论cell的高度
    func getCommentCellHeight(_ model: ExCommentModel) -> CGFloat {
        let content = String.init(format: "%@", model.content!)
        
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
    func getReplyCommentCellHeight(_ model: ReplyCommentModel) -> CGFloat {
        let content = String.init(format: "%@", model.content!)
        
        //头像、间距等高度
        let otherH = 48.0 + 30.0
        //文本
        let size = content.getLabSize(font: UIFont.systemFont(ofSize: 11), width: ScreenWidth - 120)
        return size.height + CGFloat(otherH)
    }
}
