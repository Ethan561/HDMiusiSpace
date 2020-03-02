//
//  HDLY_StrategyListCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/19.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_StrategyListCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var desL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_StrategyListCell! {
        var cell: HDLY_StrategyListCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_StrategyListCell.className) as? HDLY_StrategyListCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_StrategyListCell.className, bundle: nil), forCellReuseIdentifier: HDLY_StrategyListCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_StrategyListCell.className, owner: nil, options: nil)?.first as? HDLY_StrategyListCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}

