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
typealias BlockTapImgAt = (_ index: Int) -> Void //点击图片，返回点击位置
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
    
    func loadMyView(){
        cell_portrial.layer.cornerRadius = 15.0
        cell_portrial.layer.masksToBounds = true
    }
    
    func initDataWith(_ model: CommentListModel) -> Void {
        //头像
        cell_portrial.kf.setImage(with: URL.init(string: String.init(format: "%@", model.avatar)), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        //名字
        cell_userName.text = String.init(format: "%@", model.nickname)
        //星级数量
        self.getStarView(model.star)
        //评论内容
        cell_content.text = String.init(format: "%@", model.content)
        //评论图片
        self.getImgListView(model.imgList)
        //时间
        cell_time.text = String.init(format: "%@", model.commentDate)
        //点赞数量
        cell_btnLike.setTitle(String.init(format: "%d", model.likeNum), for: .normal)
        //评论数量
        cell_btnComment.setTitle(String.init(format: "%d", model.commentNum), for: .normal)
    }

    @IBAction func action_tapLikeBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected;
        
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
    func getStarView(_ starNum: Float) {
        let starArray = [cell_start1,cell_start2,cell_start3,cell_start4,cell_start5]
        
        let maxNum:Int = Int(floor(starNum))//向下取整
        
        if maxNum == 0 {
            return
        }else {
            //red
            for i in 0...maxNum {
                let imgV = starArray[i]
                imgV!.image = UIImage.init(named: "zl_icon_star_red")
            }
            //half
            if floor(starNum) != starNum {
                let imgV = starArray[maxNum+1]
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
            
            let tapGes: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: Selector(("tapAction:")))
            tapGes.numberOfTapsRequired = 1
            imgView.addGestureRecognizer(tapGes)
            
            cell_imgBg.addSubview(imgView)
        }
    }
    //点击图片
    func tapAction(_ ges:UITapGestureRecognizer){
        print(ges.view!.tag)
        weak var weakSelf = self
        if weakSelf?.blockTapImg != nil {
            weakSelf?.blockTapImg!(ges.view!.tag)
        }
    }
}
