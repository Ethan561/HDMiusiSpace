//
//  NSObject+HDTopVC.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/7/16.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import Foundation

extension  NSObject{
    
    func topViewController() -> UIViewController? {
        guard let rootVc = UIApplication.shared.delegate?.window??.rootViewController else {
            return nil
        }
        
        var resultVC: UIViewController? = self.currentViewController(rootVC: rootVc)
        while ((resultVC?.presentedViewController) != nil) {
            resultVC = self.currentViewController(rootVC: (resultVC?.presentedViewController)!)
        }
        return resultVC
    }
    
    fileprivate func currentViewController(rootVC:AnyObject)
        -> UIViewController? {

        if rootVC.isKind(of: UINavigationController.self) {
            let vc = rootVC as? UINavigationController
            return self.currentViewController(rootVC:(vc?.topViewController)!)
            
        }else if rootVC.isKind(of: UITabBarController.self) {
            let vc = rootVC as? UITabBarController
            return self.currentViewController(rootVC:(vc?.selectedViewController)!)
        }else if rootVC.isKind(of: UIViewController.self) {
            let vc = rootVC as? UIViewController
            return vc
        }
        return  nil
    }
}








