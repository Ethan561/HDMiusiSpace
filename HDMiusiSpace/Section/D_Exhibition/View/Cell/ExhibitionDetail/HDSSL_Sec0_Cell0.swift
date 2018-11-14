//
//  HDSSL_Sec0_Cell1.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_Sec0_Cell0: UITableViewCell {

    @IBOutlet weak var cell_titleL: UILabel!
    @IBOutlet weak var cell_starNumL: UILabel!
    @IBOutlet weak var cell_star1: UIImageView!
    @IBOutlet weak var cell_star2: UIImageView!
    @IBOutlet weak var cell_star3: UIImageView!
    @IBOutlet weak var cell_star4: UIImageView!
    @IBOutlet weak var cell_star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec0_Cell0! {
        var cell: HDSSL_Sec0_Cell0? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec0_Cell0.className) as? HDSSL_Sec0_Cell0
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec0_Cell0.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec0_Cell0.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec0_Cell0.className, owner: nil, options: nil)?.first as? HDSSL_Sec0_Cell0
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
