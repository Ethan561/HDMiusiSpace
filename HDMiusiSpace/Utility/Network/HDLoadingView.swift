//
//  HDLoadingView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/8.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class HDLoadingView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    
    override func awakeFromNib() {
        let aniLayer: CALayer = ReplicatorAnimation.replicatorLayer_Round()
        aniLayer.frame = CGRect.init(x: (contentView.width-50)/2, y: (contentView.height-50)/2.0, width: 50, height: 50)
        contentView.layer.addSublayer(aniLayer)
        
        contentView.configShadow(cornerRadius: 8, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.zero)
        
    }

}



