//
//  HDSSL_worldLocView.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/9.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

private let recentCell = "rencentCityCell"
private let currentCell = "currentCityCell"

@IBDesignable         //可视化的关键字
class HDSSL_worldLocView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    
    var isRecomand: Bool? = true //是否是推荐
    var leftTitleArray   : [String]      = Array.init() //大洲数组
    var rightTitleArray  : [String]      = Array.init() //右侧标题
    var recentArray  : [CityModel]   = Array.init() //最近
    var hotArray     : [CityModel]   = Array.init() //热门
    
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
    func loadMyViews(){
    
        //leftTable
        leftTable.delegate = self
        leftTable.dataSource = self
        leftTable.isScrollEnabled = false
        leftTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        //rightTable
        rightTable.delegate = self
        rightTable.dataSource = self
        rightTable.tableFooterView = UIView.init(frame: CGRect.zero)
        rightTable.register(RecentCitiesTableViewCell.self, forCellReuseIdentifier: recentCell)
        rightTable.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
        
        //右侧数据
        //最近
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
        
        //左侧标题
        let arr = ["推荐","港澳台","亚洲","欧洲","北美洲","南美洲","大洋洲","非洲"]
        leftTitleArray += arr
        
        //右侧标题
        let arr1 = ["定位","最近访问","热门"]
        rightTitleArray += arr1
        
        
        leftTable.reloadData()
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
                return 0.01 //btnHeight + 2 * btnMargin
            }else if indexPath.section == 1 {
                
                let row = (recentArray.count - 1) / 3
                return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
            }
            
            return 44
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
            cell?.textLabel?.text = leftTitleArray[indexPath.row]
            
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
            
            
            if indexPath.section == 0 {
                //定位
                let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath)
                cell.backgroundColor = cellColor
                return cell
                
            }else if indexPath.section == 1 {
                //最近
                let cell = tableView.dequeueReusableCell(withIdentifier: recentCell, for: indexPath) as! RecentCitiesTableViewCell
                cell.recentArray = recentArray
                cell.viewWidth = ScreenWidth - 100
                cell.setupUI()
                cell.backgroundColor = UIColor.white
                return cell
            }else {
                //热门
                let cellStr = "cellIdentifier"
                
                var cell = tableView.dequeueReusableCell(withIdentifier: cellStr)
                if cell == nil {
                    cell = UITableViewCell.init(style: .default, reuseIdentifier: cellStr)
                }
                cell?.backgroundColor = UIColor.clear
                cell?.textLabel?.textAlignment = .center
                cell?.textLabel?.textColor = UIColor.black
                cell?.textLabel?.highlightedTextColor = UIColor.HexColor(0xE8593E) //选中文字颜色
                cell?.textLabel?.text = leftTitleArray[indexPath.row]
                
                
                return cell!
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
            
            rightTable.reloadData()
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
                title.textColor = UIColor.lightGray
                title.font = UIFont.systemFont(ofSize: 16)
            }
            
            return view
            
        }
        return nil

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == leftTable {
            return 0
        }
        return 50
    }
}
