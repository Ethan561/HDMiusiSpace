//
//  HDSSL_MuseumCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/13.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_MuseumCell: UITableViewCell {

    @IBOutlet weak var cell_imgView: UIImageView!
    @IBOutlet weak var cell_titleLab: UILabel!
    @IBOutlet weak var cell_loacationLab: UILabel!
    @IBOutlet weak var cell_tipBgView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_MuseumCell! {
        var cell: HDSSL_MuseumCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_MuseumCell.className) as? HDSSL_MuseumCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_MuseumCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_MuseumCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_MuseumCell.className, owner: nil, options: nil)?.first as? HDSSL_MuseumCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
