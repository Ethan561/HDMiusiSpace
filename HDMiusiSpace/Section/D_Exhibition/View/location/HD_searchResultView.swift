//
//  HD_searchResultView.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/12.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias TapResultCellBlock = (_ index: Int) -> Void //返回事件,点击左侧列表，改变大洲


let cellIdetifier = "cellidentifier"
class HD_searchResultView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var dTableView: UITableView!
    
    var cityArray: [CityModel]? = Array.init()
    
    var blockTapResultCell:TapResultCellBlock?
    
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
        let nib = UINib(nibName:String(describing: HD_searchResultView.self), bundle: Bundle(for:HD_searchResultView.self))//【？？？？】怎么将类名变为字符串：String(describing: MyView.self) Bundle的参数为type(of: self)也可以。
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func loadMyViews() {
        //
        dTableView.delegate = self
        dTableView.dataSource = self
        dTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
    }
    
    //回调
    func BlockDidFunc(block: @escaping TapResultCellBlock) {
        blockTapResultCell = block
    }
    
}
extension HD_searchResultView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cityArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdetifier)
        
        if (cell == nil)  {
            cell = UITableViewCell.init()
        }
        
        let model = cityArray![indexPath.row]
        
        cell!.textLabel?.attributedText = self.getAttribiteStringWith(string: String.init(format: "%@", model.city_name!))
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cityArray![indexPath.row]
        //本地保存城市，返回首页
        var c = HDSSL_selectedCity()
        c.city_id = model.city_id
        c.city_name = model.city_title
        
        
        UserDefaults.standard.set(model.city_title, forKey: "MyLocationCityName")
        UserDefaults.standard.set(model.city_id, forKey: "MyLocationCityId")
        UserDefaults.standard.synchronize()
        
        
        //回调，选中搜索城市
        weak var weakSelf = self
        if weakSelf?.blockTapResultCell != nil {
            weakSelf?.blockTapResultCell!(indexPath.row)
        }
        
    }
    
}
extension HD_searchResultView{
    //处理文本变色
    func getAttribiteStringWith(string: String) -> NSMutableAttributedString {
        let str = string

        let attribiteDic = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html.rawValue]
        
        var desStr: NSMutableAttributedString? = nil
        if let anEncoding = str.data(using: String.Encoding(rawValue: String.Encoding.unicode.rawValue)) {
            desStr = try? NSMutableAttributedString.init(data: anEncoding, options: attribiteDic, documentAttributes: nil)
        }
        desStr?.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], range: NSRange(location: 0, length: desStr?.length ?? 0))

        return desStr!
    }
}
