//
//  HDSSL_getLocationVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

private let nomalCell = "nomalCell"
private let hotCityCell = "hotCityCell"
private let recentCell = "rencentCityCell"
private let currentCell = "currentCityCell"



class HDSSL_getLocationVC: HDItemBaseVC {
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dBgView: UIView!
    @IBOutlet weak var menu_btn1: UIButton!
    @IBOutlet weak var menu_btn2: UIButton!
    @IBOutlet weak var menu_line1: UIImageView!
    @IBOutlet weak var menu_line2: UIImageView!
    
    var cityDataArray: [CitiesModel] = Array.init() //搜索类型数组
    var recentArray  : [CityModel]   = Array.init() //最近
    var hotArray     : [CityModel]   = Array.init() //热门
    var titleArray   : [String]      = Array.init() //索引标题
    
    //mvvm
    var viewModel: HDSSL_locationViewModel = HDSSL_locationViewModel()
    
    /// 主配色
    let mainColor = UIColor.HexColor(0x707070)
    
    /// 表格
    lazy var dTableView: UITableView = UITableView(frame: dBgView.bounds, style: .plain)
    
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarHeight.constant = CGFloat(kTopHeight)
        self.hd_navigationBarHidden = true
        //MVVM
        bindViewModel()
        
        //UI
        loadMyViews()
        setupTableView()
        
        //data
        loadMyDatas()
        viewModel.request_getCityList(type: 1, vc: self)
    }
    func loadMyDatas() {
        var city1 = CityModel()
        city1.city_id = 244
        city1.city_name = "鞍山"
        var city2 = CityModel()
        city2.city_id = 332
        city2.city_name = "安庆"
        var city3 = CityModel()
        city3.city_id = 387
        city3.city_name = "安阳"
        var city4 = CityModel()
        city4.city_id = 325
        city4.city_name = "阜阳"
        
        recentArray.append(city1)
        recentArray.append(city2)
        recentArray.append(city3)
        
        hotArray.append(city1)
        hotArray.append(city2)
        hotArray.append(city3)
        hotArray.append(city4)
        
    }
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //
        viewModel.cityArray.bind { (typeArray) in
            
            guard typeArray.count > 0 else {
                return
            }
            
            weakSelf?.cityDataArray = typeArray
            
            weakSelf?.initTitleArrayWith(typeArray)
            
            //刷新列表
            weakSelf?.dTableView.reloadData()
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
    
    private func setupTableView() {
        // 设置tableView
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.register(UITableViewCell.self, forCellReuseIdentifier: nomalCell)
        dTableView.register(RecentCitiesTableViewCell.self, forCellReuseIdentifier: recentCell)
        dTableView.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
        dTableView.register(HotCityTableViewCell.self, forCellReuseIdentifier: hotCityCell)
        
        // 右边索引
        dTableView.sectionIndexColor = mainColor
        dTableView.sectionIndexTrackingBackgroundColor = UIColor.HexColor(0x999999)
        dTableView.sectionIndexBackgroundColor = UIColor.clear
        dBgView.addSubview(dTableView)
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
            return cell
        }else if indexPath.section == 2 {

            let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
            cell.hotArray = hotArray
            cell.setupUI()
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath)
            //            cell.backgroundColor = cellColor
            
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
        print("点击了 \(cell?.textLabel?.text ?? "")")
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
            let locString = "北京市" //GPS获取当前城市
            let gps = " GPS定位"
            
            let string = locString + gps
            
            let myAttribute = [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)] as [NSAttributedStringKey : Any]
            let attString = NSMutableAttributedString(string: string)
            attString.addAttributes(myAttribute, range: NSRange.init(location: locString.count, length: gps.count))
            
            title.attributedText = attString
            
        }
        
        if section == 1 || section == 2 {
            view.backgroundColor = cellColor
            title.textColor = UIColor.lightGray
            title.font = UIFont.systemFont(ofSize: 18)
        }

        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionMargin
    }

    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0.01 //btnHeight + 2 * btnMargin
        }else if indexPath.section == 1 {

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
