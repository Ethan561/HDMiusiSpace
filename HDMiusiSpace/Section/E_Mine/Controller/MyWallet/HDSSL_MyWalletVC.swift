//
//  HDSSL_MyWalletVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_MyWalletVC: HDItemBaseVC {

    @IBOutlet weak var btn_openVIP: UIButton!
    @IBOutlet weak var goldNumberL: UILabel!
    @IBOutlet weak var menuBg1: UIView!  //余额背景
    @IBOutlet weak var menuBg2: UIView!  //开通VIP背景
    
    
    @IBOutlet weak var sele_title1: UILabel!
    @IBOutlet weak var sele_title2: UILabel!
    @IBOutlet weak var sele_title3: UILabel!
    @IBOutlet weak var sele_title4: UILabel!
    @IBOutlet weak var sele_title5: UILabel!
    @IBOutlet weak var sele_title6: UILabel!
    
    @IBOutlet weak var sele_content1: UILabel!
    @IBOutlet weak var sele_content2: UILabel!
    @IBOutlet weak var sele_content3: UILabel!
    @IBOutlet weak var sele_content4: UILabel!
    @IBOutlet weak var sele_content5: UILabel!
    @IBOutlet weak var sele_content6: UILabel!
    
    
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
        
        menuBg1.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        menuBg2.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        
        btn_openVIP.addRoundedCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: CGSize.init(width: 10, height: 10))
    }
    //MARK:-- 交易记录
    @objc func action_goToTransactionRecord() {
        //
        print("交易记录")
    }

    //开通会员
    @IBAction func action_openVIP(_ sender: UIButton) {
        print("开通会员")
    }
    //充值
    @IBAction func action_recharge(_ sender: UIButton) {
        print("充值")
    }
    
    @IBAction func action_selectProduct(_ sender: UIButton) {
        print(sender.tag)
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
