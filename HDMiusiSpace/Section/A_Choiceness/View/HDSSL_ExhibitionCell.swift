//
//  HDSSL_ExhibitionCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_ExhibitionCell: UITableViewCell {

    @IBOutlet weak var cell_imgView: UIImageView!
    @IBOutlet weak var cell_titleLab: UILabel!
    @IBOutlet weak var cell_locationLab: UILabel!
    @IBOutlet weak var cell_tipBgView: UIView!
    @IBOutlet weak var cell_starImgView: UIImageView!
    @IBOutlet weak var cell_scoreLab: UILabel!
    
    @IBOutlet weak var noStarL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_ExhibitionCell! {
        var cell: HDSSL_ExhibitionCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_ExhibitionCell.className) as? HDSSL_ExhibitionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_ExhibitionCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_ExhibitionCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_ExhibitionCell.className, owner: nil, options: nil)?.first as? HDSSL_ExhibitionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
