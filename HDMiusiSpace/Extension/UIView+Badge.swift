//
//  Badge.swift
//  NewMessageBadge
//
//  Created by HD-XXZQ-iMac on 2018/11/30.
//  Copyright © 2018 HD-XXZQ-iMac. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
   public func showBadge() {
        //移除之前的小红点
        self.removeBadge()
        let badgeView = UIView()
        badgeView.tag = 8888
        badgeView.layer.cornerRadius = 5
        badgeView.backgroundColor = .red
        let frame = self.frame
        badgeView.frame = CGRect.init(x: frame.size.width - 5, y: 0, width: 10, height: 10)
        self.addSubview(badgeView)
    }
    
    public func showBadge(num:Int) {
        //移除之前的小红点
        self.removeBadge()
        let str = num > 99 ? "99+" : "\(num)"
        let rect = NSString(string: str).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 15), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 10)], context: nil)
        let badgeView = UIView()
        badgeView.tag = 8888
        badgeView.layer.cornerRadius = 7.5
        badgeView.backgroundColor = .red
        let frame = self.bounds
        badgeView.frame = CGRect(x: frame.size.width - 7.5, y: -7.5, width: rect.width > 15 ? rect.width + 5 : 15 , height: 15)
        self.addSubview(badgeView)
        let numLabel = UILabel()
        numLabel.text = str
        numLabel.font = UIFont.systemFont(ofSize: 10)
        numLabel.frame = CGRect(x: 2.5, y: 0, width: rect.width, height: 15)
        numLabel.textColor = UIColor.white
        numLabel.textAlignment = .center
        numLabel.center = CGPoint(x: badgeView.frame.width * 0.5, y: 7.5)
        badgeView.addSubview(numLabel)
    }
    
    public func removeBadge() {
        self.subviews.forEach({ (subView) in
            if subView.tag == 8888 {
                subView.removeFromSuperview()
            }
        })
    }
}
