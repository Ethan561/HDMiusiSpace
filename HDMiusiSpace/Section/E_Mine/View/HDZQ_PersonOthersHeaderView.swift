//
//  HDZQ_PersonOthersHeaderView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/30.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_PersonOthersHeaderView: UIView {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followNumberL: UILabel!
    @IBOutlet weak var collectNumberL: UILabel!
    @IBOutlet weak var genderImg: UIImageView!
    @IBOutlet weak var vipImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followBtn.layer.cornerRadius = 15
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
    }
    
    @IBAction func showFollowDetailAction(_ sender: Any) {
    }
    
    @IBAction func showCollectDetailAction(_ sender: Any) {
    }
    
    @IBAction func followAction(_ sender: Any) {
    }
}
