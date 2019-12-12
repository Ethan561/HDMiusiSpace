//
//  HDLY_CourseComment_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseComment_Cell: UITableViewCell {

    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImgV.layer.cornerRadius = 20
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseComment_Cell! {
        var cell: HDLY_CourseComment_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseComment_Cell.className) as? HDLY_CourseComment_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseComment_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseComment_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseComment_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseComment_Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
}
