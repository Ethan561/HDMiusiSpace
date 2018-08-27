//
//  HDLY_CourseWeb_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseWeb_Cell: UITableViewCell {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        webView.scrollView.isScrollEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseWeb_Cell! {
        var cell: HDLY_CourseWeb_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseWeb_Cell.className) as? HDLY_CourseWeb_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseWeb_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseWeb_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseWeb_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseWeb_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
