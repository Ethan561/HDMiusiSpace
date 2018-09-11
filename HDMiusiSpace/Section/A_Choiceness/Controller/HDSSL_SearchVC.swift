//
//  HDSSL_SearchVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/9/6.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

let SearchHistory : String = "SearchHistory"

class HDSSL_SearchVC: HDItemBaseVC {

    var textFeild: UITextField!  //输入框
    @IBOutlet weak var tagBgView: UIView! //标签背景页
    @IBOutlet weak var dTableView: UITableView!
    
    var searchTypeArray: [HDSSL_SearchTag] = Array.init() //搜索类型数组
    var typeTitleArray : [String] = Array.init()  //类型标题
    var historyArray   : [String] = Array.init()  //搜索历史
    
    //mvvm
    var viewModel: HDSSL_SearchViewModel = HDSSL_SearchViewModel()
    
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

        //MVVM
        bindViewModel()
        
        loadSearchBar()
        
        loadSearchHistory()
        
        self.viewModel.request_getTags(vc: self)
        
        self.dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        viewModel.tagArray.bind { (typeArray) in
            
            weakSelf?.searchTypeArray = typeArray  //返回标签数据，需要保存到本地

            self.typeTitleArray.removeAll() //类型标题clear
            
            //显示标签标题
            for i:Int in 0..<(weakSelf?.searchTypeArray.count)! {
                let tagmodel = weakSelf?.searchTypeArray[i]
                weakSelf?.typeTitleArray.append((tagmodel?.title)!)
            }
            
            weakSelf?.loadTagView() //加载tag view
        }
    }
    //MARK: - 加载类型标签
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        tagView.titleColorNormal = UIColor.RGBColor(215, 99, 72)
        tagView.borderColor = UIColor.RGBColor(215, 99, 72)
        tagView.BlockFunc { (array) in
            //1、保存选择标签
            print(array)
            for i: Int in 0..<array.count {
                let index : Int = Int(array[i] as! String)! //标签下标
                //                let str : String = self.tagStrArray[index] //
                
            }
        }
        tagView.titleArray = typeTitleArray
        
        tagBgView.addSubview(tagView)
        tagView.loadNormalTagsView()
    }
    //MARK: - 自定义导航栏
    func loadSearchBar() {
        //搜索btn
        let rightBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBtn.setImage(UIImage.init(named: "search_icon_search_big_default"), for: .normal)
        rightBtn.addTarget(self, action: #selector(action_search(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
        //TitleView
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
    
    //MARK: - 加载搜搜历史
    func loadSearchHistory() {
        let manager = UserDefaults()
        let arr: [Any]? =  manager.array(forKey: SearchHistory)
        
        guard arr != nil else {
            return
        }
        
        if (arr?.count)! > 0 {
            historyArray = Array(arr!) as! [String]
        }
        
    }
    
    //MARK: - 本地保存搜索历史
    func func_saveHistory(_ searchStr: String) -> Void {
        //去重、最多保存10条
        var array = historyArray
        
        if array.contains(searchStr) {
            let inde = array.index(of: searchStr)
            array.remove(at: inde!)
        }
        
        array.insert(searchStr, at: 0)
        
        if array.count > 10 {
            
            let lastedArray = Array(array[0..<10])
            historyArray = lastedArray
        }else {
            historyArray = array
        }
        print(historyArray)
        
        UserDefaults().set(historyArray, forKey: SearchHistory)
        
        self.dTableView.reloadData()
    }
    
    //MARK: - actions
    //搜索
    @objc func action_search(_ sender: UIButton) {
        
    }
    //语音输入
    @objc func action_voice(_ sender: UIButton) {
        
    }
    @IBAction func action_cleanSearchHistory(_ sender: UIButton) {
        historyArray.removeAll()
        self.dTableView.reloadData()
        UserDefaults().set(historyArray, forKey: SearchHistory)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textFeild.resignFirstResponder()
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
//MARK: TextfeildDelegate
extension HDSSL_SearchVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textFeild.resignFirstResponder()
            
            if (textField.text?.count)! > 0 {
                self.viewModel.request_search(str: textField.text!, skip: 0, take: 10, type: 0, vc: self)
                //保存搜索历史
                self.func_saveHistory(textField.text!)
            }
            
        }
        
        return true
    }
}
//MARK: UITableView
extension HDSSL_SearchVC: UITableViewDelegate,UITableViewDataSource {
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let str: String = historyArray[indexPath.row]
        
        let cell = UITableViewCell.init()
        cell.textLabel?.text = String.init(format: "%@", str)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let str: String = historyArray[indexPath.row]
        textFeild.text = str
        self.viewModel.request_search(str: str, skip: 0, take: 10, type: 0, vc: self)
        //保存搜索历史
        self.func_saveHistory(str)
    }
    
    
}
