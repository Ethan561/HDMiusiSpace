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
    
    private override init() {
        super.init()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(avplayerIsPlayOrPause(noti:)), name: NSNotification.Name(rawValue: "AVPlayerPlayingOrPause"), object: nil)
    }
    
    func setup() {
        //
        floatingBtnView.frame = kFloatingBtnRect
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
    
    func pushToPlayerVC()  {
        /*
        let vc = HDZQExhibitDetailVC.init(nibName: "HDZQExhibitDetailVC", bundle: nil)
        let entrance = UserDefaults.standard.value(forKey: "CurrentPlayEntrance") as? Int
        let roadId = UserDefaults.standard.value(forKey: "CurrentPlayRoadId") as? Int
        if  let exhibitId = UserDefaults.standard.value(forKey: "CurrentPlayExhibitId") as? Int {
            vc.exhibitID = exhibitId
            vc.roadId = roadId
            if entrance == 0 {
                vc.enrtance = ExhibitDetailEntrance.SearchEntrance
            } else if entrance == 1 {
                vc.enrtance = ExhibitDetailEntrance.MapEntrance
            } else {
                vc.enrtance = ExhibitDetailEntrance.ListEntrance
            }
        }
        vc.hidesBottomBarWhenPushed = true
        //防止恶意点击
        UIApplication.shared.beginIgnoringInteractionEvents()
        let currentVC = self.topViewController()
        if currentVC?.navigationController != nil {
            currentVC?.navigationController?.pushViewController(vc, animated: true)
        }
        UIApplication.shared.endIgnoringInteractionEvents()
        self.floatingBtnView.show = false
 */
        
    }
    
    @objc func avplayerIsPlayOrPause(noti:Notification) {
        /*
        guard let topVC =  self.topViewController() else {
            return
        }
        if (topVC.isKind(of: HDZQExhibitDetailVC.self)) {
            return
        }
        LOG("vcname: \(topVC.className)")
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
        }
 */
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





