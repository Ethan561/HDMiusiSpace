//
//  HDSSL_Sec0_Cell1.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

let CGFLOAT_MAX : CGFloat = 100.0

class HDSSL_Sec0_Cell1: UITableViewCell {

    @IBOutlet weak var cell_timeL: UITextView!

    @IBOutlet weak var nameL: UILabel!
    var tableView: UITableView! {
        
        var tableView: UIView? = superview
        while !(tableView is UITableView) && tableView != nil {
            tableView = tableView?.superview
        }
        return tableView as? UITableView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec0_Cell1! {
        var cell: HDSSL_Sec0_Cell1? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec0_Cell1.className) as? HDSSL_Sec0_Cell1
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec0_Cell1.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec0_Cell1.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec0_Cell1.className, owner: nil, options: nil)?.first as? HDSSL_Sec0_Cell1
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}

