//
//  HDLY_CourseTeacher_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseTeacher_Cell: UITableViewCell {
    
    @IBOutlet weak var avatarImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var desL: UILabel!
    @IBOutlet weak var introduceL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImgV.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseTeacher_Cell! {
        var cell: HDLY_CourseTeacher_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseTeacher_Cell.className) as? HDLY_CourseTeacher_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseTeacher_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseTeacher_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseTeacher_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseTeacher_Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
