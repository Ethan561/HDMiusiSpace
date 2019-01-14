//
//  ReplicatorAnimation.swift
//  SwiftAnimations
//
//  Created by liuyi on 2018/5/15.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

enum ReplicatorLayerType {
    case ReplicatorLayerCircle  //波纹
    case ReplicatorLayerWave    //波浪
    case ReplicatorLayerTriangle  //三角形
    case ReplicatorLayerGrid    //网格
    case ReplicatorLayerShake   //条形
    case ReplicatorLayerRound   // 转圈
}


class ReplicatorAnimation: NSObject {

    class func replicatorLayerWithType(type : ReplicatorLayerType ) -> CALayer {
        var layer: CALayer?
        switch type {
        case .ReplicatorLayerCircle:
            layer = self.replicatorLayer_Circle()
        case .ReplicatorLayerWave:
            layer = self.replicatorLayer_Wave()
        case .ReplicatorLayerTriangle:
            layer = self.replicatorLayer_Triangle()
        case .ReplicatorLayerGrid:
            layer = self.replicatorLayer_Grid()
        case .ReplicatorLayerShake:
            layer = self.replicatorLayer_Shake()
        case .ReplicatorLayerRound:
            layer = self.replicatorLayer_Round()
        }
        return layer!
    }
    
    // 波纹
    class func replicatorLayer_Circle() -> CALayer {
        let replicatorLayer = CAReplicatorLayer.init()
        replicatorLayer.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        replicatorLayer.instanceCount = 8
        replicatorLayer.instanceDelay = 0.8
        //添加动画层
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: 80, height: 80)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.opacity = 0.0
        //
        let animationGroup = CAAnimationGroup.init()
        let alphaAnimation = HDAnimate.basicAnimationWithKeyPath("opacity", fromValue:1.0, toValue: 0.0, duration: 0, repeatCount: nil, timingFunction: nil)
        let scaleAnimation = HDAnimate.basicAnimationWithKeyPath("transform", fromValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0, 0, 0)), toValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1, 1, 0)), duration: 0, repeatCount: nil, timingFunction: nil)
        
        animationGroup.animations = [alphaAnimation, scaleAnimation];
        animationGroup.duration = 4.0
        animationGroup.autoreverses = false
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "animationGroup")
        
        replicatorLayer.addSublayer(shapeLayer)
        
        return replicatorLayer
    }
    // 波浪
    class func replicatorLayer_Wave() -> CALayer {
        let replicatorLayer = CAReplicatorLayer.init()
        replicatorLayer.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.2
        //
        let between = 5.0
        let radius = (100-2*between)/3
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0, y: (100-radius)/2, width: radius, height: radius)
        shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let scaleAni = HDAnimate.basicAnimationWithKeyPath("transform", fromValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1, 1, 0)), toValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)), duration: 0, repeatCount: nil, timingFunction: nil)
        scaleAni.autoreverses = true
        scaleAni.repeatCount = Float.infinity
        scaleAni.duration = 0.6
        shapeLayer.add( scaleAni, forKey: "scaleAnimation")
        //
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(CGFloat(between*2+radius), 0, 0)
        replicatorLayer.addSublayer(shapeLayer)
        return replicatorLayer

    }
    
    // 三角形
    class func replicatorLayer_Triangle() -> CALayer {
        let replicatorLayer = CAReplicatorLayer.init()
        let radius:CGFloat = 100/4.0
        let transX:CGFloat = 100 - radius
        replicatorLayer.frame = CGRect.init(x: 0, y: 0, width: radius, height: radius)
        replicatorLayer.instanceCount = 3
        replicatorLayer.instanceDelay = 0.0
        var trans3D = CATransform3DIdentity
        trans3D = CATransform3DTranslate(trans3D, CGFloat(transX), 0, 0)
        trans3D = CATransform3DRotate(trans3D, CGFloat(120.0*Double.pi/180.0), 0, 0, 1)
        replicatorLayer.instanceTransform = trans3D
        //
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor

        shapeLayer.lineWidth = 1
        
        let fromValue = CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0)
        var toValue:CATransform3D  =  CATransform3DTranslate(CATransform3DIdentity, transX, 0, 0 )
        toValue = CATransform3DRotate(toValue, CGFloat(120.0*Double.pi/180.0), 0, 0, 1)
        let rotateAni = HDAnimate.basicAnimationWithKeyPath("transform", fromValue: NSValue.init(caTransform3D: fromValue), toValue: NSValue.init(caTransform3D: toValue), duration: 0.8, repeatCount: Float.infinity, timingFunction: kCAMediaTimingFunctionEaseInEaseOut)
        rotateAni.autoreverses = false
        shapeLayer.add(rotateAni, forKey: "rotateAnimation")
        
        replicatorLayer.addSublayer(shapeLayer)
        
        return replicatorLayer
    }
    // 网格
    class func replicatorLayer_Grid() -> CALayer {
        let column : CGFloat = 3
        let between: CGFloat = 5.0
        let radius : CGFloat = (100 - between*(column - 1))/column
        //
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: radius, height: radius)
        shapeLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: radius, height: radius)).cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        
        let animationGroup = CAAnimationGroup.init()
        
        let alphaAnimation = HDAnimate.basicAnimationWithKeyPath("opacity", fromValue:1.0, toValue: 0.0, duration: 0, repeatCount: nil, timingFunction: nil)
        
        let scaleAnimation = HDAnimate.basicAnimationWithKeyPath("transform", fromValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 1, 1, 0)), toValue: NSValue.init(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0)), duration: 0.6, repeatCount: Float.infinity, timingFunction: nil)
        scaleAnimation.autoreverses = true
        
        animationGroup.animations = [scaleAnimation,alphaAnimation];
        animationGroup.duration = 1.0
        animationGroup.autoreverses = true
        animationGroup.repeatCount = Float.infinity
        shapeLayer.add(animationGroup, forKey: "animationGroup")
        
        let replicatorLayerX = CAReplicatorLayer.init()
        replicatorLayerX.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        replicatorLayerX.instanceCount =  Int(column)
        replicatorLayerX.instanceDelay = 0.3
        replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, radius+between, 0, 0)
        replicatorLayerX.addSublayer(shapeLayer)
        
        let replicatorLayerY = CAReplicatorLayer.init()
        replicatorLayerY.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        replicatorLayerY.instanceCount =  Int(column)
        replicatorLayerY.instanceDelay = 0.3
        replicatorLayerY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, radius+between, 0)
        replicatorLayerY.addSublayer(replicatorLayerX)
        
        return replicatorLayerY
    }
    
    // 音乐条
    class func replicatorLayer_Shake() -> CALayer {
        
        let layer = CALayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: 10, height: 80)
        layer.backgroundColor = UIColor.red.cgColor
        layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        
        let scaleAnimation = HDAnimate.basicAnimationWithKeyPath("transform.scale.y", fromValue: 0.1, toValue: 0.4, duration: 0, repeatCount: Float.infinity, timingFunction: nil)
        scaleAnimation.autoreverses = true
        layer.add(scaleAnimation, forKey: "scaleAnimation")
        
        
        let replicatorLayer = CAReplicatorLayer.init()
        replicatorLayer.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        replicatorLayer.instanceCount = 6
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(45, 0, 0)
        replicatorLayer.instanceGreenOffset = -0.3
        replicatorLayer.addSublayer(layer)
    
        return replicatorLayer
    }
    
    // 转圈动画
    class func replicatorLayer_Round() -> CALayer {
        
        let layer = CALayer.init()
        layer.frame = CGRect.init(x: 0, y: 0, width: 8, height: 8)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
        layer.backgroundColor = UIColor.white.cgColor
        
        let scaleAnimation = HDAnimate.basicAnimationWithKeyPath("transform.scale", fromValue: 1, toValue: 0.01, duration: 1, repeatCount: Float.infinity, timingFunction: nil)
        layer.add(scaleAnimation, forKey: "scaleAni")
        scaleAnimation.isRemovedOnCompletion = false
        
        let instanceCount = 9
        let replicatorLayer = CAReplicatorLayer.init()
        replicatorLayer.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        replicatorLayer.preservesDepth = true
        replicatorLayer.instanceColor = UIColor.white.cgColor
        replicatorLayer.instanceRedOffset = 0.1
        replicatorLayer.instanceGreenOffset = 0.1
        replicatorLayer.instanceBlueOffset = 0.1
        replicatorLayer.instanceAlphaOffset = 0.1
        replicatorLayer.instanceCount = instanceCount
        replicatorLayer.instanceDelay = CFTimeInterval(1.0/Float(instanceCount))
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi*2/Double(instanceCount)), 0, 0, 1)
        replicatorLayer.addSublayer(layer)
        
        return replicatorLayer
    }

}














