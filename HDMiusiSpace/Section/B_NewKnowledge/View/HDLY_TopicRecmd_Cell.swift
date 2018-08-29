//
//  HDLY_TopicRecmd_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_TopicRecmd_Cell: UITableViewCell {

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
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_TopicRecmd_Cell! {
        var cell: HDLY_TopicRecmd_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_TopicRecmd_Cell.className) as? HDLY_TopicRecmd_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_TopicRecmd_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_TopicRecmd_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_TopicRecmd_Cell.className, owner: nil, options: nil)?.first as? HDLY_TopicRecmd_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
