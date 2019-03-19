//
//  HDSSL_getLocationVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import SnapKit

private let nomalCell = "nomalCell"
private let hotCityCell = "hotCityCell"
private let recentCell = "rencentCityCell"
private let currentCell = "currentCityCell"

let recentCityArrayKey : String = "recentCityArrayKey"


class HDSSL_getLocationVC: HDItemBaseVC {
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    
    //search
    @IBOutlet weak var seaarchT: UITextField!
    
    @IBOutlet weak var dBgView: UIView!
    @IBOutlet weak var menu_btn1: UIButton!
    @IBOutlet weak var menu_btn2: UIButton!
    @IBOutlet weak var menu_line1: UIImageView!
    @IBOutlet weak var menu_line2: UIImageView!
    
    var cityDataArray: [CitiesModel] = Array.init() //搜索类型数组
    var recentArray  : [CityModel]   = Array.init() //最近
    var hotArray     : [CityModel]   = Array.init() //热门
    var titleArray   : [String]      = Array.init() //索引标题
    var searchArray  : [CityModel]   = Array.init() //搜索结果城市
    
    //国际
    var worldTypeArray : [CountyTypeListModel]    = Array.init() //大洲
    var countyArray    : [CountyListModel]    = Array.init() //国家
    var currentLeftType: Int = 0 //当前类型
    
    //mvvm
    var viewModel: HDSSL_locationViewModel = HDSSL_locationViewModel()
    
    /// 主配色
    let mainColor = UIColor.HexColor(0x707070)
    
    /// 表格
    lazy var dTableView: UITableView = UITableView(frame: dBgView.bounds, style: .plain)
    
    /// 国际/港澳台
    lazy var worldLocView: HDSSL_worldLocView = HDSSL_worldLocView.init(frame: dBgView.bounds)
    
    //搜索结果
    lazy var searchresultView = HD_searchResultView.init(frame: CGRect.init(x: 0, y: kTopHeight, width: ScreenWidth, height: ScreenHeight-kTopHeight))
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dTableView.frame = dBgView.bounds
        worldLocView.frame = dBgView.bounds
        searchresultView.frame = CGRect.init(x: 0, y: kTopHeight, width: ScreenWidth, height: ScreenHeight-kTopHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        dBgView.isUserInteractionEnabled = true
        //MVVM
        bindViewModel()
        
        //UI
        loadMyViews()
        setupWorldLocView()   //国际
        setupTableView()      //国内
        setSearchResultView() //搜索结果
        
        //search
        seaarchT.delegate = self
        
        //data
        loadMyDatas()
        viewModel.request_getCityList(type: 2, vc: self) //请求国内城市数据
        viewModel.request_getWorldCityList(kind: 2, type: 0, isrecommand: true, vc: self) //请求国际数据
        self.dTableView.ccpIndexView()
    }
    
    func loadMyDatas() {
        
        //
        let manager = UserDefaults()
        let storedData:Data?  = manager.object(forKey: recentCityArrayKey) as?  Data
        guard storedData != nil else {
            return
        }
        do {
            let arr = try JSONDecoder().decode([CityModel].self, from: storedData!)
            if arr.count > 0 {
                for city in arr {
                    recentArray.append(city)
                }
            }
        }
        catch let error {
            LOG("\(error)")
        }

 
    }
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //所有城市
        viewModel.cityArray.bind { (typeArray) in
            
            guard typeArray.count > 0 else {
                return
            }
            
            weakSelf?.cityDataArray = typeArray
            
            weakSelf?.initTitleArrayWith(typeArray)
            
        }
        
        //热门城市
        viewModel.hotAray.bind { (hots) in
            guard hots.count > 0 else {
                return
            }
            weakSelf?.hotArray = hots
        }
        
        //刷新列表
        weakSelf?.dTableView.reloadData()
        
        /////国际城市
        viewModel.leftTableList.bind { (leftTitles) in
            //大洲
            guard leftTitles.count > 0 else {
                return
            }
            
            weakSelf?.worldLocView.leftTitleArray = leftTitles
            
            weakSelf?.worldLocView.refreshTable(1)
        }
        
        viewModel.countyList.bind { (counties) in
            //国家
            guard counties.count > 0 else {
                return
            }
            
            weakSelf?.worldLocView.hotArray = counties
            //刷新国际页面
            weakSelf?.worldLocView.refreshTable(2)
        }
        
