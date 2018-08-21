//
//  HDLY_BuyNote_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_BuyNote_Cell: UITableViewCell {

    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_BuyNote_Cell! {
        var cell: HDLY_BuyNote_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_BuyNote_Cell.className) as? HDLY_BuyNote_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_BuyNote_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_BuyNote_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_BuyNote_Cell.className, owner: nil, options: nil)?.first as? HDLY_BuyNote_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
