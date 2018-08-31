//
//  HDFloatingButtonBgView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

typealias TouchBlock = () -> ()

class HDFloatingButtonBgView: UIView {

    var touchBlock:TouchBlock?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let viewReturn = super.hitTest(point, with: event)
        guard let tempView:UIView = viewReturn else {
            return nil
        }
        tempView.removeFromSuperview()
        if self.touchBlock != nil {
            self.touchBlock!()
        }
        
        return self.topViewController()?.view
    }
    
    
}




