//
//  HDLY_LeaveMsg_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

typealias LongPressActionClouser = (_ type: Int,_ comment:String)->Void
typealias TapActionClouser = (_ type: Int)->Void
typealias AnswerActionClouser = (_ commentId: Int,_ nickname: String )->Void
class HDLY_LeaveMsg_Cell: UITableViewCell {
    
    @IBOutlet weak var longPressView: UIView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var subContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var showMoreBtn: UIButton!
    private var subCommentsList: [TopicSecdCommentList]?
    public var htmls: [NSAttributedString]?
    public var commentId = 0
    public var commentContent : String?
    public var uid = 0
    public var longPress: LongPressActionClouser!
    public var tapPress: TapActionClouser!
    public var answer: AnswerActionClouser!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarBtn.layer.cornerRadius = 15
        avatarBtn.layer.masksToBounds = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(alertAction(ges:)))
        longPress.minimumPressDuration = 0.5
        self.longPressView.addGestureRecognizer(longPress)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(ges:)))
        self.longPressView.addGestureRecognizer(tap)
        tableView.register(UINib.init(nibName: "HDZQ_MoreCommentsCell", bundle: nil), forCellReuseIdentifier: "HDZQ_MoreCommentsCell")
        tableView.isScrollEnabled = false
        tableView.bounces = false
        subContainerView.isHidden = true
    }

   
    @objc func alertAction(ges:UILongPressGestureRecognizer) {
        if ges.state == .began {
            if #available(iOS 10.0, *) {
                let impactLight = UIImpactFeedbackGenerator.init(style: .medium)
                 impactLight.impactOccurred()
            }
            if self.longPress != nil {
                self.longPress(commentId,self.commentContent ?? "")
            }
        }
    }
    
    @objc func tapAction(ges:UITapGestureRecognizer) {
        if self.tapPress != nil {
            self.tapPress(commentId)
        }
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_LeaveMsg_Cell! {
        var cell: HDLY_LeaveMsg_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_LeaveMsg_Cell.className) as? HDLY_LeaveMsg_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_LeaveMsg_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_LeaveMsg_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_LeaveMsg_Cell.className, owner: nil, options: nil)?.first as? HDLY_LeaveMsg_Cell
        }
//        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func setupSubContainerView(subModel:TopicCommentList, showAll:Bool) {
        self.subCommentsList = subModel.list
        if  self.subCommentsList!.count > 2 {
            if showAll {
                showMoreBtn.isHidden = true
                tableViewHeightConstraint.constant =  CGFloat(subModel.height + 20)
            } else {
                showMoreBtn.isHidden = false
                tableViewHeightConstraint.constant =  CGFloat(subModel.topHeight)
                showMoreBtn.setTitle("查看全部件\( self.subCommentsList!.count)条回复", for: .normal)
            }
        } else {
            showMoreBtn.isHidden = true
            tableViewHeightConstraint.constant = CGFloat(subModel.height + 20)
        }
        tableView.isScrollEnabled = false
        tableView.reloadData()
    }
    
}

extension HDLY_LeaveMsg_Cell : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCommentsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.isScrollEnabled = false
        let model = self.subCommentsList![indexPath.row]
        let attStr = self.htmls![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_MoreCommentsCell") as! HDZQ_MoreCommentsCell
        cell.commentId = model.commentID
        cell.commentContent = model.comment
        cell.commentLabel.attributedText = attStr
        cell.longPress = { [weak self] (commentId, comment) in
            if self?.longPress != nil {
                self?.longPress(commentId,comment)
            }
        }
        return cell
    }
}

extension HDLY_LeaveMsg_Cell : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.subCommentsList![indexPath.row]
        return CGFloat(model.height)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.subCommentsList![indexPath.row]
        if self.answer != nil {
            self.answer(model.commentID,model.uNickname)
        }
    }
}
