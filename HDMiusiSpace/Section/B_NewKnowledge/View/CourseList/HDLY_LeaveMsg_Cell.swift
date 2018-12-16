//
//  HDLY_LeaveMsg_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

typealias LongPressActionClouser = (_ type: Int)->Void

class HDLY_LeaveMsg_Cell: UITableViewCell {
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    public var commentId = 0
    public var longPress: LongPressActionClouser!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarBtn.layer.cornerRadius = 15
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(alertAction(ges:)))
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
        
    }

   
    @objc func alertAction(ges:UILongPressGestureRecognizer) {
        if ges.state == .began {
//            UIImpactFeedbackGenerator*impactLight = [[UIImpactFeedbackGeneratoralloc]initWithStyle:UIImpactFeedbackStyleLight];
//            [impactLight impactOccurred];
        
            if #available(iOS 10.0, *) {
                let impactLight = UIImpactFeedbackGenerator.init(style: .medium)
                 impactLight.impactOccurred()
            } else {
                // Fallback on earlier versions
            }
           
            if self.longPress != nil {
                self.longPress(commentId)
            }
        }
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_LeaveMsg_Cell! {
        var cell: HDLY_LeaveMsg_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_LeaveMsg_Cell.className) as? HDLY_LeaveMsg_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_LeaveMsg_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_LeaveMsg_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_LeaveMsg_Cell.className, owner: nil, options: nil)?.first as? HDLY_LeaveMsg_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
