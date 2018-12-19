//
//  HDZQ_MyFollowCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MyFollowCell: UITableViewCell {

    @IBOutlet weak var headerView: UIImageView!
    @IBOutlet weak var isVipView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        followBtn.layer.cornerRadius = 15
        followBtn.clipsToBounds = true
        headerView.layer.cornerRadius = 20
        headerView.clipsToBounds = true
    }
    
    func setCellWithModel(model:MyFollowModel) {
        if let img = URL.init(string: model.img) {
           headerView.kf.setImage(with: img, placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLabel.text = model.title
        desLabel.text = model.subTitle
        isVipView.isHidden = model.isVip == 0 ? true : false
    }
    
    func setCellWithModel(model:FollowPerModel) {
        if let img = URL.init(string: model.img) {
            headerView.kf.setImage(with: img, placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLabel.text = model.title
        desLabel.text = model.sub_title
        isVipView.isHidden = model.is_focus == 0 ? true : false
    }
}
