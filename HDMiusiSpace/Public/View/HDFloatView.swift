//
//  HDFloatView.swift
//  HDCHNationMuseum
//
//  Created by HD-XXZQ-iMac on 2020/8/13.
//  Copyright © 2020 Tianjin Hengda Wenbo S. &T.Co., LTD. All rights reserved.
//

import UIKit

enum HDFloatViewType : Int {
    case none = 0 //根据左右距离的一半自动居左局右
    case left //居左
    case right
}

class HDFloatView: UIView {
    
    private var originalPoint:CGPoint!
    internal var type:HDFloatViewType = .none;
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, show type: HDFloatViewType) {
        self.init(frame: frame)
        self.type = type
        configUI()
    }
    
    
    func configUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        addGestureRecognizer(tap)
        //滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        addGestureRecognizer(pan)
        
    }
    
    
    
    
    @objc func tap(_ tap: UITapGestureRecognizer?) {
        print("11111")
    }
    
    @objc func pan(_ pan: UITapGestureRecognizer?) {
        
        let currentPosition = pan?.location(in: self)
        if pan?.state == UIGestureRecognizer.State.began {
            originalPoint = currentPosition
        } else if (pan?.state == UIGestureRecognizer.State.changed) {
            let offsetX = currentPosition!.x - originalPoint.x
            let offsetY = currentPosition!.y - originalPoint.y
            
            //移动后的按钮中心坐标
            let centerX = center.x
            var centerY = center.y + offsetY
            center = CGPoint(x: centerX, y: centerY)
            
            //父视图的宽高
            let superViewWidth = self.superview?.frame.size.width
            let superViewHeight = self.superview?.frame.size.height
            let btnX = frame.origin.x
            let btnY = frame.origin.y
            let btnW = frame.size.width
            let btnH = frame.size.height
            if btnX > superViewWidth! {
                //按钮右侧越界
                let centerX: CGFloat = superViewWidth! - btnW / 2
                center = CGPoint(x: centerX, y: centerY)
            } else if btnX < 0 {
                //按钮左侧越界
                let centerX: CGFloat = btnW * 0.5
                center = CGPoint(x: centerX, y: centerY)
            }
            let defaultNaviHeight:CGFloat = 64;
            let judgeSuperViewHeight = superViewHeight! - defaultNaviHeight;
            //y轴上下极限坐标
            if (btnY <= 0){
                //按钮顶部越界
                centerY = btnH * 0.7;
                self.center = CGPoint.init(x: centerX, y: centerY)
            }
            else if (btnY > judgeSuperViewHeight){
                //按钮底部越界
                let y = superViewHeight! - btnH * 0.5;
                self.center = CGPoint.init(x: btnX, y: y)
            }
            
        }else if (pan!.state == UIGestureRecognizer.State.ended){
            let btnWidth = self.frame.size.width;
            let btnHeight = self.frame.size.height;
            let btnY = self.frame.origin.y;
            switch type {
            case .none:
                if self.center.x >= superview!.frame.size.width / 2 {
                    UIView.animate(withDuration: 0.5, animations: {
                        //按钮靠右自动吸边
                        let btnX: CGFloat = self.superview!.frame.size.width - btnWidth
                        self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
                    })
                } else {

                    UIView.animate(withDuration: 0.5, animations: {
                        //按钮靠左吸边
                        let btnX: CGFloat = 0
                        self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
                    })
                }
                break
            case .left:
                UIView.animate(withDuration: 0.5, animations: {
                    //按钮靠左吸边
                    let btnX: CGFloat = 0
                    self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
                })
                break
            case .right:

                UIView.animate(withDuration: 0.5, animations: {
                    //按钮靠右自动吸边
                    let btnX: CGFloat = self.superview!.frame.size.width - btnWidth
                    self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
                })
                break
            }
        }
    }
    
    
    
    
}



