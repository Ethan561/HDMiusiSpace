//
//  HDSSL_recordCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/28.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_recordCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cell_titleL: UILabel!
    @IBOutlet weak var cell_timeL: UILabel!
    @IBOutlet weak var cell_priceL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_recordCell! {
        var cell: HDSSL_recordCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_recordCell.className) as? HDSSL_recordCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_recordCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_recordCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_recordCell.className, owner: nil, options: nil)?.first as? HDSSL_recordCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
