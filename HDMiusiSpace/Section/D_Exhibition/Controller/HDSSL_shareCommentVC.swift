//
//  HDSSL_shareCommentVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_shareCommentVC: HDItemBaseVC {

    @IBOutlet weak var largeImgView: UIImageView!
    @IBOutlet weak var btn_share: UIButton!
    var imgPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.largeImgView.kf.setImage(with: URL.init(string: self.imgPath!), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    @IBAction func action_shareImg(_ sender: Any) {
        //分享
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
