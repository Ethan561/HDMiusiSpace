//
//  HDItemBaseNaviVC.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/10.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class HDItemBaseNaviVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }

//    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if self.childViewControllers.count == 1 {
//            viewController.hidesBottomBarWhenPushed = true
//        }
//        super.pushViewController(viewController, animated: animated)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
