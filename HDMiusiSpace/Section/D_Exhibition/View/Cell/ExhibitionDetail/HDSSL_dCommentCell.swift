//
//  HDSSL_dCommentCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/16.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

let kItemSpace: CGFloat = 10.0
let kItemWidth: CGFloat = CGFloat((UIScreen.main.bounds.width-55-20)/3.0)

//block
typealias BlockTapImgAt = (_ index: Int,_ cellIndex: Int) -> Void //点击图片，返回点击位置
typealias BlockTapLikeBtn = (_ index: Int) -> Void //点击点赞，返回点击位置
typealias BlockTapCommentBtn = (_ index: Int) -> Void //点击评论，返回点击位置

class HDSSL_dCommentCell: UITableViewCell {

    @IBOutlet weak var cell_portrial: UIImageView! //头像
    @IBOutlet weak var cell_userName: UILabel!//昵称
    @IBOutlet weak var cell_content : UILabel!
    @IBOutlet weak var cell_time    : UILabel!
    
    @IBOutlet weak var cell_start1: UIImageView!
    @IBOutlet weak var cell_start2: UIImageView!
    @IBOutlet weak var cell_start3: UIImageView!
    @IBOutlet weak var cell_start4: UIImageView!
    @IBOutlet weak var cell_start5: UIImageView!
    
    @IBOutlet weak var cell_imgBg: UIView!
    @IBOutlet weak var cell_btnLike   : UIButton!
    @IBOutlet weak var cell_btnComment: UIButton!
    
    //
    var myModel: CommentListModel? {
        didSet{
            setMyModel()
        }
    }
    
    var listModel: ExCommentModel? {
        didSet{
            setListModel()
        }
    }
    
    var blockTapImg : BlockTapImgAt?
    var blockTapLike : BlockTapLikeBtn?
    var blockTapComment : BlockTapCommentBtn?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadMyView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_dCommentCell! {
        var cell: HDSSL_dCommentCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_dCommentCell.className) as? HDSSL_dCommentCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_dCommentCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_dCommentCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_dCommentCell.className, owner: nil, options: nil)?.first as? HDSSL_dCommentCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    func loadMyView(){
        cell_portrial.layer.cornerRadius = 15.0
        cell_portrial.layer.masksToBounds = true
    }
    //展览评论列表数据cell
    func setListModel() -> Void {
        guard listModel != nil else {
            return
        }
        //头像
        cell_portrial.kf.setImage(with: URL.init(string: String.init(format: "%@", listModel!.avatar!)), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        //名字
        cell_userName.text = String.init(format: "%@", listModel!.nickname!)
        //星级数量
        self.getStarView(listModel?.star)
        //评论内容
        cell_content.text = String.init(format: "%@", listModel!.content!)
        //评论图片
        self.getImgListView(listModel!.imgList)
        //时间
        cell_time.text = String.init(format: "%@", listModel!.commentDate!)
        //点赞数量
        cell_btnLike.setTitle(String.init(format: "%d", listModel!.likeNum!), for: .normal)
        if listModel?.isLike == 1 {
            cell_btnLike.isSelected = true
        }else{
            cell_btnLike.isSelected = false
        }
        //评论数量
        cell_btnComment.setTitle(String.init(format: "%d", listModel!.commentNum!), for: .normal)
    }
    
    //展览详情评论cell
    func setMyModel() -> Void {
        guard myModel != nil else {
            return
        }
        //头像
        cell_portrial.kf.setImage(with: URL.init(string: String.init(format: "%@", myModel!.avatar)), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        //名字
        cell_userName.text = String.init(format: "%@", myModel!.nickname)
        //星级数量
        self.getStarView(Int(myModel!.star))
        //评论内容
        cell_content.text = String.init(format: "%@", myModel!.content)
        //评论图片
        self.getImgListView(myModel!.imgList)
        //时间
        cell_time.text = String.init(format: "%@", myModel!.commentDate)
        //点赞数量
        cell_btnLike.setTitle(String.init(format: "%d", myModel!.likeNum), for: .normal)
        if myModel?.isLike == 1 {
            cell_btnLike.isSelected = true
        }else{
            cell_btnLike.isSelected = false
        }
        //评论数量
        cell_btnComment.setTitle(String.init(format: "%d", myModel!.commentNum), for: .normal)
    }

    @IBAction func action_tapLikeBtn(_ sender: UIButton) {
        
//        sender.isSelected = !sender.isSelected;
        
        weak var weakSelf = self
        if weakSelf?.blockTapLike != nil {
            weakSelf?.blockTapLike!(self.tag)
        }
    }
    @IBAction func action_tapCommentBtn(_ sender: UIButton) {
        weak var weakSelf = self
        if weakSelf?.blockTapComment != nil {
            weakSelf?.blockTapComment!(self.tag)
        }
    }
    
    
    //点击图片，放大
    func BlockTapImgItemFunc(block: @escaping BlockTapImgAt) {
        blockTapImg = block
    }
    //点赞
    func BlockTapLikeFunc(block: @escaping BlockTapLikeBtn) {
        blockTapLike = block
    }
    //评论
    func BlockTapCommentFunc(block: @escaping BlockTapCommentBtn) {
        blockTapComment = block
    }
}
extension HDSSL_dCommentCell{
    //star
    func getStarView(_ starNum: Int?) {
        
        if starNum == nil {
            return
        }
        
        let starArray = [cell_start1,cell_start2,cell_start3,cell_start4,cell_start5]
        
        let maxNum:Int = starNum! / 2  //向下取整
        
        if maxNum == 0 {
            return
        }else if starNum == 1{
            let imgV = starArray[0]
            imgV!.image = UIImage.init(named: "zl_icon_star_half")
        }
        else {
            //red
            for i in 0..<maxNum {
                let imgV = starArray[i]
                imgV!.image = UIImage.init(named: "zl_icon_star_red")
            }
            //half
            if maxNum * 2 != starNum {
                let imgV = starArray[maxNum]
                imgV!.image = UIImage.init(named: "zl_icon_star_half")
            }
        }
        
    }
    //img list
    func getImgListView(_ imgs:[String]?) {
        if imgs?.count == 0 {
            return
        }
        for i in 0..<imgs!.count {
            let imgPath = imgs![i]
            
            let imgView = UIImageView.init(frame: CGRect.init(x: (kItemSpace + kItemWidth) * CGFloat(i % 3), y: (kItemSpace + kItemWidth) * CGFloat(i / 3), width: kItemWidth, height: kItemWidth))
            
            imgView.kf.setImage(with: URL.init(string: String.init(format: "%@", imgPath)), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
            
            imgView.tag = i
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.isUserInteractionEnabled = true
            
            let tapGes: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_:)))
            tapGes.numberOfTapsRequired = 1
            imgView.addGestureRecognizer(tapGes)
            
            cell_imgBg.addSubview(imgView)
        }
    }
    //点击图片
    @objc func tapAction(_ ges:UITapGestureRecognizer){
        print(ges.view!.tag)
        weak var weakSelf = self
        if weakSelf?.blockTapImg != nil {
            weakSelf?.blockTapImg!(ges.view!.tag, self.tag)
        }
    }
}
