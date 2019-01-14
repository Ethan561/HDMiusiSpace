//
//  HDLY_MyDynamicCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

protocol HDLY_MyDynamicCellDelegate:NSObjectProtocol {
    func pushToDetailArticle(cateId:Int, detailId: Int)
    func deleteCommentId(commentId: Int,index:Int)
}

class HDLY_MyDynamicCell: UITableViewCell {

    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var deletaBtn: UIButton!
    //
    @IBOutlet weak var exhibitionView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var locL: UILabel!
    @IBOutlet weak var desView: UIView!
    @IBOutlet weak var des1L: UILabel!
    @IBOutlet weak var des2L: UILabel!
    
    @IBOutlet weak var titleLTopCons: NSLayoutConstraint!
    @IBOutlet weak var moreBtn: UIButton!
    
    private var isShowing = false
    
    // 这个评论的id
    public var commentId = 0
    // 这个评论相关的类型ID
    public var cateID = 0
    // 这个类型的具体文章详情ID
    public var detailId = 0
    // 这个cell的Index
    public var index = 0
    
    weak var delegate: HDLY_MyDynamicCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avaImgV.layer.cornerRadius = 15
        exhibitionView.layer.cornerRadius = 4.0
        imgV.layer.cornerRadius = 2.0
        imgV.clipsToBounds = true
        titleLTopCons.constant = 16
        desView.isHidden = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(pushToDetail))
        exhibitionView.addGestureRecognizer(tap)
        deletaBtn.isHidden = true
        deletaBtn.layer.shadowColor = UIColor.black.cgColor
        deletaBtn.layer.shadowOpacity = 0.3
        deletaBtn.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveDeleteClickedNotification(noti:)), name: NSNotification.Name.init(rawValue: "DynamicListDeleteComent"), object: nil)
    }
    
    @IBAction func showDeleteView(_ sender: UIButton) {
        self.contentView.bringSubview(toFront: deletaBtn)
        postDeleteButtonClickedNotification()
        if deletaBtn.isHidden == false {
            deletaBtn.isHidden = true
            return
        }
        deletaBtn.isHidden = isShowing
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        if delegate != nil {
            delegate?.deleteCommentId(commentId: commentId,index:index)
        }
    }
    @objc func pushToDetail() {
        if delegate != nil {
            delegate?.pushToDetailArticle(cateId: cateID, detailId: detailId)
        }
    }
    
    @objc func receiveDeleteClickedNotification(noti:Notification) {
        let btn = noti.object as! UIButton
        if btn != deletaBtn && !isShowing {
            deletaBtn.isHidden = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        postDeleteButtonClickedNotification()
        if !isShowing {
            deletaBtn.isHidden = true
        }
    }
    
    func postDeleteButtonClickedNotification() {
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "DynamicListDeleteComent"), object: deletaBtn)
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MyDynamicCell! {
        var cell: HDLY_MyDynamicCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MyDynamicCell.className) as? HDLY_MyDynamicCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MyDynamicCell.className, bundle: nil), forCellReuseIdentifier: HDLY_MyDynamicCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MyDynamicCell.className, owner: nil, options: nil)?.first as? HDLY_MyDynamicCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
}
