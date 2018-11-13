//
//  HDRootDVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDRootDVC: HDItemBaseVC {

    @IBOutlet weak var bavBarView  : UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar_btn1 : UIButton!
    @IBOutlet weak var navBar_btn2 : UIButton!
    @IBOutlet weak var btn_location: UIButton!
    //menu
    @IBOutlet weak var menu_btn1   : UIButton!
    @IBOutlet weak var menu_btn2   : UIButton!
    @IBOutlet weak var menu_btn3   : UIButton!
    @IBOutlet weak var menuLine1   : UIView!
    @IBOutlet weak var menuLine2   : UIView!
    @IBOutlet weak var menuLine3   : UIView!
    
    @IBOutlet weak var dTableView  : UITableView!
    
    var condition1: Int! //1展览，2博物馆
    var condition2: Int! //1热门推荐，2全部，3最近
    
    //mvvm
    var viewModel: RootDViewModel = RootDViewModel()
    
    var exhibitionArr: [HDSSL_dExhibition] = Array.init() //展览数组
    var museumArr    : [HDSSL_dMuseum]     = Array.init() //博物馆数组
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //刷新选中的城市
        let str: String = UserDefaults.standard.object(forKey: "MyLocationCityName") as! String
        
        if str.count > 0 {
            print("城市\(str)")
            btn_location.setTitle(str, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true

        //MVVM
        bindViewModel()
        
        navBar_btn1.isSelected = true
        condition1 = 1
        condition2 = 1
        menu_btn1.isSelected = true
        menu_btn2.isSelected = false
        
        //定位按钮设置
        btn_location.setImage(UIImage.init(named: "zl_icon_arrow"), for: .normal)
        btn_location.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(btn_location.imageView?.image?.size.width)!, bottom: 0, right: (btn_location.imageView?.image?.size.width)!)
        btn_location.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: (btn_location.titleLabel?.bounds.size.width)!+20, bottom: 0, right: -(btn_location.titleLabel?.bounds.size.width)!)
        btn_location.titleLabel?.lineBreakMode = .byTruncatingTail
        
        self.dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
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

    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //展览数组
        viewModel.exhibitionArray.bind { (Array) in
            
            weakSelf?.exhibitionArr = Array
            
        }
        
        //博物馆数组
        viewModel.museumArray.bind { (Array) in
            
            weakSelf?.museumArr = Array
            
        }
    }

    //MARK: - 展览、博物馆切换
    @IBAction func action_changeMainType(_ sender: UIButton) {
        //tag=0 展览，tag=1 博物馆
        print(sender.tag)
        navBar_btn1.isSelected = !navBar_btn1.isSelected
        
        condition1 = sender.tag + 1 //保存大页面状态
        
        loadMyViews()
        
        dTableView.reloadData()
        
    }
    
    //MARK: - 搜索
    @IBAction func action_search(_ sender: UIButton) {
        //tag=0 普通搜索，tag=1 语音搜索
        print(sender.tag)
    }
    
    //MARK: - 定位
    
    @IBAction func action_location(_ sender: Any) {
        
        let vc: HDSSL_getLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_getLocationVC") as! HDSSL_getLocationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - 热门推荐、全部、最近
    @IBAction func action_changeMenu(_ sender: UIButton) {
        //tag=0 热门推荐、tag=1全部、tag=2最近
        print(sender.tag)
        sender.isSelected = true
        
        if sender.tag == 0 {
            menu_btn2.isSelected = false
            menu_btn3.isSelected = false
            
            menuLine1.isHidden = false
            menuLine2.isHidden = true
            menuLine3.isHidden = true
        }else if sender.tag == 1 {
            menu_btn1.isSelected = false
            menu_btn3.isSelected = false
            
            menuLine1.isHidden = true
            menuLine2.isHidden = false
            menuLine3.isHidden = true
        }else if sender.tag == 2 {
            menu_btn1.isSelected = false
            menu_btn2.isSelected = false
            
            menuLine1.isHidden = true
            menuLine2.isHidden = true
            menuLine3.isHidden = false
        }
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

extension HDRootDVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if condition1 == 1 {
            return (ScreenWidth-40)*188/335 + 110
        }
        return 110
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if condition1 == 1 {
            let cell = HDSSL_dExhibitionCell.getMyTableCell(tableV: tableView) as HDSSL_dExhibitionCell
            
            
            return cell
        } else {
            let cell = HDSSL_dMuseumCell.getMyTableCell(tableV: tableView) as HDSSL_dMuseumCell
            
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if condition1 == 1 {
            //展览详情
            let vc: HDSSL_dExhibitionDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        
        } else {
            //博物馆详情
            let vc: HDSSL_dMuseumDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
