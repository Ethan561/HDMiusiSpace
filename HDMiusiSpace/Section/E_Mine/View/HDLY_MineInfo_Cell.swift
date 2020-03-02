//
//  HDLY_MineInfo_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MineInfo_Cell: UITableViewCell {
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var subNameL: UILabel!
    
    @IBOutlet weak var subNameLTrainingCons: NSLayoutConstraint!
    @IBOutlet weak var moreImgV: UIImageView!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MineInfo_Cell! {
        var cell: HDLY_MineInfo_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MineInfo_Cell.className) as? HDLY_MineInfo_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MineInfo_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MineInfo_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MineInfo_Cell.className, owner: nil, options: nil)?.first as? HDLY_MineInfo_Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell!
    }
    
}
