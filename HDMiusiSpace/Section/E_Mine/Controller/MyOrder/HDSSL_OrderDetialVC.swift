//
//  HDSSL_OrderDetialVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/29.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_OrderDetialVC: HDItemBaseVC {

    @IBOutlet weak var img_icon_state: UIImageView!  //订单状态icon
    @IBOutlet weak var lab_state: UILabel!           //订单状态描述
    @IBOutlet weak var btn_state: UIButton!          //待评价按钮
    @IBOutlet weak var btn_bottom: UIButton!         //底部按钮
    //
    @IBOutlet weak var img_content: UIImageView!     //内容图片
    @IBOutlet weak var lab_contentTitle: UILabel!    //标题
    @IBOutlet weak var lab_contentSalePrice: UILabel!//原价
    @IBOutlet weak var lab_contentVIP: UILabel!      //优惠vip
    @IBOutlet weak var lab_contentRealPrice: UILabel!//实付款
    @IBOutlet weak var lab_orderNumber: UILabel!     //订单号
    @IBOutlet weak var lab_orderCreTime: UILabel!    //创建时间
    @IBOutlet weak var lab_orderPayTime: UILabel!    //付款时间
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //发布按钮
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("客服", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        publishBtn.setTitleColor(UIColor.black, for: .normal)
        publishBtn.addTarget(self, action: #selector(action_server), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        //UI
        btn_state.layer.cornerRadius = 15
        btn_state.layer.borderWidth = 0.5
        btn_state.layer.borderColor = UIColor.white.cgColor
        btn_state.layer.masksToBounds = true
        
        btn_bottom.layer.cornerRadius = 28
        
        img_content.layer.cornerRadius = 5
    }
    
    //客服
    @objc func action_server(){
        
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
