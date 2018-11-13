//
//  HDSSL_dMuseumCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dMuseumCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cell_collectImg: UIImageView!
    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_ticketPrice: UILabel!
    @IBOutlet weak var cell_address: UILabel!
    @IBOutlet weak var cell_away: UILabel!
    @IBOutlet weak var cell_tagBg: UIView!
    @IBOutlet weak var cell_liveContent: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_dMuseumCell! {
        var cell: HDSSL_dMuseumCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_dMuseumCell.className) as? HDSSL_dMuseumCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_dMuseumCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_dMuseumCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_dMuseumCell.className, owner: nil, options: nil)?.first as? HDSSL_dMuseumCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