        //搜索结果
        viewModel.searchResultA.bind { (array) in
            //城市
//            guard array.count > 0 else {
//                return
//            }
            
            weakSelf?.searchArray = array
            weakSelf?.searchresultView.cityArray = array
            //刷新搜索结果页面
            weakSelf?.searchresultView.dTableView.reloadData()
            
        }
        
    }
    
    //标题数组
    private func initTitleArrayWith(_ titleArr: [CitiesModel]) {
        
        titleArray.removeAll()
        
        for i in 0..<titleArr.count {
            let model: CitiesModel = titleArr[i]
            titleArray.append(model.key_name!)
        }
        // 标题排序
        titleArray.sort()
        titleArray.insert("热门", at: 0)
        titleArray.insert("最近", at: 0)
        titleArray.insert("定位", at: 0)
        
        dTableView.reloadData()
    }
    
    //国内
    private func setupTableView() {
        // 设置tableView
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.register(UITableViewCell.self, forCellReuseIdentifier: nomalCell)
        dTableView.register(RecentCitiesTableViewCell.self, forCellReuseIdentifier: recentCell)
        dTableView.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
        dTableView.register(HotCityTableViewCell.self, forCellReuseIdentifier: hotCityCell)
        dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        // 右边索引
        dTableView.sectionIndexColor = mainColor
        dTableView.sectionIndexTrackingBackgroundColor = UIColor.HexColor(0x999999)
        dTableView.sectionIndexBackgroundColor = UIColor.clear
        dBgView.addSubview(dTableView)
    }
    
    //国际/港澳台
    private func setupWorldLocView() {
        
        dBgView.addSubview(worldLocView)
        weak var weakSelf = self
        
        worldLocView.BlockLeftFunc { (index) in
            print(index)
            //切换左侧类型
            if weakSelf?.currentLeftType == index {
                return
            }
            weakSelf?.worldLocView.hotArray.removeAll()
            //刷新国际页面
            weakSelf?.worldLocView.refreshTable(2)
            weakSelf?.currentLeftType = index
            weakSelf?.viewModel.request_getWorldCityList(kind: 2, type: index, isrecommand: index == 0 ? true : false, vc: self)
        }
        
        worldLocView.BlockRightFunc { (city) in
            print(city)
            //保存选中城市，返回首页
            self.backUP()
        }
    }
    
    //搜索结果
    func setSearchResultView()  {
        self.view.addSubview(searchresultView)
        searchresultView.isHidden = true
        searchresultView.BlockDidFunc { (index) in
            let city = self.searchArray[index]
            
            //保存选中城市，返回首页
            UserDefaults.standard.set(city.city_title, forKey: "MyLocationCityName")
            UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
            UserDefaults.standard.synchronize()
            
            var c = CityModel()
            c.city_id = city.city_id
            c.city_name = city.city_title
            self.saveRecentCityArr(c)
            
            //保存选中城市，返回首页
            self.backUP()
        }
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
            dBgView.bringSubview(toFront: dTableView)
        }else {
            menu_btn1.isSelected = false
            dBgView.bringSubview(toFront: worldLocView)
        }
        refreshMenu()
    }
    
    
    @IBAction func action_close(_ sender: Any) {
        self.backUP()
    }
    func backUP() {
        //保存选中城市，返回首页
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension HDSSL_getLocationVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 2 {
            
            let citiesModel: CitiesModel = cityDataArray[section-3]
            
            return (citiesModel.city_list?.count)!
        }
        return 1
    }

    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath)
            cell.backgroundColor = cellColor
            return cell

        }else if indexPath.section == 1 {

            let cell = tableView.dequeueReusableCell(withIdentifier: recentCell, for: indexPath) as! RecentCitiesTableViewCell
            
            cell.recentArray = recentArray
            cell.setupUI()
            cell.BlockTapHomeRecentItemFunc { (city) in
                print(city.city_name!) //点击最近城市，本地保存，返回首页
                //本地保存国家，返回首页
                var c = HDSSL_selectedCity()
                c.city_id = city.city_id
                c.city_name = city.city_name
                
                UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
                UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
                UserDefaults.standard.synchronize()
//                LOG("city.city_name: \(city.city_name)")
                self.saveRecentCityArr(city)
                
                //保存选中城市，返回首页
                self.backUP()
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 2 {

            let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
            cell.hotArray = hotArray
            cell.setupUI()
            cell.BlockTapHomeHotItemFunc { (city) in
                print(city.city_name!) //点击热门城市，本地保存，返回首页
                //本地保存国家，返回首页
                var c = HDSSL_selectedCity()
                c.city_id = city.city_id
                c.city_name = city.city_name
                
                self.saveRecentCityArr(city)
                
                UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
                UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
                UserDefaults.standard.synchronize()
                //保存选中城市，返回首页
                self.backUP()
            }
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath)
            
            let citiesModel: CitiesModel = cityDataArray[indexPath.section-3]
            let city:CityModel = citiesModel.city_list![indexPath.row]
            
            cell.textLabel?.text = String.init(format: "%@", city.city_name!)
            
            return cell
        }
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        print("点击了 \(cell?.textLabel?.text ?? "")") //点击列表城市，本地保存，返回首页
        
        if indexPath.section < 3 {
            return
        }
        
        let citiesModel: CitiesModel = cityDataArray[indexPath.section-3]
        let city:CityModel = citiesModel.city_list![indexPath.row]
        //本地保存国家，返回首页
        var c = HDSSL_selectedCity()
        c.city_id = city.city_id
        c.city_name = city.city_name
        
        self.saveRecentCityArr(city)
        UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
        UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
        UserDefaults.standard.synchronize()
        //保存选中城市，返回首页
        self.backUP()
    }

    // MARK: 右边索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titleArray
    }

    // MARK: section头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: sectionMargin))
        let title = UILabel(frame: CGRect(x: 15, y: 5, width: ScreenWidth - 15, height: 28))
        var titleArr = titleArray
        titleArr[0] = "当前城市"
        titleArr[1] = "最近访问"
        titleArr[2] = "热门城市"
        title.text = titleArr[section]
        title.textColor = mainColor
        title.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(title)
        view.backgroundColor = UIColor.white
        
        if section == 0 {
            let locString =  HDLY_LocationTool.shared.city ?? "定位失败" //GPS获取当前城市
            let gps = " GPS定位"
            
            let string = locString + gps
            
            let myAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)] as [NSAttributedStringKey : Any]
            let attString = NSMutableAttributedString(string: string)
            attString.addAttributes(myAttribute, range: NSRange.init(location: locString.count, length: gps.count))
            
            title.attributedText = attString
            
        }
        
        if section == 1 {
            view.backgroundColor = cellColor
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 18)
            if recentArray.count == 0 {
                title.text = ""
            }
        }
        
        if section == 2 {
            view.backgroundColor = cellColor
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 18)
        }

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 && recentArray.count == 0 {
            return 0.01
        }
        return sectionMargin
    }
    
    //点击索引，移动TableView的组位置
    func tableView(_ tableView: UITableView,
                   sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        var tpIndex:Int = 0
        //遍历索引值
        for character in titleArray{
            //判断索引值和组名称相等，返回组坐标
            if character == title {
                return tpIndex
            }
            tpIndex += 1
        }
        return 0
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0.01 //btnHeight + 2 * btnMargin
        }else if indexPath.section == 1 {
            if recentArray.count == 0 {
                return 0.01
            }
            let row = (recentArray.count - 1) / 3
            return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
        }else if indexPath.section == 2 {
            let row = (hotArray.count - 1) / 3
            return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
        }else{
            return 42
        }
    }
    
    
}

extension HDSSL_getLocationVC {
    func saveRecentCityArr(_ city: CityModel) {
        var contain = false
        for (i,c) in self.recentArray.enumerated() {
            if c.city_name == city.city_name {
                contain = true
                self.recentArray.remove(at: i)
                self.recentArray.insert(city, at: 0)
            }
        }
        if contain == false {
            self.recentArray.insert(city, at: 0)
            for (i,_) in self.recentArray.enumerated() {
                if i > 5 {
                    self.recentArray.remove(at: i)
                }
            }
        }
        do {
            let data = try JSONEncoder().encode(self.recentArray)
            UserDefaults().set(data, forKey: recentCityArrayKey)
        } catch let error {
            LOG("\(error)")
        }
    }
    
}

extension HDSSL_getLocationVC:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            self.view.endEditing(true)
            //开始搜索
            searchresultView.isHidden = false
            
            if (textField.text?.count)! > 0 {
                //API search
                viewModel.request_searchCityString(string: textField.text!, kind: 2, vc: self)
            }
        }
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchresultView.isHidden = true
    }
}
