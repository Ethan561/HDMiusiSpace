//
//  HDSSL_getLocationVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_getLocationVC: HDItemBaseVC {
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var menu_btn1: UIButton!
    @IBOutlet weak var menu_btn2: UIButton!
    @IBOutlet weak var menu_line1: UIImageView!
    @IBOutlet weak var menu_line2: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        
        loadMyViews()
    }
    
    func loadMyViews() {
        menu_btn1.isSelected = true
        menu_btn2.isSelected = false
        menu_line1.isHidden = false
        menu_line2.isHidden = true
    }
    func refreshMenu() {
        if menu_btn1.isSelected == true {
            menu_btn1.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            menu_btn2.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
            menu_line1.isHidden = false
            menu_line2.isHidden = true
        }else {
            menu_btn2.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            menu_btn1.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
            menu_line2.isHidden = false
            menu_line1.isHidden = true
        }
    }
    
    @IBAction func action_tapMenuButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            menu_btn2.isSelected = false
        }else {
            menu_btn1.isSelected = false
        }
        refreshMenu()
    }
    
    
    @IBAction func action_close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
