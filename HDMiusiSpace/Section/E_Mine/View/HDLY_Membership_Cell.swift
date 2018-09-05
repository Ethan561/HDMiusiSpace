//
//  HDLY_Membership_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Membership_Cell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Membership_Cell! {
        var cell: HDLY_Membership_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_Membership_Cell.className) as? HDLY_Membership_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Membership_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_Membership_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_Membership_Cell.className, owner: nil, options: nil)?.first as? HDLY_Membership_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
}
