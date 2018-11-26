//
//  HDZQ_RelatedClassCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_RelatedClassCell: UICollectionViewCell {

    @IBOutlet weak var exhibitImageView: UIImageView!
    @IBOutlet weak var exhibitTitleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        exhibitImageView.layer.cornerRadius = 10
        exhibitImageView.clipsToBounds = true
    }

}
