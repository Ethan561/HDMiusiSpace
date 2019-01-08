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
           weakSelf?.showWebVC(url: str)
        })
        return curr
    }()
    
    public var titleName: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.codeView)
        self.title = self.titleName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.codeView.rerunning()
    }
    
    func showWebVC(url: String) {
        if url.contains("http") {
            let webVC =  HDItemBaseWebVC()
            webVC.urlPath = url
            webVC.titleName = self.titleName
            self.navigationController?.pushViewController(webVC, animated: true)
        }else {
            let alert:UIAlertController = UIAlertController.init(title: "", message: "二维码无效，请重新扫描", preferredStyle: UIAlertControllerStyle.alert)
            let cancle = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.cancel) { (action) in
                self.codeView.rerunning()
            }
            alert.addAction(cancle)
            self.present(alert, animated: true, completion: nil)
        }
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
