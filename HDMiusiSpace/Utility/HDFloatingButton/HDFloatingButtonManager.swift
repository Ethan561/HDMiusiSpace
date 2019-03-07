//
//  HDFloatingButtonManager.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/7/16.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

final class HDFloatingButtonManager: NSObject {
    static let manager = HDFloatingButtonManager.init()
    //需要显示悬浮按钮的界面
    var showFloatingBtnVCs:[String] = [String]()
    lazy var floatingBtnView = HDFloatingButtonView()
    //
    var iconUrl: String? {
        didSet {
            showViewImg()
        }
    }
    
    var listenID: String?
    
    private override init() {
        super.init()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerIsPlayOrPause(noti:)), name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerFinishPlaying(noti:)), name: NSNotification.Name(rawValue: "AVPlayerFinishPlaying"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(avplayerInterruptionPauseNoti(noti:)), name: NSNotification.Name(rawValue: "AVPlayerInterruptionPauseNoti"), object: nil)

    }
    
    func setup() {
        //
        floatingBtnView.frame = CGRect.init(x: ScreenWidth - PlayWidth - 10, y: ScreenHeight * 0.3, width: PlayWidth, height: FolderHeight)
        floatingBtnView.delegate = self
        floatingBtnView.floatingButtonDidSelect = {
            self.pushToPlayerVC()
        }
        //
//        let path = Bundle.main.path(forResource: "gif", ofType: "gif")
//        let gifView: HDGIFImageView = HDGIFImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60), path: path!)
//         gifView.startAnimating()
//         floatingBtnView.addSubview(gifView)
//        gifView.isUserInteractionEnabled = false
        
    }
    
    func showViewImg() {
        guard let url = iconUrl else {
            return
        }
        if url.contains("http") {
            self.floatingBtnView.imgBtn.kf.setImage(with: URL.init(string: url), placeholder: UIImage.init(named: "img_kj_listen"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.floatingBtnView.imgBtn.image = UIImage.init(named: "img_kj_listen")
        }
    }
    
    func pushToPlayerVC()  {
        
        guard let id = listenID else {
            return
        }
        let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
        vc.listen_id = id
        
        //防止恶意点击
        UIApplication.shared.beginIgnoringInteractionEvents()
        let currentVC = self.topViewController()
        if currentVC?.navigationController != nil {
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.floatingBtnView.show = false
        
    }
    
    @objc func avplayerIsPlayOrPause(noti:Notification) {
    
        guard let topVC =  self.topViewController() else {
            return
        }
        if (topVC.isKind(of: HDLY_ListenDetail_VC.self)) {
            return
        }
        //LOG("vcname: \(topVC.className)")
        
        if let obj = noti.object as? Bool {
            if obj {
                floatingBtnView.showType = .FloatingButtonPlay
                floatingBtnView.playBtn.image = UIImage.init(named: "float_icon_pause")
                floatingBtnView.showView()
            } else {
                if HDLY_AudioPlayer.shared.state == .paused {
                    floatingBtnView.showType = .FloatingButtonPause
                    floatingBtnView.showView()
                }
            }
        }
        
        /*
        if self.showFloatingBtnVCs.contains(topVC.className) {
            if let obj = noti.object as? Bool {
                if obj {
                    floatingBtnView.show = true
                } else {
                    floatingBtnView.show = false
                }
            }
        }else {
            floatingBtnView.show = false
        }*/

    }
    
    @objc func avplayerFinishPlaying(noti:Notification) {
        floatingBtnView.closeAction()
    }
    
    @objc func avplayerInterruptionPauseNoti(noti:Notification) {
        
//        floatingBtnView.showType = .FloatingButtonPause
//        floatingBtnView.showView()
        
    }
    
}

extension HDFloatingButtonManager: HDFloatingButtonViewDelegate {
    
    func floatingButtonBeginMove(floatingView: HDFloatingButtonView, point: CGPoint) {
        
    }
    
    func floatingButtonMoved(floatingView: HDFloatingButtonView, point: CGPoint) {
        
    }
    
    func floatingButtonCancleMove(floatingView: HDFloatingButtonView) {
        
    }
    
}





