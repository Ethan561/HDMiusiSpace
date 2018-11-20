//
//  HDSSL_commentSucVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentSucVC: HDItemBaseVC {

    @IBOutlet weak var btn_sharePaper: UIButton!
    @IBOutlet weak var btn_shareMyComment: UIButton!
    @IBOutlet weak var dTableView: UITableView!
    
    override func viewDidLoad() {
        isHideBackBtn = true
        super.viewDidLoad()

        loadMyView()
        
    }
    func loadMyView(){
        self.title = "评论成功"
        
        
        let closeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        closeBtn.setTitleColor(UIColor.black, for: .normal)
        closeBtn.addTarget(self, action: #selector(action_close), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: closeBtn)
        self.navigationItem.rightBarButtonItem = item
        
        btn_shareMyComment.layer.borderColor = UIColor.HexColor(0xE8593E).cgColor
        btn_shareMyComment.layer.borderWidth = 1.0
        
    }
    @objc func action_close(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_sharePaper(_ sender: Any) {
        
    }
    @IBAction func action_shareMyComment(_ sender: Any) {
        
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
