//
//  HDRootDVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootDVC: HDItemBaseVC {

    @IBOutlet weak var bavBarView: UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar_btn1: UIButton!
    @IBOutlet weak var navBar_btn2: UIButton!
    @IBOutlet weak var dTableView: UITableView!
    
    var condition1: Int! //1展览，2博物馆
    var condition2: Int! //1热门推荐，2全部，最近
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true

        navBar_btn1.isSelected = true
        condition1 = 1
        condition2 = 2
        
        
        loadMyViews()
    }
    
    //MARK: - init
    func loadMyViews() -> Void {
        //
        if navBar_btn1.isSelected == true {
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
        }else {
            navBar_btn2.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 34)!
            navBar_btn2.setTitleColor(UIColor.HexColor(0x333333), for: .normal)
            
            navBar_btn1.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 25)!
            navBar_btn1.setTitleColor(UIColor.HexColor(0x999999), for: .normal)
        }
        
        
    }


    //MARK: - 展览、博物馆切换
    @IBAction func action_changeMainType(_ sender: UIButton) {
        //tag=0 展览，tag=1 博物馆
        print(sender.tag)
        navBar_btn1.isSelected = !navBar_btn1.isSelected
        
        condition1 = sender.tag + 1 //保存大页面状态
        
        loadMyViews()
    }
    
    //MARK: - 搜索
    @IBAction func action_search(_ sender: UIButton) {
        //tag=0 普通搜索，tag=1 语音搜索
        print(sender.tag)
    }
    
    //MARK: - 定位
    
    @IBAction func action_location(_ sender: Any) {
        
    }
    
    //MARK: - 热门推荐、全部、最近
    @IBAction func action_changeMenu(_ sender: UIButton) {
        //tag=0 热门推荐、tag=1全部、tag=2最近
        print(sender.tag)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
