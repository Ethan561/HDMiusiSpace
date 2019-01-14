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
        aniLayer.frame = CGRect.init(x: (contentView.width-40)/2, y: (contentView.height-40)/2.0, width: 40, height: 40)
        contentView.layer.addSublayer(aniLayer)
        
        contentView.configShadow(cornerRadius: 8, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 10, shadowOffset: CGSize.zero)
        contentView.backgroundColor = UIColor.HexColor(0xCECECE)
        
    }

}



