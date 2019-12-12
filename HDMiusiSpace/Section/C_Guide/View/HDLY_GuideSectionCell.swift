//
//  HDLY_GuideSectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/5.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_GuideSectionCell: UITableViewCell {

    @IBOutlet weak var subNameL: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var disL: UILabel!
    @IBOutlet weak var tudingImgV: UIImageView!
    @IBOutlet weak var titleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        disL.layer.masksToBounds = true
        disL.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_GuideSectionCell! {
        var cell: HDLY_GuideSectionCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_GuideSectionCell.className) as? HDLY_GuideSectionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_GuideSectionCell.className, bundle: nil), forCellReuseIdentifier: HDLY_GuideSectionCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_GuideSectionCell.className, owner: nil, options: nil)?.first as? HDLY_GuideSectionCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    
}
