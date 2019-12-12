//
//  HDSSL_Sec0_cellNormal.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_Sec0_cellNormal: UITableViewCell {
    @IBOutlet weak var cell_nameL: UILabel!
    @IBOutlet weak var cell_titleL: UILabel!
    @IBOutlet weak var cell_indicator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec0_cellNormal! {
        var cell: HDSSL_Sec0_cellNormal? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec0_cellNormal.className) as? HDSSL_Sec0_cellNormal
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec0_cellNormal.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec0_cellNormal.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec0_cellNormal.className, owner: nil, options: nil)?.first as? HDSSL_Sec0_cellNormal
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
}
