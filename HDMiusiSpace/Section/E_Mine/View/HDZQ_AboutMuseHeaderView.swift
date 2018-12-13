//
//  HDZQ_AboutMuseHeaderView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_AboutMuseHeaderView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var versionLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        versionLabel.layer.cornerRadius = 13.0
        versionLabel.clipsToBounds = true
    }

}
