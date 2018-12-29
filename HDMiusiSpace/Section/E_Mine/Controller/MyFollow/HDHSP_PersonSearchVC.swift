//
//  HDHSP_PersonSearchVC.swift
//  HDMiusiSpace
//
//  Created by HDHaoShaoPeng on 2018/12/19.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
//import ESPullToRefresh

class HDHSP_PersonSearchVC: HDItemBaseVC {

    private var dataArr =  [FollowPerModel]()
    
    private var viewModel = HDZQ_MyViewModel()
    private var take = 10
    private var skip = 0
    
    lazy var searchBar:UITextField = {
        let curr = UITextField.init()
        curr.delegate = self
        return curr
    }()
    
    lazy var tableView: UITableView = {
        let tableView:UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-44), style: UITableViewStyle.plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.backgroundColor = UIColor.HexColor(0xF1F1F1)
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - kTopHeight)
        view.addSubview(self.tableView)
        tableView.register(UINib.init(nibName: "HDZQ_MyFollowCell", bundle: nil), forCellReuseIdentifier: "HDZQ_MyFollowCell")
        //addRefresh()
        bindViewModel()
        
        loadSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //requestData()
    }
    
    //MARK: 初始化导航条
    func loadSearchBar()  {
        let shareBtn = UIButton.init(type: UIButton.ButtonType.custom)
        //let width = HDDeclare.getTranslate(str: "common_cancle") .getContentWidth(font: UIFont.systemFont(ofSize: 18.0))
        shareBtn.frame = CGRect.init(x: 0, y: 0, width: 50, height: 45)
        
        
        //shareBtn.setTitleColor(UIColor.white, for: .normal)
        shareBtn.setImage(UIImage.init(named: "search_icon_search_small_default"), for: .normal)
        shareBtn.addTarget(self, action: #selector(searchAction), for: UIControl.Event.touchUpInside)
        let shareBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: shareBtn)
        navigationItem.rightBarButtonItem = shareBarButtonItem
        
        navigationItem.hidesBackButton = true
        searchBar.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth - 50, height: 30)
        searchBar.layer.masksToBounds = true
        searchBar.layer.cornerRadius = 10.0
        searchBar.backgroundColor = UIColor.HexColor(0xefefef)
        searchBar.font = UIFont.systemFont(ofSize: 15)
        searchBar.attributedPlaceholder = NSAttributedString.init(string: "请输入昵称或者ID", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.darkGray])//HDDeclare.getTranslate(str: "search_hint")
        searchBar.delegate = self
        searchBar.returnKeyType = .search
        searchBar.textColor = UIColor.black
        let clearButton:UIButton = UIButton.init(type: .custom)
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        clearButton.setImage(UIImage.init(named: "search_back"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        let searchImage:UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //searchImage.inset
        searchImage.image = UIImage.init(named: "search_icon_search_small_default")
        searchBar.leftView = searchImage
        searchBar.leftViewMode = .always
        searchBar.rightView = clearButton
        searchBar.rightViewMode = .whileEditing
        searchBar.addTarget(self, action: #selector(tfContentChanged(tf:)), for: .editingChanged)
        navigationItem.titleView = searchBar
        
        navigationItem.title = ""
    }

    @objc func searchAction() {
        self.navigationController?.view.endEditing(true)
        requestData(keyWords: searchBar.text ?? "")
    }
    
    @objc func clearAction(){
        searchBar.text = ""
//        ishideSearchResultView(true)
    }
    
    @objc func tfContentChanged(tf:UITextField){
//        if tf.text == "" {
//            ishideSearchResultView(true)
//        }
    }
    
    //MARK: 添加刷新
    func requestData(keyWords:String) {
        viewModel.requestSearchResults(apiToken: HDDeclare.shared.api_token ?? "", keywords: keyWords, skip: skip, take: take, vc: self)
    }
    
    func bindViewModel() {
        viewModel.searchResults.bind { [weak self] (models) in
            
            if (self?.skip)! > 0 {
                self?.dataArr.append(contentsOf: models)
            } else {
                self?.dataArr = models
            }
            if (self?.dataArr.count)! > 0 {
                self?.tableView.reloadData()
            } else {
                self?.tableView.reloadData()
                self?.tableView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
                self?.tableView.ly_showEmptyView()
            }
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if models.count == 0 {
                self?.tableView.es.noticeNoMoreData()
            }
            
            
        }
    }
    
//    func addRefresh() {
//        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
//        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
//        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
//        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
//
//        self.tableView.es.addPullToRefresh(animator: header) { [weak self] in
//            self?.refresh()
//        }
//        self.tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
//            self?.loadMore()
//        }
//        self.tableView.refreshIdentifier = String.init(describing: self)
//        self.tableView.expiredTimeInterval = 20.0
//    }
//
//    private func refresh() {
//        skip = 0
//        requestData()
//    }
//
//    private func loadMore() {
//        skip = skip + take
//        requestData()
//    }
}



extension HDHSP_PersonSearchVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        if textField.text == holdStr {
        //            textField.text = ""
        //        }
        //        else if textField.text == ""{
        //            textField.text = holdStr
        //        }
    }
    
    
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.navigationController?.view.endEditing(true)
        requestData(keyWords: textField.text ?? "")
        //        guard (textField.text?.count)! < 10 else {
        //            return true
        //        }
        
//        if textField.text != "" {
//            //调用搜索接口
//            self.request_searchStr(textField.text!)
//            //保存搜索历史
//            self.func_saveHistory(textField.text!)
//        }
//        else{
//
//        }
//
//        view.endEditing(true)
//        textField.resignFirstResponder()
        return true
    }
}


extension HDHSP_PersonSearchVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_MyFollowCell") as? HDZQ_MyFollowCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("HDZQ_MyFollowCell", owner: nil, options: nil)?.last as? HDZQ_MyFollowCell
        }
        cell?.setCellWithModel(model: model)
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "RootE", bundle: Bundle.main)
        let vc: HDZQ_OthersCenterVC = storyBoard.instantiateViewController(withIdentifier: "HDZQ_OthersCenterVC") as! HDZQ_OthersCenterVC
        let model = dataArr[indexPath.row]
        vc.toid = model.uid
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
