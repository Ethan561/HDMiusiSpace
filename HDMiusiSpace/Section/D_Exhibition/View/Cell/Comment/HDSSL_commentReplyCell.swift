//
//  HDSSL_commentReplyCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias BlockTapLikeButton = (_ model:ReplyCommentModel,_ indexpath: IndexPath) -> Void //点赞
//手势
typealias LongPressReplyClouser = (_ type: Int,_ comment:String)->Void //长按文本手势
typealias TapReplyClouser = (_ type: Int)->Void //点击文本手势

class HDSSL_commentReplyCell: UITableViewCell {

    @IBOutlet weak var cell_portrialBtn: UIButton!
    @IBOutlet weak var cell_portrial: UIImageView!
    @IBOutlet weak var cell_usreName: UILabel!
    @IBOutlet weak var cell_content: UILabel!
    @IBOutlet weak var cell_date: UILabel!
    @IBOutlet weak var btn_like: UIButton!
    
    var indexpath: IndexPath? //对象指纹
    
    var blockTapLikeButton: BlockTapLikeButton?
    public var longPress: LongPressReplyClouser!
    public var tapPress: TapReplyClouser!
    
    func BlockTapLikeButtonFunc(block :@escaping BlockTapLikeButton) {
        blockTapLikeButton = block
    }
    
    var myModel: ReplyCommentModel?{
        didSet{
            reloadCellView()
        }
    }
    
    func reloadCellView(){
        cell_portrial.kf.setImage(with: URL.init(string: String.init(format: "%@", (myModel?.avatar)!)), placeholder: UIImage.init(named: "wd_img_tx"), options: nil, progressBlock: nil, completionHandler: nil)
        cell_usreName.text = String.init(format: "%@", (myModel?.nickname)!)
        cell_content.text = String.init(format: "%@", (myModel?.content)!)
        cell_date.text = String.init(format: "%@", (myModel?.commentDate)!)
        btn_like.setTitle(String.init(format: "%d", (myModel?.likeNum!.int)! ?? 0), for: .normal)
        if myModel?.isLike == 1 {
            btn_like.isSelected = true
        }else{
            btn_like.isSelected = false
        }
        //长按
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(alertAction(ges:)))
        longPress.minimumPressDuration = 0.5
        self.contentView.addGestureRecognizer(longPress)
        //点击
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(ges:)))
        self.contentView.addGestureRecognizer(tap)
    }
    //MARK:---评论列表手势
    @objc func alertAction(ges:UILongPressGestureRecognizer) {
        if ges.state == .began {
            if #available(iOS 10.0, *) {
                let impactLight = UIImpactFeedbackGenerator.init(style: .medium)
                impactLight.impactOccurred()
            }
            if self.longPress != nil {
                self.longPress((myModel?.returnId)!,myModel?.content ?? "")
            }
        }
    }
    @objc func tapAction(ges:UITapGestureRecognizer) {
        if self.tapPress != nil {
            self.tapPress((myModel?.returnId)!)
        }
    }
    //点赞评论回复
    @IBAction func action_tapLike(_ sender: UIButton) {
        
//        sender.isSelected = !sender.isSelected
        
        weak var weakself = self
        if weakself?.blockTapLikeButton != nil {
            weakself?.blockTapLikeButton!(myModel!,indexpath!)
        }
    }
    @IBAction func action_tapPortrial(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_portrial.layer.cornerRadius = 15.0
        cell_portrial.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_commentReplyCell! {
        var cell: HDSSL_commentReplyCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_commentReplyCell.className) as? HDSSL_commentReplyCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_commentReplyCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_commentReplyCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_commentReplyCell.className, owner: nil, options: nil)?.first as? HDSSL_commentReplyCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
