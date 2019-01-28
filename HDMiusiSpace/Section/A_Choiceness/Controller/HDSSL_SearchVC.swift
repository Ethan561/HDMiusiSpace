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
    var currentType: Int = 0  //当前搜索类型
    
    var textFeild                     : UITextField! //输入框
    @IBOutlet weak var tagBgView      : UIView!      //标签背景页
    @IBOutlet weak var dTableView     : UITableView! //搜索历史记录
    @IBOutlet weak var resultTableView: UITableView! //搜索结果
    @IBOutlet weak var searcgTagBgView: UIView!
    @IBOutlet weak var tagViewH: NSLayoutConstraint!
    
    var searchTypeArray: [HDSSL_SearchTag] = Array.init()  //搜索类型数组
    var resultArray    : [HDSSL_SearchType] = Array.init()  //搜索类型数组
    var newsArray      : [HDSSL_SearchNews] = Array.init()  //资讯
    var classArray     : [HDSSL_SearchCourse] = Array.init()//新知
    var exhibitionArray: [HDSSL_SearchExhibition] = Array.init()//展览
    var museumArray    : [HDSSL_SearchMuseum] = Array.init()//博物馆
    
    var typeTitleArray : [String] = Array.init()  //类型标题
    var historyArray   : [String] = Array.init()  //搜索历史

    //mvvm
    var viewModel: HDSSL_SearchViewModel = HDSSL_SearchViewModel()
    
    var placeholderStr: String? //默认搜素提示信息
    
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
    //刷新列表
    func refreshTableView(models:[HDSSL_SearchType]) {
        //显示搜索结果
        self.resultTableView.isHidden = false
        self.textFeild.resignFirstResponder()
        
        if self.currentType == 0 {//0时不需要分页
            skip = 0
        }
        
        if models.count > 0 {
            if skip == 0 {
                self.resultArray.removeAll()
            }
            self.resultArray += models
            
            self.resultTableView.es.stopPullToRefresh()
            self.resultTableView.es.stopLoadingMore()
            
            self.dealSearchResultData()
        
            self.resultTableView.reloadData()
        }else{
            self.resultArray.removeAll()
            self.resultTableView.es.noticeNoMoreData()
            self.resultTableView.reloadData()
        }
        if self.resultArray.count == 0 {
            self.resultTableView.ly_emptyView = EmptyConfigView.NoSearchDataEmptyView()
            self.resultTableView.ly_showEmptyView()
        }
        
    }
    //MARK: - 处理搜索结果
    func dealSearchResultData(){
        for  i: Int in 0..<self.resultArray.count {
            let model: HDSSL_SearchType = self.resultArray[i]
            
            let modelType: Int = model.type!
            
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
    //MARK: - 隐藏搜索结果
    func hideSearchResultView() {
        //
        resultTableView.isHidden = true
    }
    
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
    //标签搜索
    func searchByTag(_ tagIndex:Int){
        //资讯、新知、展览、博物馆
        self.currentType = tagIndex + 1 //设置搜索类型1、2、3、4

        self.textFeild.placeholder = String.init(format: "搜索%@", typeTitleArray[tagIndex])
        
        self.textFeild.becomeFirstResponder()
        
        //选择标签后，标签模块隐藏
        tagViewH.constant = 0

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
    
    //MARK: - actions
    //搜索
    @objc func action_search(_ sender: UIButton) {
        if (self.textFeild.text?.count)! > 0 {
//            self.currentType = 0 //设置搜索类型
            //开始搜索
            self.viewModel.request_search(str: self.textFeild.text!, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(self.textFeild.text!)
        }else if (placeholderStr?.count)! > 0 {
//            if (placeholderStr?.count)! > 20 {
//                let substr = String((placeholderStr?.prefix(20))!)
//
//                placeholderStr = substr
//            }
            self.textFeild.text = placeholderStr
            self.viewModel.request_search(str: placeholderStr!, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(placeholderStr!)
        }
        
    }
    //语音输入
    @objc func action_voice(_ sender: UIButton) {
        self.textFeild.resignFirstResponder()
        self.hideSearchResultView()
        self.voiceView.voiceLabel.text = "想搜什么？说说试试"
        self.voiceView.voiceResult = ""
        self.voiceView.isHidden = false
        self.voiceView.gifView?.isHidden = false
        self.voiceView.voiceBtn.isHidden = true
        self.voiceView.startCollectVoice()
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFeild.resignFirstResponder()
    }
}
extension HDSSL_SearchVC{
    
    func addRefresh() {
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        var footer: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
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
//MARK: TextfeildDelegate
extension HDSSL_SearchVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.hideSearchResultView()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textFeild.resignFirstResponder()
            
            if (textField.text?.count)! > 0 {
//                self.currentType = 0 //设置搜索类型
                //开始搜索
                self.viewModel.request_search(str: textField.text!, skip: 0, take: 10, type: self.currentType, vc: self)
                //保存搜索历史
                self.func_saveHistory(textField.text!)
            }
            
        }
        
        return true
    }
}
//MARK: UITableView
extension HDSSL_SearchVC: UITableViewDelegate,UITableViewDataSource {
    
    //获取搜索结果cell数量
    func getTableViewCells(index: Int) -> Int {
        let model: HDSSL_SearchType = self.resultArray[index]
        
        let modelType: Int = model.type!
        
        switch modelType {
        case 0:
            
            return min(3, (model.news_list?.count)!)
        case 1:
        
            return min(3, (model.course_list?.count)!)
        case 2:
        
            return min(3, (model.exhibition_list?.count)!)
        case 3:
        
            return min(3, (model.museum_list?.count)!)
        default:
            return 0
        }
        
    }
    
    func getResultModel(section: Int) -> HDSSL_SearchType {
        
        let model: HDSSL_SearchType = self.resultArray[section]
        
        return model
    }
    
    //MARK: ----- myTableView ----
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == dTableView {
            return 1 //搜索历史
        }else {
            return resultArray.count //搜索结果
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dTableView {
            return historyArray.count
        }else {
            return self.getTableViewCells(index: section)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == dTableView {
            return 44
        }else {
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
            
            switch self.getResultModel(section: section).type {
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
            let model = self.getResultModel(section: indexPath.section)
            
            switch model.type {
            
            case 0:
                let list = model.news_list
                let news: HDSSL_SearchNews = list![indexPath.row]
                
                let cell = HDSSL_newsCell.getMyTableCell(tableV: tableView) as HDSSL_newsCell
                cell.cell_imgView.kf.setImage(with: URL.init(string: news.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                cell.tag = indexPath.row
                
                cell.cell_titleLab.text = String.init(format: "%@", news.title!)
                
                let plat = (news.plat_title == nil ? "" : "|"+news.plat_title!)
                cell.cell_tipsLab.text = String.init(format:"%@%@", news.keywords!,plat)
                
                cell.cell_commentBtn.setTitle(String.init(format: "%d", news.comments!), for: .normal)
                
                cell.cell_likeBtn.setTitle(String.init(format: "%d", news.likes!), for: .normal)
                
                return cell
                
            case 1:
                let list = model.course_list
                let course: HDSSL_SearchCourse = list![indexPath.row]
                
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
                
            case 2:
                let list = model.exhibition_list
                let exhibition: HDSSL_SearchExhibition = list![indexPath.row]
                
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
                
                return cell!
                
            case 3:
                let list = model.museum_list
                let museum: HDSSL_SearchMuseum = list![indexPath.row]
                
                let cell = HDSSL_MuseumCell.getMyTableCell(tableV: tableView)
                cell?.tag = indexPath.row
                cell?.cell_imgView.kf.setImage(with: URL.init(string: museum.img!), placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
                //标题
                cell?.cell_titleLab.text = String.init(format: "%@", museum.title!)
                //地址
                cell?.cell_loacationLab.text = String.init(format: "%@", museum.address!)
                //标签
                cell?.cell_tipBgView.addSubview(self.getImagesWith(arr: museum.icon_list!, frame: (cell?.cell_tipBgView.bounds)!))
                
                return cell!
                
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

            let imgView = UIImageView.init(frame: CGRect.init(x: CGFloat(Int(size1.width/2 + 2) * i), y: 0, width:18 * (size.width/2)/(size.height/2), height: 18))
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
            //
            self.viewModel.request_search(str: str, skip: 0, take: 10, type: self.currentType, vc: self)
            //保存搜索历史
            self.func_saveHistory(str)
        }else {
            //进入详情
            let model = self.getResultModel(section: indexPath.section)
            if model.type == 0 {
                //资讯
                let list = model.news_list
                let news: HDSSL_SearchNews = list![indexPath.row]
                
                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_TopicDetail_VC") as! HDLY_TopicDetail_VC
                vc.topic_id = String(news.article_id!)
                vc.fromRootAChoiceness = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if model.type == 1 {
                //新知、课程
                let list = model.course_list
                let course: HDSSL_SearchCourse = list![indexPath.row]
                
                let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_CourseDes_VC") as! HDLY_CourseDes_VC
                vc.courseId = String(course.class_id!)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.type == 2 {
                //展览
                let list = model.exhibition_list
                let exhibition: HDSSL_SearchExhibition = list![indexPath.row]
                //展览详情
                let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
                let vc: HDSSL_dExhibitionDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dExhibitionDetailVC") as! HDSSL_dExhibitionDetailVC
                
                vc.exhibition_id = exhibition.exhibition_id
                self.navigationController?.pushViewController(vc, animated: true)
            }else if model.type == 3 {
                //博物馆
                let list = model.museum_list
                let museum: HDSSL_SearchMuseum = list![indexPath.row]
                //博物馆详情
                let storyBoard = UIStoryboard.init(name: "RootD", bundle: Bundle.main)
                let vc: HDSSL_dMuseumDetailVC = storyBoard.instantiateViewController(withIdentifier: "HDSSL_dMuseumDetailVC") as! HDSSL_dMuseumDetailVC
                
                vc.museumId = museum.museum_id!
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
    
}

extension HDSSL_SearchVC : HDZQ_VoiceResultDelegate {
    func voiceResult(result: String) {
        self.voiceView.isHidden = true
        self.textFeild.text = result
        self.func_saveHistory(result)
//        self.currentType = 0
        self.viewModel.request_search(str: result, skip: 0, take: 10, type: self.currentType, vc: self)
    }
}
