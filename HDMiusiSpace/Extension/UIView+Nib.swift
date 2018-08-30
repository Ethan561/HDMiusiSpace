//
//  UIView+Nib.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

extension UIView {
    
    class func createViewFromNib() -> AnyObject! {
        return self.createViewFromNibName(nibName: self.className)
    }
    
    class func createViewFromNibName(nibName: String) -> AnyObject! {
        let nibArr = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        return nibArr?.first as AnyObject
    }
    
    /*
     /** Shadow properties. **/
     
     open var shadowColor: CGColor?
     
     /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
     
     open var shadowOpacity: Float
     
     
     /* The shadow offset. Defaults to (0, -3). Animatable. */
     
     open var shadowOffset: CGSize
     
     
     /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
     
     open var shadowRadius: CGFloat`</code></pre>
     
     */
    
     func configShadow(cornerRadius: CGFloat, shadowColor: UIColor, shadowOpacity:Float, shadowRadius: CGFloat ,shadowOffset:CGSize) {
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.borderColor = layer.shadowColor // 边框颜色建议和阴影颜色一致
        layer.borderWidth = 0.000001 // 只要不为0就行
        
        layer.cornerRadius = cornerRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        
    }
    
    func toFullyBottom() {
        self.bottom = superview!.bounds.size.height - CGFloat(kBottomHeight)
        self.autoresizingMask = [UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleWidth]
    }
    
    func getViewFrameToWindow() -> CGRect {
        let window = UIApplication.shared.keyWindow
        if self.superview != nil {
            return (self.convert(self.frame, to: window))
        }
        return .zero
    }
}


