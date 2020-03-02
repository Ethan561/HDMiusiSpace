//
//  RecommendSectionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/15.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class RecommendSectionCell: UITableViewCell {
    
    @IBOutlet weak var moreL: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> RecommendSectionCell! {
        var cell: RecommendSectionCell? = tableV.dequeueReusableCell(withIdentifier: RecommendSectionCell.className) as? RecommendSectionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: RecommendSectionCell.className, bundle: nil), forCellReuseIdentifier: RecommendSectionCell.className)
            cell = Bundle.main.loadNibNamed(RecommendSectionCell.className, owner: nil, options: nil)?.first as? RecommendSectionCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
