//
//  HDSSL_commentListVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/21.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentListVC: HDItemBaseVC {

    var listType: Int?  //1全部，2有图
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
    }
    
    func loadMyViews() {
        self.title = "全部评论"
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
