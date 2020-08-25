//
//  HDMyGamePrizeCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2020/8/7.
//  Copyright © 2020 hengdawb. All rights reserved.
//

import UIKit

class HDMyGamePrizeCell: UITableViewCell {

    @IBOutlet weak var orderSnLabel: UILabel!
    @IBOutlet weak var positionL: UILabel!
    @IBOutlet weak var poiL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var getPrizeTimeL: UILabel!
    @IBOutlet weak var gettingStatusL: UILabel!
    @IBOutlet weak var gotPrizeImgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        gettingStatusL.layer.cornerRadius = 10.0
        gettingStatusL.layer.masksToBounds =  true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
 
