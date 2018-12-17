//
//  HDZQ_UpdateAlertView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_UpdateAlertView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var contentCiew: UITextView!
    @IBOutlet weak var updateBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10.0
        updateBtn.layer.cornerRadius = 20.0
        containerView.clipsToBounds = true
        updateBtn.clipsToBounds = true
    }

    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
}
