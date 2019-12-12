//
//  HDLY_MuseumInfoTitleCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumInfoTitleCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoTitleCell! {
        var cell: HDLY_MuseumInfoTitleCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoTitleCell.className) as? HDLY_MuseumInfoTitleCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoTitleCell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoTitleCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoTitleCell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoTitleCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
}
