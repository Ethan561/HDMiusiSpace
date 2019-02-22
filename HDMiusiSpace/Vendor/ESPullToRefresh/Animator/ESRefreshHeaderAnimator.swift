//
//  ESRefreshHeaderView.swift
//
//  Created by egg swift on 16/4/7.
//  Copyright (c) 2013-2016 ESPullToRefresh (https://github.com/eggswift/pull-to-refresh)
//  Icon from http://www.iconfont.cn
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import QuartzCore
import UIKit

let jumpImgWidth = 12

open class ESRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {

    /*
     "Pull to refresh" = "下拉刷新";
     "Release to refresh" = "松开刷新";
     "Loading..." = "加载中...";
     */
    open var pullToRefreshDescription = NSLocalizedString("Pull to refresh", comment: "") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = NSLocalizedString("Release to refresh", comment: "")
    open var loadingDescription = NSLocalizedString("Loading...", comment: "")

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: ESRefreshViewState = .pullToRefresh
    
    //刷新成功提醒
    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "check-circle")
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        label.text = "刷新成功"
        return label
    }()
    //拉伸形变图片
    private let mainImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "mus_bar")
        return imageView
    }()
    
    //字母跳动
    fileprivate let jumpImageView1: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "refresh_ic_m")
        let pX: Int = Int(ScreenWidth * 0.5)
        let pY: Int =  -jumpImgWidth - 5
        imageView.frame = CGRect.init(x: pX - jumpImgWidth , y: pY, width: jumpImgWidth, height: jumpImgWidth)
        return imageView
    }()
    
    fileprivate let jumpImageView2: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "refresh_ic_u")
        let pX: Int = Int(ScreenWidth * 0.5)
        let pY: Int =  -jumpImgWidth - 5
        imageView.frame = CGRect.init(x: pX, y: pY, width: jumpImgWidth, height: jumpImgWidth)
        return imageView
    }()
    fileprivate let jumpImageView3: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage(named: "refresh_ic_s")
        let pX: Int = Int(ScreenWidth * 0.5)
        let pY: Int =  -jumpImgWidth - 5
        imageView.frame = CGRect.init(x: pX + jumpImgWidth, y: pY, width: jumpImgWidth, height: jumpImgWidth)
        return imageView
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        imageView.isHidden = true
        titleLabel.isHidden = true
        //
        self.addSubview(self.mainImageView)
        self.addSubview(jumpImageView1)
        self.addSubview(jumpImageView2)
        self.addSubview(jumpImageView3)
        jumpImageView1.isHidden = true
        jumpImageView2.isHidden = true
        jumpImageView3.isHidden = true
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        //indicatorView.startAnimating()
        mainImageView.image = UIImage.init(named: "refresh_path_2")

        indicatorView.isHidden = false
        imageView.isHidden = true
        //titleLabel.text = loadingDescription//加载中。。。
        //imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
        mainImageView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.mainImageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                               y: self.bounds.size.height - self.trigger,
                                               width: 39.0,
                                               height: self.trigger)
            
            
        }, completion: { (finished) in

        })
    }
  
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
//        imageView.isHidden = false
//        titleLabel.isHidden = false
//        mainImageView.isHidden = true
        //titleLabel.text = pullToRefreshDescription//下拉刷新...
//        imageView.transform = CGAffineTransform.identity
        self.closeAction()
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
        //print("progress:\(progress)")
        if ZFReachabilityManager.shared().isReachable == false {
            self.imageView.image = UIImage.init(named: "close-circle")
            self.titleLabel.text = "刷新失败"
        }else {
            self.imageView.image = UIImage.init(named: "check-circle")
            self.titleLabel.text = "刷新成功"
        }
        self.imageView.isHidden = true
        self.titleLabel.isHidden = true
        
        let p = max(0.0, min(1.0, progress))
        if progress < 1.2 {
            self.mainImageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                                   y: self.bounds.size.height - trigger * p,
                                                   width: 39.0,
                                                   height: trigger * p)
        } else {
            
        }
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            //titleLabel.text = loadingDescription//加载中
            self.setNeedsLayout()
            self.startJumpAnimate()
            self.mainImageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                                   y: self.bounds.size.height - 25 ,
                                                   width: 39.0,
                                                   height: 25)
            break
        case .releaseToRefresh:
            //titleLabel.text = releaseToRefreshDescription//松开刷新
            self.setNeedsLayout()
            self.impact()
            
