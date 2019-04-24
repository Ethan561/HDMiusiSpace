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

    public var searchContent: String?
    private var take = 10
    private var skip = 0
    var currentType    : Int = 0 //默认0全部搜索,搜索类型1、2、3、4
    var placeholderStr : String? //默认搜索提示信息
    
    var textFeild                     : UITextField! //输入框
    @IBOutlet weak var tagBgView      : UIView!      //标签背景页
    @IBOutlet weak var dTableView     : UITableView! //搜索历史记录
    @IBOutlet weak var resultTableView: UITableView! //搜索结果
    @IBOutlet weak var searcgTagBgView: UIView!
    @IBOutlet weak var tagViewH       : NSLayoutConstraint!
    
    var searchTypeArray: [HDSSL_SearchTag]        = Array.init()  //搜索类型数组
    var resultArray    : [HDSSL_SearchType]       = Array.init()  //搜索结果分类数组
    var newsArray      : [HDSSL_SearchNews]       = Array.init()  //资讯
    var classArray     : [HDSSL_SearchCourse]     = Array.init()  //新知
    var exhibitionArray: [HDSSL_SearchExhibition] = Array.init()  //展览
    var museumArray    : [HDSSL_SearchMuseum]     = Array.init()  //博物馆
    
    var typeTitleArray : [String] = Array.init()  //类型标题
    var historyArray   : [String] = Array.init()  //搜索历史
    
    //mvvm
    var viewModel: HDSSL_SearchViewModel = HDSSL_SearchViewModel()
    
    //语音识别
    lazy var voiceView: HDZQ_VoiceSearchView = {
        let tmp =  Bundle.main.loadNibNamed("HDZQ_VoiceSearchView", owner: nil, options: nil)?.last as? HDZQ_VoiceSearchView
        tmp?.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        return tmp!
    }()
    
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
        self.isShowNavShadowLayer = false
        addRefresh() //刷新
        
        self.viewModel.request_getTags(vc: self) //获取搜索类别
        
        self.dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        self.resultTableView.isHidden = true //先隐藏搜索结果列表
        self.resultTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.voiceView.isHidden = true
        self.voiceView.delegate = self
        kWindow?.addSubview(self.voiceView)
        if searchContent != nil {
            self.textFeild.text = searchContent
            self.func_saveHistory(searchContent!)
            self.currentType = 0
            self.viewModel.request_search(str: searchContent!, skip: 0, take: 10, type: 0, vc: self)
        }
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //标签数组
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
        
        //搜索结果数组
        viewModel.resultArray.bind { (resultArray) in
            
            weakSelf?.refreshTableView(models: resultArray)
        }
    }
    //MARK: - 处理接口数据刷新列表
    func refreshTableView(models:[HDSSL_SearchType]) {
        //显示搜索结果
        self.resultTableView.isHidden = false
        self.textFeild.resignFirstResponder()
        
        if self.currentType == 0 {
            //0时不需要分页，会返回多组数据
            skip = 0
            
            self.resultArray.removeAll()
            
            self.resultArray += models
            
            self.resultTableView.es.stopLoadingMore()
            
            self.dealSearchResultData()
            
            self.resultTableView.reloadData()
            
        }else{
            //选定搜索类型，需要分页，只会返回一组数据
            if models.count > 0 {
                self.resultTableView.es.stopLoadingMore()
                
                let  model :HDSSL_SearchType = models[0]
                
                if model.type == 0 {
                    
                    if model.news_list?.count == 0 {
                        loadNoMore()
                        return
                    }else {
                        if skip == 0 {
                            self.newsArray.removeAll()
                        }
                        newsArray += model.news_list!
                    }
                }else if model.type == 1 {
                    if model.course_list?.count == 0 {
                        loadNoMore()
                        return
                    }else {
                        if skip == 0 {
                            self.classArray.removeAll()
                        }
                        classArray += model.course_list!
                    }
                }else if model.type == 2 {
                    if model.exhibition_list?.count == 0 {
                        loadNoMore()
                        return
                    }else {
                        if skip == 0 {
                            self.exhibitionArray.removeAll()
                        }
                        exhibitionArray += model.exhibition_list!
                    }
                }else if model.type == 3 {
                    if model.museum_list?.count == 0 {
                        loadNoMore()
                        return
                    }else {
                        if skip == 0 {
                            self.museumArray.removeAll()
                        }
                        museumArray += model.museum_list!
                    }
                }
                
                self.resultTableView.reloadData()
                
            }else{
                juageEmptyView()
                
                loadNoMore()
            }
        }

    }
    func loadNoMore(){
        
        self.resultTableView.es.noticeNoMoreData()
        self.resultTableView.reloadData()
    }
    //MARK: ---- 交互逻辑 ----
    //MARK: - 判断空数据页面
    func juageEmptyView(){
        
        if self.currentType == 0 {
            if self.resultArray.count == 0 {
                showEmptyView()
            }
        }else {
            if self.newsArray.count == 0 && self.currentType == 1{
                showEmptyView()
            }
            if self.classArray.count == 0 && self.currentType == 2{
                showEmptyView()
            }
            if self.exhibitionArray.count == 0 && self.currentType == 3{
                showEmptyView()
            }
            if self.museumArray.count == 0 && self.currentType == 4{
                showEmptyView()
            }
        }
    }
    //MARK: - 显示空数据页面
    func showEmptyView()  {
        self.resultTableView.ly_emptyView = EmptyConfigView.NoSearchDataEmptyView()
        self.resultTableView.ly_showEmptyView()
    }
    //MARK: - 处理搜索结果
    func dealSearchResultData(){
        for  i: Int in 0..<self.resultArray.count {
            let model: HDSSL_SearchType = self.resultArray[i]
            
            let modelType: Int = model.type!
            
            if self.currentType == 0{
                switch modelType {
                case 0:
                    newsArray = model.news_list!
                case 1:
                    classArray = model.course_list!
                case 2:
                    exhibitionArray = model.exhibition_list!
                case 3:
                    museumArray = model.museum_list!
                default:
                    return
                }
            }
            
        }
        juageEmptyView()
    }
    //MARK: - 隐藏搜索结果
    func hideSearchResultView() {
        //
        resultTableView.isHidden = true
    }
    
    //MARK: ---- 初始化页面 ----
    //MARK: - 加载类型标签
    func loadTagView() {
        let tagView = HD_SSL_TagView.init(frame: tagBgView.bounds)
        tagView.tagViewType = TagViewType.TagViewTypeSingleSelection
        tagView.titleColorNormal = UIColor.RGBColor(215, 99, 72)
        tagView.borderColor = UIColor.RGBColor(215, 99, 72)
        
        weak var weakSelf = self
        
        tagView.BlockFunc { (array) in
            //1、保存选择标签
            let index: Int = Int(array[0] as! String)!
            
            weakSelf?.searchByTag(index) //搜索某一类型数据
            
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
        let placeholder: String? = (UserDefaults.standard.object(forKey: "SeachPlaceHolder") as? String)
        placeholderStr = placeholder
        
        textFeild = UITextField.init(frame: CGRect.init(x: 20, y: 3, width: view.frame.size.width-20-30, height: 30))
        view.addSubview(textFeild)
        textFeild.tintColor = UIColor.black
        textFeild.clearButtonMode = .whileEditing
        textFeild.returnKeyType = .search
        textFeild.font = UIFont.systemFont(ofSize: 14)
        textFeild.delegate = self
        textFeild.borderStyle = .none
        textFeild.placeholder = placeholder
        
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
            self.dTableView.isHidden = true
            return
        }
        
        if (arr?.count)! > 0 {
            historyArray = Array(arr!) as! [String]
        }else {
            self.dTableView.isHidden = true
        }
        
        //点击空白处隐藏键盘
        let tapGes=UITapGestureRecognizer(target:self,action:#selector(tapTableView))
        tapGes.cancelsTouchesInView=false
        self.dTableView.addGestureRecognizer(tapGes)
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
        
        if historyArray.count > 0 {
            self.dTableView.isHidden = false
        }else {
            self.dTableView.isHidden = true
        }
        
        self.dTableView.reloadData()
    }
    
    //MARK: ---- actions -----
    //MARK: - 选择类型标签
    func searchByTag(_ tagIndex:Int){
        //资讯、新知、展览、博物馆
        self.currentType = tagIndex + 1 //设置搜索类型1、2、3、4
        
        self.textFeild.placeholder = String.init(format: "搜索%@", typeTitleArray[tagIndex])
        
        self.textFeild.becomeFirstResponder()
        
        //选择标签后，标签模块隐藏
        tagViewH.constant = 0
        
        if self.dTableView.isHidden == true {
            for v in searcgTagBgView.subviews {
                v.removeFromSuperview()
            }
        }
        
    }
    //MARK: - 搜索
    @objc func action_search(_ sender: UIButton) {
        if (self.textFeild.text?.count)! > 0 {

            //开始搜索
            self.viewModel.request_search(str: self.textFeild.text!, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(self.textFeild.text!)
        }else if (placeholderStr?.count)! > 0 {
            //搜索提示信息
            self.textFeild.text = placeholderStr
            self.viewModel.request_search(str: placeholderStr!, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(placeholderStr!)
        }
        
    }
    //MARK: - 语音输入
    @objc func action_voice(_ sender: UIButton) {
        let isCanRecord = HDSSL_SearchViewModel.getRecordPermission()
        if isCanRecord == true {
            self.textFeild.resignFirstResponder()
            self.hideSearchResultView()
            self.voiceView.voiceLabel.text = "想搜什么？说说试试"
            self.voiceView.voiceResult = ""
            self.voiceView.isHidden = false
            self.voiceView.gifView?.isHidden = false
            self.voiceView.voiceBtn.isHidden = true
            self.voiceView.startCollectVoice()
        } else {
            HDSSL_SearchViewModel.showAudioAcessDeniedAlert(self)
        }

    }
    //MARK: - 清空搜索历史
    @IBAction func action_cleanSearchHistory(_ sender: UIButton) {
        //清空搜索历史记录
        weak var weakself = self
        
        let tipView: HDSSL_defaultAlertView = HDSSL_defaultAlertView.createViewFromNib() as! HDSSL_defaultAlertView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.blockSelected { (type) in
            if type == 1 {
                weakself!.historyArray.removeAll()
                weakself!.dTableView.reloadData()
                weakself!.dTableView.isHidden = true
                UserDefaults().set(weakself!.historyArray, forKey: SearchHistory)
            }
        }
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
    }
    //MARK: ---- keyboard -----
    //MARK: - 手势隐藏键盘
    @objc func tapTableView() {
        self.textFeild.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFeild.resignFirstResponder()
    }
}

//MARK: ---- 添加刷新机制
extension HDSSL_SearchVC{
    
    func addRefresh() {
//        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
//        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
        
//        self.resultTableView.es.addPullToRefresh(animator: header) { [weak self] in
//            self?.refresh()
//        }
        self.resultTableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.loadMore()
        }
        self.resultTableView.refreshIdentifier = String.init(describing: self)
        self.resultTableView.expiredTimeInterval = 20.0
    }
    
    private func refresh() {
        skip = 0
        requestData()
    }
    
    private func loadMore() {
        if self.currentType == 0 {//0时不需要分页
            self.resultTableView.es.noticeNoMoreData()
            return
        }
        
        skip += 1
        requestData()
    }
    func requestData() {
        //刷新数据请求
        self.viewModel.request_search(str: self.textFeild.text!, skip: skip*take, take: take, type: currentType, vc: self)
    }
}

//MARK: ---- TextfeildDelegate
extension HDSSL_SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideSearchResultView()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textFeild.resignFirstResponder()
            
            if (textField.text?.count)! > 0 {

                //开始搜索
                self.viewModel.request_search(str: textField.text!, skip: 0, take: 10, type: self.currentType, vc: self)
                //保存搜索历史
                self.func_saveHistory(textField.text!)
            }
        }
        return true
    }
}
//MARK: ---- UITableView
extension HDSSL_SearchVC: UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - 获取搜索结果cell数量
    func getTableViewCells(index: Int) -> Int {
        let model: HDSSL_SearchType = self.resultArray[index]
        
        let modelType: Int = model.type!
        
        switch modelType {
        case 0:
            return model.news_num! > 3 ?  4 : (model.news_list?.count)!
//            return min(4, (model.news_list?.count)!)
        case 1:
            return model.course_num! > 3 ?  4 : (model.course_list?.count)!
        case 2:
            return model.exhibition_num! > 3 ?  4 : (model.exhibition_list?.count)!
        case 3:
            return model.museum_num! > 3 ?  4 : (model.museum_list?.count)!
        default:
            return 0
        }
        
    }
    //MARK: - 获取数据model
    func getResultModel(section: Int) -> HDSSL_SearchType {
        
        let model: HDSSL_SearchType = self.resultArray[section]
        
        return model
    }
    
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == dTableView {
            return 1 //搜索历史
        }else {
            if self.currentType == 0 {
                return resultArray.count //搜索结果
            }else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dTableView {
            return historyArray.count
        }else {
            //搜索结果
            if self.currentType == 1 {
                return newsArray.count
            }else if self.currentType == 2 {
                return classArray.count
            }else if self.currentType == 3 {
                return exhibitionArray.count
            }else if self.currentType == 4 {
                return museumArray.count
            }
            //self.currentType = 0
            return self.getTableViewCells(index: section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == dTableView {
            return 44
        }else {
            if indexPath.row == 3 && self.currentType == 0{
                return 44
            }
            return 90
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == dTableView {
            return 0
        }else {
            return 44
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == dTableView {
            return nil
        }else {
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 44))
            view.backgroundColor = UIColor.white
            let headerTitle = UILabel.init(frame: CGRect.init(x: 20, y: 7, width: 200, height: 30))
            
            var title: String?
            
            var typeSel: Int!
            if currentType == 0 {
                typeSel = self.getResultModel(section: section).type
            }else {
                typeSel = currentType - 1
            }
            
            switch typeSel {
            case 0:
                title = "资讯"
            case 1:
                title = "新知"
            case 2:
                title = "展览"
            case 3:
                title = "博物馆"
            default:
                return nil
            }
            
            headerTitle.text = title
            headerTitle.textColor = UIColor.HexColor(0x9B9B9B)
            view.addSubview(headerTitle)
            
            let line = UIView.init(frame: CGRect.init(x: 20, y: 43, width: ScreenWidth-40, height: 0.5))
            line.backgroundColor = UIColor.RGBColor(245, 245, 245)
            view.addSubview(line)
            
            return view
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //
        if tableView == dTableView {
            return 0
        }else {
            if section == resultArray.count-1 {
                return 0
            }
            return 8
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == dTableView {
            return nil
        }else {
            if section == resultArray.count-1 {
                return nil
            }
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 8))
            view.backgroundColor = UIColor.RGBColor(238, 238, 238)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dTableView {
            //搜索历史
            let str: String = historyArray[indexPath.row]
            
            let cell = UITableViewCell.init()
            cell.textLabel?.text = String.init(format: "%@", str)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            
            return cell
        }else {
            //搜索结果
            var typeSel: Int!
            if currentType == 0 {
                let model = self.getResultModel(section: indexPath.section)
                typeSel = model.type
            }else {
                typeSel = currentType - 1
            }
            switch typeSel {
            case 0:
                if indexPath.row == 3 && self.currentType == 0{
                    let cell = UITableViewCell.init()
                    
                    let showMoreBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 38))
                    showMoreBtn.setImage(UIImage.init(named: "wd_icon_yj"), for: .normal)
                    showMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
                    showMoreBtn.setTitle("更多资讯内容", for: .normal)
                    showMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    showMoreBtn.setTitleColor(UIColor.gray, for: .normal)
                    showMoreBtn.tag = typeSel!
                    showMoreBtn.addTarget(self, action: #selector(showMoreSearchResults(_:)), for: .touchUpInside)
                    
                    cell.addSubview(showMoreBtn)
                    
                    cell.selectionStyle = .none
                    return cell
                    
                }else {
                    let news: HDSSL_SearchNews = newsArray[indexPath.row]
                    let cell = HDSSL_newsCell.getMyTableCell(tableV: tableView) as HDSSL_newsCell
                    cell.cell_imgView.kf.setImage(with: URL.init(string: news.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                    cell.tag = indexPath.row
                    cell.cell_titleLab.text = String.init(format: "%@", news.title!)
                    
                    let plat = (news.plat_title == nil ? "" : "|"+news.plat_title!)
                    cell.cell_tipsLab.text = String.init(format:"%@%@", news.keywords!,plat)
                    
                    cell.cell_commentBtn.setTitle(String.init(format: "%d", news.comments!), for: .normal)
                    
                    cell.cell_likeBtn.setTitle(String.init(format: "%d", news.likes!), for: .normal)
                    
                    return cell
                }
    
            case 1:
                if indexPath.row == 3 && self.currentType == 0{
                    let cell = UITableViewCell.init()
                    let showMoreBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 38))
                    showMoreBtn.setImage(UIImage.init(named: "wd_icon_yj"), for: .normal)
                    showMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
                    showMoreBtn.setTitle("更多新知内容", for: .normal)
                    showMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    showMoreBtn.setTitleColor(UIColor.gray, for: .normal)
                    showMoreBtn.tag = typeSel!
                    showMoreBtn.addTarget(self, action: #selector(showMoreSearchResults(_:)), for: .touchUpInside)
                    cell.addSubview(showMoreBtn)
                    cell.selectionStyle = .none
                    return cell
                }else {
                    let course: HDSSL_SearchCourse = classArray[indexPath.row]
                    
                    let cell = HDSSL_ClassCell.getMyTableCell(tableV: tableView)
                    cell?.tag = indexPath.row
                    
                    cell?.cell_imgView.kf.setImage(with: URL.init(string: course.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                    cell?.cell_titleLab.text = String.init(format: "%@", course.title!)
                    cell?.cell_teacherNameLab.text = String.init(format: "%@", course.teacher_name!)
                    
                    let typeimgName = course.file_type == 1 ? "xz_icon_audio_black_default":"xz_icon_video_black_default"
                    cell?.cell_typeImgView.image = UIImage.init(named: typeimgName)
                    cell?.cell_peopleAndTimeLab.text = String.init(format: "%d在学 %d课时", course.purchases!,course.class_num!)
                    if course.is_free == 1 {
                        cell?.cell_priceLab.text = "免费"
                        cell?.cell_priceLab.textColor = UIColor.black
                    }else {
                        cell?.cell_priceLab.text = String.init(format: "¥%@", course.price!)
                    }
                    return cell!
                }
            case 2:
                if indexPath.row == 3 && self.currentType == 0{
                    let cell = UITableViewCell.init()
                    
                    let showMoreBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 38))
                    showMoreBtn.setImage(UIImage.init(named: "wd_icon_yj"), for: .normal)
                    showMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 120, 0, 0)
                    showMoreBtn.setTitle("更多展览内容", for: .normal)
                    showMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    showMoreBtn.setTitleColor(UIColor.gray, for: .normal)
                    showMoreBtn.tag = typeSel!
                    showMoreBtn.addTarget(self, action: #selector(showMoreSearchResults(_:)), for: .touchUpInside)
                    
                    cell.addSubview(showMoreBtn)
                    cell.selectionStyle = .none
                    return cell
                }else {
                    let exhibition: HDSSL_SearchExhibition = exhibitionArray[indexPath.row]
                    
                    let cell = HDSSL_ExhibitionCell.getMyTableCell(tableV: tableView)
                    cell?.tag = indexPath.row
                    cell?.cell_imgView.kf.setImage(with: URL.init(string: exhibition.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                    //标题
                    cell?.cell_titleLab.text = String.init(format: "%@", exhibition.title!)
                    //位置价格
                    var priceStr: String?
                    if exhibition.is_free == 1 {
                        priceStr = "|免费"
                    }else {
                        priceStr = String.init(format: "|%.1f", exhibition.price!)
                    }
                    cell?.cell_locationLab.text = String.init(format: "%@%@", exhibition.address!,priceStr!)
                    //标签
                    cell?.cell_tipBgView.addSubview(self.getImagesWith(arr: exhibition.icon_list!, frame: (cell?.cell_tipBgView.bounds)!))
                    //评分
                    cell?.cell_scoreLab.text = exhibition.star?.string
                    
                    if exhibition.star?.int == 0 {
                        cell?.noStarL.isHidden = false
                    }
                    return cell!
                }
            case 3:
                if indexPath.row == 3 && self.currentType == 0{
                    let cell = UITableViewCell.init()
                    
                    let showMoreBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 140, height: 38))
                    showMoreBtn.setImage(UIImage.init(named: "wd_icon_yj"), for: .normal)
                    showMoreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 130, 0, 0)
                    showMoreBtn.setTitle("更多博物馆内容", for: .normal)
                    showMoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    showMoreBtn.setTitleColor(UIColor.gray, for: .normal)
                    showMoreBtn.tag = typeSel!
                    showMoreBtn.addTarget(self, action: #selector(showMoreSearchResults(_:)), for: .touchUpInside)
                    
                    cell.addSubview(showMoreBtn)
                    cell.selectionStyle = .none
                    return cell
                    
                }else {
                    let museum: HDSSL_SearchMuseum = museumArray[indexPath.row]
                    
                    let cell = HDSSL_MuseumCell.getMyTableCell(tableV: tableView)
                    cell?.tag = indexPath.row
                    cell?.cell_imgView.kf.setImage(with: URL.init(string: museum.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                    //标题
                    cell?.cell_titleLab.text = String.init(format: "%@", museum.title!)
                    //地址
                    cell?.cell_loacationLab.text = String.init(format: "%@", museum.address!)
                    //标签
                    //                cell?.cell_tipBgView.addSubview(self.getImagesWith(arr: museum.icon_list!, frame: (cell?.cell_tipBgView.bounds)!))
                    for imgV in (cell?.cell_tipBgView.subviews)! {
                        imgV.removeFromSuperview()
                    }
                    var x:CGFloat = 0
                    var imgWArr = [CGFloat]()
                    for (i,imgStr) in museum.icon_list!.enumerated() {
                        let imgV = UIImageView()
                        imgV.contentMode = .scaleAspectFit
                        imgV.kf.setImage(with: URL.init(string: imgStr), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
                            
                            var imgSize:CGSize!
                            
                            if img != nil{
                                imgSize = img!.size
                            }else{
                                imgSize = CGSize.init(width: 12, height: 12)
                            }
                            //                    let imgSize = img!.size
                            let imgH: CGFloat = 12
                            let imgW: CGFloat = 12*imgSize.width/imgSize.height
                            imgWArr.append(imgW)
                            if i > 0 {
                                let w = imgWArr[i-1]
                                x = x + w
                            }
                            imgV.frame = CGRect.init(x: x, y: 2, width: imgW, height: imgH)
                            cell?.cell_tipBgView.addSubview(imgV)
                        }
                    }
                    return cell!
                }
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    //加载cell小图标
    func getImagesWith(arr: [String],frame: CGRect) -> UIView {
        //
        let bgView = UIView.init(frame: frame)
        
        for i in 0..<arr.count {
            //
            var size1 = CGSize.zero
            if i > 0 {
                size1 = UIImage.getImageSize(arr[i-1])
            }
            let size = UIImage.getImageSize(arr[i])

            let imgView = UIImageView.init(frame: CGRect.init(x: CGFloat(Int(size1.width/2 + 2) * i), y: 0, width:12 * (size.width/2)/(size.height/2), height: 12))
            imgView.kf.setImage(with: URL.init(string: arr[i]))
            imgView.centerY = bgView.centerY
            bgView.addSubview(imgView)
        }
        return bgView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == dTableView {
            //点击搜索历史，1开始搜索，2刷新搜索历史记录列表
            let str: String = historyArray[indexPath.row]
            textFeild.text = str
            self.viewModel.request_search(str: str, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(str)
        }else {
            //点击查看更多cell
            if indexPath.row == 3 && currentType == 0{
                return
            }
            //进入详情
            var typeSel: Int!
            if currentType == 0 {
                let model = self.getResultModel(section: indexPath.section)
                typeSel = model.type
            }else {
                typeSel = currentType - 1
            }
            
            if typeSel == 0 {
                //资讯
                let news: HDSSL_SearchNews = newsArray[indexPath.row]
                
                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
                vc.topic_id = String(news.article_id!)
                vc.fromRootAChoiceness = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if typeSel == 1 {
                //新知、课程
                let course: HDSSL_SearchCourse = classArray[indexPath.row]
                
//                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
//                vc.courseId = String(course.class_id!)
//                self.navigationController?.pushViewController(vc, animated: true)
                let courseId = String(course.class_id!)
                self.pushCourseListWithBuyInfo(courseId: courseId, vc: self)
            }else if typeSel == 2 {
                //展览
                let exhibition: HDSSL_SearchExhibition = exhibitionArray[indexPath.row]
                //展览详情
                let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
                let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
                
                vc.exhibition_id = exhibition.exhibition_id
                self.navigationController?.pushViewController(vc, animated: true)
            }else if typeSel == 3 {
                //博物馆
                let museum: HDSSL_SearchMuseum = museumArray[indexPath.row]
                //博物馆详情
                let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
                let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
                
                vc.museumId = museum.museum_id!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    //查看更多
    @objc func showMoreSearchResults(_ btn : UIButton) -> Void {
        print(btn.tag)
        //博物馆详情
        let storyBoard = UIStoryboard.init(name: "RootA", bundle: Bundle.main)
        let vc: HDSSL_SearchMoreVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_SearchMoreVC") as! HDSSL_SearchMoreVC
        vc.currentType = btn.tag+1
        vc.searchContent = self.textFeild.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - 返回语音识别结果，开始搜索
extension HDSSL_SearchVC : HDZQ_VoiceResultDelegate {
    func voiceResult(result: String) {
        self.voiceView.isHidden = true
        self.textFeild.text = result
        self.func_saveHistory(result)

        self.viewModel.request_search(str: result, skip: 0, take: 10, type: self.currentType, vc: self)
    }
}
