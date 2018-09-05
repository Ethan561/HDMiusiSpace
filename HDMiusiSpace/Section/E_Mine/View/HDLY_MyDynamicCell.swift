//
//  HDLY_MyDynamicCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MyDynamicCell: UITableViewCell {

    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImgV.layer.cornerRadius = 15
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MyDynamicCell! {
        var cell: HDLY_MyDynamicCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MyDynamicCell.className) as? HDLY_MyDynamicCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MyDynamicCell.className, bundle: nil), forCellReuseIdentifier: HDLY_MyDynamicCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MyDynamicCell.className, owner: nil, options: nil)?.first as? HDLY_MyDynamicCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
}
