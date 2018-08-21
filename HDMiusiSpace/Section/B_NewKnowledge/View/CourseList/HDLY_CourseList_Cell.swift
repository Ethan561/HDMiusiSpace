//
//  HDLY_CourseList_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_Cell: UITableViewCell {

    @IBOutlet weak var tipImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var tagL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var tagTrailCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseList_Cell! {
        var cell: HDLY_CourseList_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseList_Cell.className) as? HDLY_CourseList_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseList_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseList_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseList_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseList_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
