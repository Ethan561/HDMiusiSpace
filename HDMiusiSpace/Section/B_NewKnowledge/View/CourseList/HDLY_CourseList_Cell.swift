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
    
    @IBOutlet weak var nameWidthCons: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagL.layer.cornerRadius = 4
        tagL.layer.masksToBounds = true
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            
            
        } else {
//            tipImgV.image = UIImage.init(named: "xz_daoxue_play")
//            nameL.textColor = UIColor.HexColor(0x4A4A4A)
//            timeL.textColor = UIColor.HexColor(0x9B9B9B)
        }
    }
    
    class  func getMyTableCell(tableV: UITableView, indexP: IndexPath) -> HDLY_CourseList_Cell! {
       
        let reuseIdentifier = HDLY_CourseList_Cell.className+"\(indexP.section)"+"\(indexP.row)"

        var cell: HDLY_CourseList_Cell? = tableV.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HDLY_CourseList_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseList_Cell.className, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            cell = Bundle.main.loadNibNamed(HDLY_CourseList_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseList_Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
