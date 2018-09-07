//
//  HDSSL_SearchVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_SearchVC: HDItemBaseVC {

    var textFeild: UITextField!
    
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

        loadSearchBar()
    }
    
    //MARK: -- 自定义导航栏
    func loadSearchBar() {
        //
//        let navLeftSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
//        navLeftSpace.width = -17
//        //
//        let backBtn = UIButton.init(frame: CGRect.init(x: -10, y: 0, width: 0.1, height: 0.1))
//        backBtn.backgroundColor = UIColor.white
//        //
//        let backItem = UIBarButtonItem.init(customView: backBtn)
//        self.navigationItem.leftBarButtonItems = nil //[navLeftSpace,backItem]
//        self.navigationItem.hidesBackButton = true
        
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage.init(named: "search_icon_search_big_default"), for: .normal)
        rightBtn.addTarget(self, action: #selector(action_search(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        //bg
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth-120, height: 35))
        view.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        //搜索图标
        let imgView = UIImageView.init(frame: CGRect.init(x: 3, y: 11.5, width: 14, height: 14))
        imgView.image = UIImage.init(named: "search_icon_search_small_default")
        view.addSubview(imgView)
        
        //输入
        textFeild = UITextField.init(frame: CGRect.init(x: 20, y: 3, width: view.frame.size.width-20-30, height: 30))
        view.addSubview(textFeild)
        textFeild.tintColor = UIColor.black
        textFeild.clearButtonMode = .whileEditing
        textFeild.returnKeyType = .search
        textFeild.font = UIFont.systemFont(ofSize: 14)
        textFeild.delegate = self
        textFeild.borderStyle = .none
        textFeild.placeholder = "杨家成霸道口语课"
        
        //语音按钮
        let voiceBtn = UIButton.init(frame: CGRect.init(x: view.frame.size.width-35, y: 0, width: 24, height: 35))
        voiceBtn.setImage(UIImage.init(named: "search_icon_Voice_default"), for: .normal)
        voiceBtn.addTarget(self, action: #selector(action_voice(_:)), for: .touchUpInside)
        view.addSubview(voiceBtn)
        
        self.navigationItem.titleView = view
        
        
    }

    @objc func action_search(_ sender: UIButton) {
        
    }
    @objc func action_voice(_ sender: UIButton) {
        
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
extension HDSSL_SearchVC: UITextFieldDelegate {
    
}
