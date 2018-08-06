//
//  HDFloatingButtonView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/7/16.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

let kWindow = UIApplication.shared.keyWindow
let animationDuration = 0.5
let kPadding:CGFloat  = 5.0
let kFloatingBtnRect = CGRect.init(x: ScreenWidth-70, y: ScreenHeight * 0.3, width: 60, height: 60)

protocol HDFloatingButtonViewDelegate: NSObjectProtocol {
    func floatingButtonBeginMove(floatingView: HDFloatingButtonView, point: CGPoint)
    func floatingButtonMoved(floatingView: HDFloatingButtonView, point: CGPoint)
    func floatingButtonCancleMove(floatingView: HDFloatingButtonView)
}

class HDFloatingButtonView: UIView {
    
    public weak var delegate: HDFloatingButtonViewDelegate?
    var floatingButtonDidSelect: (()->())?
    fileprivate var beginPoint: CGPoint?
    
    var show:Bool = false{
        didSet {
            if show {
                kWindow?.addSubview(self)
                self.alpha = 1.0
            } else {
                self.alpha = 0
                self.removeFromSuperview()
            }
        }
    }
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.frame = kFloatingBtnRect
        setup()
        addTapGesture()
    }
    
    func setup() {
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = bounds.width * 0.5
        layer.masksToBounds = true
    }
    
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action:#selector(tapGestrueAction))
        tap.delaysTouchesBegan = true
        addGestureRecognizer(tap)
    }
    
    @objc func tapGestrueAction() {
        guard let didSelect = floatingButtonDidSelect else {
            return
        }
        didSelect()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - touches action
extension HDFloatingButtonView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        beginPoint = touches.first?.location(in: self)
        if let beginPoint = beginPoint {
            delegate?.floatingButtonBeginMove(floatingView: self, point: beginPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first?.location(in: self)
        guard let currentP = currentPoint, let beginP = beginPoint else {
            return
        }
        delegate?.floatingButtonMoved(floatingView: self, point: currentP)
        
        let offsetX = currentP.x - beginP.x
        let offsetY = currentP.y - beginP.y
        center = CGPoint(x: center.x + offsetX, y: center.y + offsetY)
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let superview = superview else{
            return
        }
        delegate?.floatingButtonCancleMove(floatingView: self)
        //获取边距
        let  marginLeft = frame.origin.x
        let  marginRight = superview.frame.width - frame.minX - frame.width
        let  marginTop = frame.minY
        let  marginBottom = superview.frame.height - self.frame.minY - frame.height
        //移动的最终坐标
        var desinationFrame = frame
        //最终的 x 坐标
        var tempX : CGFloat = 0
        
        //上、下边界移动
        if marginTop < 60 || marginBottom < 60 {
            if marginLeft < marginRight {
                if marginLeft < kPadding {
                    tempX = kPadding
                }else{
                    tempX = frame.minX
                }
            }
            else {
                if(marginRight < kPadding){
                    tempX = superview.frame.width - frame.width - kPadding
                }else{
                    tempX = frame.minX
                }
            }
            
            desinationFrame = CGRect.init(x: tempX, y: marginTop < marginBottom ? kPadding : superview.frame.height - frame.height - kPadding, width: kFloatingBtnRect.width, height: kFloatingBtnRect.height)
        }
        //中间边界移动
        else {
            desinationFrame = CGRect.init(x: marginLeft < marginRight ? kPadding : superview.frame.width - frame.width - kPadding, y: frame.midY, width: kFloatingBtnRect.width, height: kFloatingBtnRect.height)
        }
        UIView.animate(withDuration: animationDuration) {
            self.frame = desinationFrame
        }
    }
}



