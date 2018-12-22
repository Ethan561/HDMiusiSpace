//
//  HDZQ_MoreCommentsCell.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_MoreCommentsCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!
    public var longPress: LongPressActionClouser!
    public var tapPress: TapActionClouser!
    public var commentId = 0
    public var commentContent : String?
    override func awakeFromNib() {
        super.awakeFromNib()
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(alertAction(ges:)))
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
    }

    @objc func alertAction(ges:UILongPressGestureRecognizer) {
        if ges.state == .began {
            if #available(iOS 10.0, *) {
                let impactLight = UIImpactFeedbackGenerator.init(style: .medium)
                impactLight.impactOccurred()
            }
            if self.longPress != nil {
                self.longPress(commentId,commentContent ?? "")
            }
        }
    }
    
}
