//
//  HDLY_CourseTitle_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseTitle_Cell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var desL: UILabel!
    @IBOutlet weak var focusBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseTitle_Cell! {
        var cell: HDLY_CourseTitle_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseTitle_Cell.className) as? HDLY_CourseTitle_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseTitle_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseTitle_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseTitle_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseTitle_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
}
