//
//  HDSSL_ClassCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_ClassCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_ClassCell! {
        var cell: HDSSL_ClassCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_ClassCell.className) as? HDSSL_ClassCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_ClassCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_ClassCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_ClassCell.className, owner: nil, options: nil)?.first as? HDSSL_ClassCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
