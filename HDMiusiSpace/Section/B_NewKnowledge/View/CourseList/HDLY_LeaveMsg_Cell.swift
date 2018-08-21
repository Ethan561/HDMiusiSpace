//
//  HDLY_LeaveMsg_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/20.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_LeaveMsg_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
