//
//  HDLY_dExMusSectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2019/4/3.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

class HDLY_dExMusSectionCell: UITableViewCell {

    @IBOutlet weak var subNameL: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var disL: UILabel!
    @IBOutlet weak var tudingImgV: UIImageView!
    @IBOutlet weak var titleBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        disL.layer.masksToBounds = true
//        disL.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_dExMusSectionCell! {
        var cell: HDLY_dExMusSectionCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_dExMusSectionCell.className) as? HDLY_dExMusSectionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_dExMusSectionCell.className, bundle: nil), forCellReuseIdentifier: HDLY_dExMusSectionCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_dExMusSectionCell.className, owner: nil, options: nil)?.first as? HDLY_dExMusSectionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