//            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
//                self.mainImageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
//                                                       y: self.bounds.size.height - 25 ,
//                                                       width: 39.0,
//                                                       height: 25)
//            }) { (ani) in
//            }
            
            break
        case .pullToRefresh:
            //titleLabel.text = pullToRefreshDescription//下拉刷新
            mainImageView.image = UIImage.init(named: "mus_bar")

            mainImageView.isHidden = false
            jumpImageView1.isHidden = true
            jumpImageView2.isHidden = true
            jumpImageView3.isHidden = true
            self.jumpImageView1.layer.removeAllAnimations()
            self.jumpImageView2.layer.removeAllAnimations()
            self.jumpImageView3.layer.removeAllAnimations()
            
            imageView.isHidden = true
            titleLabel.isHidden = true
            
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                //self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 16.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
    
    func startJumpAnimate() {
        jumpImageView1.isHidden = false
        jumpImageView2.isHidden = false
        jumpImageView3.isHidden = false
        self.jumpImageView1.alpha = 1
        self.jumpImageView2.alpha = 1
        self.jumpImageView3.alpha = 1
        //
        self.jumpImageView1.layer.removeAllAnimations()
        self.jumpImageView2.layer.removeAllAnimations()
        self.jumpImageView3.layer.removeAllAnimations()
        
        //
        let pX = ScreenWidth * 0.5
        let pY = self.bounds.size.height - 35
        let anchorX = 0.5
        let anchorY = 0.5
        
        let duration = 0.6
        
        let animate = HDAnimate.basicAnimationWithKeyPath("position", fromValue: NSValue.init(cgPoint: CGPoint.init(x: pX - CGFloat(jumpImgWidth), y: 5)), toValue: NSValue.init(cgPoint: CGPoint.init(x: pX - CGFloat(jumpImgWidth), y: pY)), duration: duration, repeatCount: Float.infinity, timingFunction: kCAMediaTimingFunctionEaseOut)
        animate.autoreverses = true
        jumpImageView1.layer.anchorPoint = CGPoint.init(x: anchorX, y: anchorY)
        
        jumpImageView1.layer.add(animate, forKey: "position")
        
        let animate2 = HDAnimate.basicAnimationWithKeyPath("position", fromValue: NSValue.init(cgPoint: CGPoint.init(x: pX, y: 5)), toValue: NSValue.init(cgPoint: CGPoint.init(x: pX, y: pY)), duration: duration, repeatCount: Float.infinity, timingFunction: kCAMediaTimingFunctionEaseOut)
        animate2.autoreverses = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.jumpImageView2.layer.anchorPoint = CGPoint.init(x: anchorX, y: anchorY)
            self.jumpImageView2.layer.add(animate2, forKey: "position")
        }
        
        let animate3 = HDAnimate.basicAnimationWithKeyPath("position", fromValue: NSValue.init(cgPoint: CGPoint.init(x: pX + CGFloat(jumpImgWidth), y: 5)), toValue: NSValue.init(cgPoint: CGPoint.init(x: pX + CGFloat(jumpImgWidth), y: pY)), duration: duration, repeatCount: Float.infinity, timingFunction: kCAMediaTimingFunctionEaseOut)
        animate3.autoreverses = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.jumpImageView3.layer.anchorPoint = CGPoint.init(x: anchorX, y: anchorY)
            self.jumpImageView3.layer.add(animate3, forKey: "position")
        }
        
        
    }
    
    func closeAction() {
        UIView.animate(withDuration: 0.1, animations: {
            self.jumpImageView1.alpha = 0
        }) { (ani) in
            UIView.animate(withDuration: 0.1, animations: {
                self.jumpImageView2.alpha = 0
            }) { (ani) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.jumpImageView3.alpha = 0
                }) { (ani) in
                    self.jumpImageView1.layer.removeAllAnimations()
                    self.jumpImageView2.layer.removeAllAnimations()
                    self.jumpImageView3.layer.removeAllAnimations()
                    self.mainImageView.isHidden = true
                    self.imageView.isHidden = false
                    self.titleLabel.isHidden = false
                }
            }
        }
        
    }
}
