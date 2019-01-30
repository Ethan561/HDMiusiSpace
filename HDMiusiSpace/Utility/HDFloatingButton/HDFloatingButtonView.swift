//
//  HDFloatingButtonView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/7/16.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

let kWindow = UIApplication.shared.keyWindow
let animationDuration = 0.3
let kPadding:CGFloat  = 5.0
//let kFloatingBtnRect = CGRect.init(x: ScreenWidth-70, y: ScreenHeight * 0.3, width: 50, height: 50)

let FolderWidth: CGFloat  = 108
let FolderHeight: CGFloat  = 50.0

let PlayWidth: CGFloat  = 100.0
let PauseWidth: CGFloat  = 140

protocol HDFloatingButtonViewDelegate: NSObjectProtocol {
    func floatingButtonBeginMove(floatingView: HDFloatingButtonView, point: CGPoint)
    func floatingButtonMoved(floatingView: HDFloatingButtonView, point: CGPoint)
    func floatingButtonCancleMove(floatingView: HDFloatingButtonView)
}

enum FloatingButtonShowType {
    case FloatingButtonFolder
    case FloatingButtonPlay
    case FloatingButtonPause
}

class HDFloatingButtonView: UIView, UIGestureRecognizerDelegate {
    
    public weak var delegate: HDFloatingButtonViewDelegate?
    var floatingButtonDidSelect: (()->())?
    fileprivate var beginPoint: CGPoint?
    var isRotation = false
    
    var showType:FloatingButtonShowType = .FloatingButtonPlay
    var bgView:HDFloatingButtonBgView = HDFloatingButtonBgView.init()
    
