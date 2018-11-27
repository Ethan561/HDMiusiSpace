//
//  HDSSL_MyWalletVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_MyWalletVC: HDItemBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
    }
    
    func loadMyViews() {
        
        title = "我的钱包"
        
        //右侧按钮
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("交易记录", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        publishBtn.setTitleColor(UIColor.black, for: .normal)
        publishBtn.addTarget(self, action: #selector(action_goToTransactionRecord), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
    }
    //MARK:-- 交易记录
    @objc func action_goToTransactionRecord() {
        //
        print("交易记录")
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
