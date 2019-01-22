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
        let aniLayerW:CGFloat = 24
        aniLayer.frame = CGRect.init(x: (contentView.width - aniLayerW)/2, y: (contentView.height - aniLayerW)/2.0, width: aniLayerW, height: aniLayerW)
        contentView.layer.addSublayer(aniLayer)
        
        contentView.configShadow(cornerRadius: 20, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        contentView.backgroundColor = UIColor.HexColor(0xCECECE)
        
    }

}



