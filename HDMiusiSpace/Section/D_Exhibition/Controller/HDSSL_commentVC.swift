//
//  HDSSL_commentVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentVC: HDItemBaseVC {

    var exdataModel: ExhibitionDetailDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UI
        loadMyViews()
        //Data
        
    }
    
    func loadMyViews() {
        self.title = "评论"
        
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        publishBtn.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
        publishBtn.addTarget(self, action: #selector(action_publish), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
    }

    @objc func action_publish(){
        print("发布")
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
