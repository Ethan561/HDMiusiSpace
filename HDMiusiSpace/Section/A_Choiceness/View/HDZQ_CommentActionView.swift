//
//  HDZQ_CommentActionView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/15.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

protocol HDZQ_CommentActionDelegate : NSObjectProtocol {
    func commentActionSelected(type:Int,index:Int,model:TopicCommentList,reportType:Int?)
}


class HDZQ_CommentActionView: UIView {    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    public var type = 0
    public var dataArr = [String]()
    public var reportType = [Int]()
    public weak var delegate:HDZQ_CommentActionDelegate?
    public var model : TopicCommentList?
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.layer.cornerRadius = 2.0
        tableView.register(UINib.init(nibName: "HDZQ_CommentActionCell", bundle: nil), forCellReuseIdentifier: "HDZQ_CommentActionCell")
        tableView.rowHeight = 50
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(removeAction))
        containerView.addGestureRecognizer(tap)
        tableHeightConstraint.constant = CGFloat(50 * dataArr.count)
    }
    
    
    @objc func removeAction() {
        self.removeFromSuperview()
    }
}

extension HDZQ_CommentActionView:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_CommentActionCell") as? HDZQ_CommentActionCell
        cell?.commentTitleLabel.text = title
        return cell!
    }
    
    
}

extension HDZQ_CommentActionView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            if type == 1 {
                delegate?.commentActionSelected(type: type, index: indexPath.row,model: model!,reportType:reportType[indexPath.row])
            } else {
                delegate?.commentActionSelected(type: type, index: indexPath.row,model: model!,reportType:nil)
            }
            
        }
    }
}
