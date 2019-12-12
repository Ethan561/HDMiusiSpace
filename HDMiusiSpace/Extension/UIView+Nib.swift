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
    
    //实现半边圆角或部分圆角
    /**
     *  设置部分圆角(绝对布局)
     *
     *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
     *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
     */
    
    func addRoundedCorners(corners: UIRectCorner, radii: CGSize) {
        let rounded:UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii)
        let shape: CAShapeLayer = CAShapeLayer.init()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    func addRoundedCorners(corners: UIRectCorner, radii: CGSize, viewRect:CGRect) {
        let rounded:UIBezierPath = UIBezierPath.init(roundedRect: viewRect, byRoundingCorners: corners, cornerRadii: radii)
        let shape: CAShapeLayer = CAShapeLayer.init()
        shape.path = rounded.cgPath
        self.layer.mask = shape
    }
    
    
    func toFullyBottom() {
        self.bottom = superview!.bounds.size.height - CGFloat(kBottomHeight)
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleWidth]
    }
    
    func getViewFrameToWindow() -> CGRect {
        let window = UIApplication.shared.keyWindow
        if self.superview != nil {
            return (self.convert(self.frame, to: window))
        }
        return .zero
    }
    
     func hdtopViewController() -> UIViewController? {
        guard let rootVc = UIApplication.shared.delegate?.window??.rootViewController else {
            return nil
        }
        
        var resultVC: UIViewController? = self.hdcurrentViewController(rootVC: rootVc)
        while ((resultVC?.presentedViewController) != nil) {
            resultVC = self.hdcurrentViewController(rootVC: (resultVC?.presentedViewController)!)
        }
        return resultVC
    }
    
    fileprivate func hdcurrentViewController(rootVC:AnyObject)
        -> UIViewController? {
            
            if rootVC.isKind(of: UINavigationController.self) {
                let vc = rootVC as? UINavigationController
                return self.hdcurrentViewController(rootVC:(vc?.topViewController)!)
                
            }else if rootVC.isKind(of: UITabBarController.self) {
                let vc = rootVC as? UITabBarController
                return self.hdcurrentViewController(rootVC:(vc?.selectedViewController)!)
            }else if rootVC.isKind(of: UIViewController.self) {
                let vc = rootVC as? UIViewController
                return vc
            }
            return  nil
    }
}


//

extension UIView {
    
    func removeAllSubviews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
}


