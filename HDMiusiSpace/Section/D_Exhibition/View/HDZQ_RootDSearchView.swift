//
//  HDZQ_RootDSearchView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2019/1/24.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_RootDSearchView: UIView {
    @IBOutlet weak var voiceSearchBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var placeholderLab: UILabel!
    @IBOutlet weak var searchBgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        searchBgView.layer.cornerRadius = 10
        searchBgView.layer.masksToBounds = true
    }
}