    //
    lazy var foldBtn: UIImageView = {
        let btn = UIImageView.init()
        btn.image = UIImage.init(named: "float_icon_zhankai")
//        btn.addTarget(self, action: #selector(unfoldAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action:#selector(unfoldAction))
//        tap.cancelsTouchesInView = false
        btn.frame = CGRect.zero
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(tap)
        btn.contentMode = .scaleAspectFit
        tap.numberOfTapsRequired = 1
        return btn
    }()
    lazy var imgBtn: UIImageView = {
        let btn = UIImageView.init()
        btn.image = UIImage.init(named: "img_kj_listen")
        let tap = UITapGestureRecognizer(target: self, action:#selector(showDetailAction))
//        tap.cancelsTouchesInView = false
        btn.frame = CGRect.zero
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(tap)
        btn.contentMode = .scaleAspectFit
        tap.numberOfTapsRequired = 1
        btn.layer.cornerRadius = 17
        btn.layer.masksToBounds = true
        
        return btn
    }()
    
    lazy var playBtn: UIImageView = {
        let btn = UIImageView.init()
        btn.image = UIImage.init(named: "float_icon_play")
        let tap = UITapGestureRecognizer(target: self, action:#selector(playBtnAction))
//        tap.cancelsTouchesInView = false
        btn.frame = CGRect.zero
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(tap)
        btn.contentMode = .scaleAspectFit
        tap.numberOfTapsRequired = 1

        return btn
    }()
    lazy var closeBtn: UIImageView = {
        let btn = UIImageView.init()
        btn.image = UIImage.init(named: "float_icon_close")
        let tap = UITapGestureRecognizer(target: self, action:#selector(closeAction))
//        tap.cancelsTouchesInView = false
        btn.frame = CGRect.zero
        btn.isUserInteractionEnabled = true
        btn.addGestureRecognizer(tap)
        btn.contentMode = .scaleAspectFit
        tap.numberOfTapsRequired = 1

        return btn
    }()

    var show:Bool = false {
        didSet {
            if show {
                self.showView()
            } else {
                self.alpha = 0
                self.removeFromSuperview()
            }
        }
    }
    
    var isRight: Bool = true
    var player = HDLY_AudioPlayer.shared

    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.frame = CGRect.init(x: ScreenWidth-self.left-10, y: ScreenHeight * 0.3, width: PauseWidth, height: FolderHeight)
        setup()
//        addTapGesture()
//        self.isMultipleTouchEnabled = true
    }
    
    func setup() {
        backgroundColor = UIColor.white
        self.configShadow(cornerRadius: 25, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        
//        layer.cornerRadius = 25
//        layer.masksToBounds = true
        addSubview(self.foldBtn)
        addSubview(self.imgBtn)
        addSubview(self.playBtn)
        addSubview(self.closeBtn)

    }
    
    func showView() {
        let desinationFrame = self.frame
        let xdes = desinationFrame.origin.x
        let ydes = desinationFrame.origin.y
        //获取边距
        let  marginLeft = frame.origin.x
        let  marginRight = ScreenWidth - frame.minX - frame.width
        if marginLeft < marginRight {
            isRight = false
        }else {
            isRight = true
        }
        
        if showType == .FloatingButtonFolder {
            self.imgBtn.isHidden = true
            self.playBtn.isHidden = true
            self.closeBtn.isHidden = true
            self.foldBtn.isHidden = false
            
            UIView.animate(withDuration: animationDuration, animations: {
                if self.isRight {
                    self.frame = CGRect.init(x: ScreenWidth-FolderWidth/2, y: ydes, width: FolderWidth, height: FolderHeight)
                    self.foldBtn.frame = CGRect.init(x: 10, y: 15, width: 34, height: 20)

                } else {
                    self.frame = CGRect.init(x: -FolderWidth/2, y: ydes, width: FolderWidth, height: FolderHeight)
                    self.foldBtn.frame = CGRect.init(x: FolderWidth-34-10, y: 15, width: 34, height: 20)
                }
            }) { (animete) in
//                self.updateFrame()
            }
        }
        else if showType == .FloatingButtonPlay {
            self.imgBtn.isHidden = false
            self.playBtn.isHidden = false
            self.closeBtn.isHidden = true
            self.foldBtn.isHidden = true
            playBtn.image = UIImage.init(named: "float_icon_pause")

            UIView.animate(withDuration: animationDuration, animations: {
                if self.isRight {
                    self.frame = CGRect.init(x: ScreenWidth-PlayWidth-kPadding, y: ydes, width: PlayWidth, height: FolderHeight)
                    self.imgBtn.frame = CGRect.init(x: 10, y: 8, width: 34, height: 34)
                    self.playBtn.frame = CGRect.init(x: self.imgBtn.right+10, y: 15, width: 34, height: 20)
                } else {
                    self.frame = CGRect.init(x: kPadding, y: ydes, width: PlayWidth, height: FolderHeight)
                    self.imgBtn.frame = CGRect.init(x: 10, y: 8, width: 34, height: 34)
                    self.playBtn.frame = CGRect.init(x: self.imgBtn.right+10, y: 15, width: 34, height: 20)
                }
  
            }) { (animete) in
                self.addRotationAnimation()
            }
        }
            
        else if showType == .FloatingButtonPause {
            self.imgBtn.isHidden = false
            self.playBtn.isHidden = false
            self.closeBtn.isHidden = false
            self.foldBtn.isHidden = true
            
            UIView.animate(withDuration: animationDuration, animations: {
                if self.isRight {
                    self.frame = CGRect.init(x: ScreenWidth-PauseWidth-kPadding, y: ydes, width: PauseWidth, height: FolderHeight)
                    self.imgBtn.frame = CGRect.init(x: 10, y: 8, width: 34, height: 34)
                    self.playBtn.frame = CGRect.init(x: self.imgBtn.right+10, y: 15, width: 34, height: 20)
                    self.closeBtn.frame = CGRect.init(x: self.playBtn.right+10, y: 15, width: 34, height: 20)
                } else {
                    self.frame = CGRect.init(x: kPadding, y: ydes, width: PauseWidth, height: FolderHeight)
                    self.imgBtn.frame = CGRect.init(x: 10, y: 8, width: 34, height: 34)
                    self.playBtn.frame = CGRect.init(x: self.imgBtn.right+10, y: 15, width: 34, height: 20)
                    self.closeBtn.frame = CGRect.init(x: self.playBtn.right+10, y: 15, width: 34, height: 20)
                }

            }) { (animete) in
                self.removeRotationAnimation()
            }
        }
        
        if showType == .FloatingButtonPause {
            bgView.frame = (kWindow?.bounds)!
            playBtn.image = UIImage.init(named: "float_icon_play")

            kWindow?.addSubview(bgView)
            weak var weakS = self
            bgView.touchBlock = {
                weakS?.bgView.removeFromSuperview()
                if weakS?.showType == .FloatingButtonPause {
                    weakS?.showType = .FloatingButtonFolder
                    weakS?.showView()
                }
            }
        }else {
            bgView.removeFromSuperview()
            bgView.touchBlock = nil
        }
        
        kWindow?.addSubview(self)
        self.alpha = 1.0
     
    }
    
    func addRotationAnimation() {
        if isRotation == true {
            return
        }
        isRotation = true
        imgBtn.layer.removeAllAnimations()
        let animate = HDAnimate.basicAnimationWithKeyPath("transform.rotation.z", fromValue: nil , toValue: 2 * Double.pi, duration: 5.0, repeatCount: Float.infinity, timingFunction: kCAMediaTimingFunctionLinear)
        imgBtn.layer.add(animate, forKey: "transform.rotation.z")
    }
    
    func removeRotationAnimation() {
        isRotation = false
        imgBtn.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrame() {
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
        /*
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
            
            desinationFrame = CGRect.init(x: tempX, y: marginTop < marginBottom ? kPadding : superview.frame.height - frame.height - kPadding, width: self.width, height: self.height)
        }
            //中间边界移动
        else {
            desinationFrame = CGRect.init(x: marginLeft < marginRight ? kPadding : superview.frame.width - frame.width - kPadding, y: frame.origin.y, width: self.width, height: self.height)
        }
        */
        
        desinationFrame = CGRect.init(x: marginLeft < marginRight ? kPadding : superview.frame.width - frame.width - kPadding, y: frame.origin.y, width: self.width, height: self.height)

        UIView.animate(withDuration: animationDuration) {
            self.frame = desinationFrame
        }
    }
}

// MARK: - touches action
extension HDFloatingButtonView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if showType == .FloatingButtonFolder {
            return
        }
        beginPoint = touches.first?.location(in: self)
        if let beginPoint = beginPoint {
            delegate?.floatingButtonBeginMove(floatingView: self, point: beginPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if showType == .FloatingButtonFolder {
            return
        }
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
        if showType == .FloatingButtonFolder {
            return
        }
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
        
        /*
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
            
            desinationFrame = CGRect.init(x: tempX, y: marginTop < marginBottom ? kPadding : superview.frame.height - frame.height - kPadding, width: self.width, height: self.height)
        }
        //中间边界移动
        else {
            desinationFrame = CGRect.init(x: marginLeft < marginRight ? kPadding : superview.frame.width - frame.width - kPadding, y: frame.origin.y, width: self.width, height: self.height)
//            if marginLeft < marginRight {
//                self.positionType = .MarginRight
//            }else {
//                self.positionType = .MarginLeft
//            }
        }
        */
        
        desinationFrame = CGRect.init(x: marginLeft < marginRight ? kPadding : superview.frame.width - frame.width - kPadding, y: frame.origin.y, width: self.width, height: self.height)
        UIView.animate(withDuration: animationDuration) {
            self.frame = desinationFrame
        }
    }
    
    //return false 将点击事件传递下去
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        return true
//    }
}

// action
extension HDFloatingButtonView {
    
    @objc func closeAction() {
        player.stop()
        bgView.touchBlock = nil
        bgView.removeFromSuperview()
        self.show = false
        
    }
    
    //展开
    @objc func unfoldAction()  {
        self.showType = .FloatingButtonPause
        showView()
    }
    
    @objc func showDetailAction()  {
        if self.floatingButtonDidSelect != nil {
            self.floatingButtonDidSelect!()
            bgView.touchBlock = nil
            bgView.removeFromSuperview()
            self.show = false
        }
    }
    
    @objc func playBtnAction()  {
        if player.state == .playing {
            self.showType = .FloatingButtonPause
            player.pause()
            playBtn.image = UIImage.init(named: "float_icon_play")
            showView()
        }else {
            self.showType = .FloatingButtonPlay
            player.play()
            playBtn.image = UIImage.init(named: "float_icon_pause")
            showView()
        }
    }
}





