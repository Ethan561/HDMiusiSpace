//
//  HDZQ_FPExhibitPlayCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/1.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit



class HDZQ_FPExhibitPlayCell: UITableViewCell {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var exhibitLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 22.0
        containerView.clipsToBounds = true
    }

    @IBAction func playOrPauseAction(_ sender: Any) {
//        playBtn.isSelected = !playBtn.isSelected
        
    }
    
}
