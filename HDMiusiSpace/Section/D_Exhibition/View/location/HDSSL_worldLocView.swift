//
//  HDSSL_worldLocView.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/9.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

private let hotCityCell = "hotCityCell"
private let recentCell = "rencentCityCell"
private let currentCell = "currentCityCell"

typealias TapLeftTableCellBlock = (_ index: Int) -> Void //返回事件,点击左侧列表，改变大洲
typealias TapRightTableItemBlock = (_ city: HDSSL_selectedCity) -> Void //返回事件,点击右侧item，返回["name":"英国"，“id”： 11]

@IBDesignable         //可视化的关键字
class HDSSL_worldLocView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    
    var isRecomand: Bool? = true //是否是推荐
    var leftTitleArray   : [CountyTypeListModel]      = Array.init() //大洲数组
    var rightTitleArray  : [String]      = Array.init() //右侧标题
    var recentArray  : [CityModel]   = Array.init() //最近
    var hotArray     : [CountyListModel]   = Array.init() //热门
    
    
    var blockTapLeftTableCell : TapLeftTableCellBlock? //点击事件
    var blockTapRightTableItem : TapRightTableItemBlock? //点击事件
    
    //MARK：实现初始化构造器
    //使用代码构造此自定义视图时调用
    override init(frame: CGRect) {       //每一步都必须
        super.init(frame: frame)         //实现父初始化
        contentView = self.loadViewFromNib()  //从xib中加载视图
        contentView.frame = bounds       //设置约束或者布局
        addSubview(contentView)          //将其添加到自身中
        
        self.loadMyViews()
    }
    //可视化IB初始化调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadViewFromNib()
        contentView.frame = bounds
        addSubview(contentView)
        
    }
    
    //MARK：自定义方法
    func loadViewFromNib() -> UIView {
        //重点注意，否则使用的时候不会同步显示在IB中，只会在运行中才显示。
        //注意下面的nib加载方式直接影响是否可视化，如果bundle不确切（为nil或者为main）则看不到实时可视化
        let nib = UINib(nibName:String(describing: HDSSL_worldLocView.self), bundle: Bundle(for:HDSSL_worldLocView.self))//【？？？？】怎么将类名变为字符串：String(describing: MyView.self) Bundle的参数为type(of: self)也可以。
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    //
    //回调
    func BlockLeftFunc(block: @escaping TapLeftTableCellBlock) {
        blockTapLeftTableCell = block
    }
    func BlockRightFunc(block: @escaping TapRightTableItemBlock) {
        blockTapRightTableItem = block
    }
    
    //
    func loadMyViews(){
    
        self.isUserInteractionEnabled = true
        //leftTable
        leftTable.delegate = self
        leftTable.dataSource = self
        leftTable.isScrollEnabled = false
        leftTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        //rightTable
        rightTable.delegate = self
        rightTable.dataSource = self
        rightTable.tableFooterView = UIView.init(frame: CGRect.zero)
        rightTable.register(WorldRecentCell.self, forCellReuseIdentifier: recentCell)
        rightTable.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
        rightTable.register(WorldHotCell.self, forCellReuseIdentifier: hotCityCell)
        
        //右侧数据
        
        //最近
//        var city1 = CityModel()
//        city1.city_id = 244
//        city1.city_name = "鞍山"
//        var city2 = CityModel()
//        city2.city_id = 332
//        city2.city_name = "安庆"
//        var city3 = CityModel()
//        city3.city_id = 387
//        city3.city_name = "安阳"
//        var city4 = CityModel()
//        city4.city_id = 325
//        city4.city_name = "阜阳"
//
//        recentArray.append(city1)
//        recentArray.append(city2)
//        recentArray.append(city3)
        
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
        
        
        //右侧标题
        let arr1 = ["定位","最近访问","热门"]
        rightTitleArray += arr1
        
        
        leftTable.reloadData()
        rightTable.reloadData()
    }
    
    //刷新方法
    public func refreshTable(_ type: Int) {
        if type == 1 {
            leftTable.reloadData()
        }
        rightTable.reloadData()
    }

}
extension HDSSL_worldLocView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTable {
            return leftTitleArray.count
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == rightTable && isRecomand == true {
            return rightTitleArray.count //推荐
        }
        return 1
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTable {
            return 50
        }
        else {
            if indexPath.section == 0 {
                if isRecomand == true {
                    return 0.01 //定位
                }else {
                    //热门
                    let row = (hotArray.count - 1) / 2
                    let hotcellheight = (ScreenWidth - 100 - 50)/2 * 62/112
                    return (hotcellheight + 2 * btnMargin) + (btnMargin + hotcellheight) * CGFloat(row)
                }
                
            }else if indexPath.section == 1 {
                //最近
                let row = (recentArray.count - 1) / 2
                return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
            }
            //热门
            let row = (hotArray.count - 1) / 2
            let hotcellheight = (ScreenWidth - 100 - 50)/2 * 62/112
            return (hotcellheight + 2 * btnMargin) + (btnMargin + hotcellheight) * CGFloat(row)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == leftTable {
            
            let cellStr = "cellIdentifier"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: cellStr)
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: cellStr)
            }
            cell?.backgroundColor = UIColor.clear
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = UIColor.black
            cell?.textLabel?.highlightedTextColor = UIColor.HexColor(0xE8593E) //选中文字颜色
            
            let model = leftTitleArray[indexPath.row]
            cell?.textLabel?.text = String.init(format: "%@", model.type_name!)
            
            //选中背景修改成绿色
            cell?.selectedBackgroundView = UIView()
            cell?.selectedBackgroundView?.backgroundColor =
                UIColor.white
            
            //默认选中0
            if (0 == indexPath.row) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
            
            
            return cell!
            
        }else {
            if isRecomand == true {
                if indexPath.section == 0 {
                    //定位
                    let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath)
                    cell.backgroundColor = cellColor
                    return cell
                    
                }else if indexPath.section == 1 {
                    //最近
                    let cell = tableView.dequeueReusableCell(withIdentifier: recentCell, for: indexPath) as! WorldRecentCell
                    cell.BlockTapItemFunc { (city) in
                        print(city.city_name!)  //返回选中的城市
                        
                        //本地保存选中的城市，返回首页
                        var c = HDSSL_selectedCity()
                        c.city_id = city.city_id
                        c.city_name = city.city_name
                        
                        UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
                        UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
                        UserDefaults.standard.synchronize()
                        self.saveRecentCityArr(city)

                        //回调，改变城市
                        weak var weakSelf = self
                        if weakSelf?.blockTapRightTableItem != nil {
                            weakSelf?.blockTapRightTableItem!(c)
                        }
                        
                    }
                    cell.recentArray = recentArray
                    cell.viewWidth = ScreenWidth - 100
                    cell.setupUI()
                    cell.backgroundColor = UIColor.white
                    cell.selectionStyle = .none
                    return cell
                }else {
                    //推荐热门
                    let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! WorldHotCell
                    cell.viewWidth = ScreenWidth - 100
                    cell.BlockTapHotItemFunc { (city) in
                        print(city.city_name!) // 返回选中国家
                        
                        //本地保存国家，返回首页
                        var c = HDSSL_selectedCity()
                        c.city_id = city.city_id
                        c.city_name = city.city_name
                        
                        
                        UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
                        UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
                        UserDefaults.standard.synchronize()
                        //回调，改变城市
                        weak var weakSelf = self
                        if weakSelf?.blockTapRightTableItem != nil {
                            weakSelf?.blockTapRightTableItem!(c)
                        }
                    }
                    cell.hotArray = hotArray
                    cell.backgroundColor = UIColor.white
                    cell.selectionStyle = .none
                    return cell
                    
                }
                
            } else {
                
                //其他热门
                let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! WorldHotCell
                cell.viewWidth = ScreenWidth - 100
                cell.BlockTapHotItemFunc { (city) in
                    print(city.city_name!) // 返回选中国家
                    
                    //本地保存国家，返回首页
                    var c = HDSSL_selectedCity()
                    c.city_id = city.city_id
                    c.city_name = city.city_name
                    
                    
                    UserDefaults.standard.set(city.city_name, forKey: "MyLocationCityName")
                    UserDefaults.standard.set(city.city_id, forKey: "MyLocationCityId")
                    UserDefaults.standard.synchronize()
                    //回调，改变城市
                    weak var weakSelf = self
                    if weakSelf?.blockTapRightTableItem != nil {
                        weakSelf?.blockTapRightTableItem!(c)
                    }
                }
                cell.hotArray = hotArray
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = .none
                return cell
            }
            
        }
        
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == leftTable{
            
            if indexPath.row != 0{
            
                isRecomand = false
            }else {
                isRecomand = true
            }
            
            //回调，改变大洲
            weak var weakSelf = self
            if weakSelf?.blockTapLeftTableCell != nil {
                weakSelf?.blockTapLeftTableCell!(indexPath.row)
            }
            
        }
        
    }
    // MARK: section头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == rightTable && isRecomand == true {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
            let title = UILabel(frame: CGRect(x: 15, y: 0, width: ScreenWidth - 15, height: 50))
            var titleArr = rightTitleArray
            
            title.text = titleArr[section]
            title.textColor = UIColor.black
            title.font = UIFont.boldSystemFont(ofSize: 16)
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
            
            if section == 1 || section == 2 {
                title.textColor = UIColor.lightGray
                title.font = UIFont.systemFont(ofSize: 16)
            }
            if section == 2 && hotArray.count == 0 {
                title.text = ""
            }
            
            return view
            
        }
        return nil

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == leftTable {
            return 0
        }
        if isRecomand == true {
            return 50
        }
        return 0
    }
}


extension HDSSL_worldLocView {
    
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
        }
        do {
            let data = try JSONEncoder().encode(self.recentArray)
            UserDefaults().set(data, forKey: recentCityArrayKey)
        } catch let error {
            LOG("\(error)")
        }
    }
    
}
