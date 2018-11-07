//
//  HDLY_QRGuideVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_QRGuideVC: HDItemBaseVC {

    
    lazy var codeView:QRCode_View = {
        let curr = QRCode_View.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        if HDDeclare.isSimulator() {
            return curr
        }
        curr.setupQRCode(self)
        weak var weakSelf = self
        curr.tellMeString(backBlock: { (str) in
            let currID:Int = Int(str)!
//            weakSelf?.goTo_detialVC(exhibit_id: String(currID), theType: 1)
        })
        return curr
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.codeView)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
