//
//  HDLY_Kids_Cell2.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Kids_Cell2: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Kids_Cell2! {
        var cell: HDLY_Kids_Cell2? = tableV.dequeueReusableCell(withIdentifier: HDLY_Kids_Cell2.className) as? HDLY_Kids_Cell2
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Kids_Cell2.className, bundle: nil), forCellReuseIdentifier: HDLY_Kids_Cell2.className)
            cell = Bundle.main.loadNibNamed(HDLY_Kids_Cell2.className, owner: nil, options: nil)?.first as? HDLY_Kids_Cell2
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
