//
//  HDSSL_newsCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_newsCell: UITableViewCell {
    @IBOutlet weak var cell_imgView: UIImageView!
    @IBOutlet weak var cell_titleLab: UILabel!
    @IBOutlet weak var cell_tipsLab: UILabel!
    @IBOutlet weak var cell_commentBtn: UIButton!
    @IBOutlet weak var cell_likeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_newsCell! {
        var cell: HDSSL_newsCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_newsCell.className) as? HDSSL_newsCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_newsCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_newsCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_newsCell.className, owner: nil, options: nil)?.first as? HDSSL_newsCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
