//
//  HotCityTableViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/9.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

typealias TapHomeHotItemBlock = (_ county: CityModel) -> Void //

class HotCityTableViewCell: UITableViewCell {

    /// 懒加载 热门城市
//    lazy var hotCities: [String] = {
//        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
//        let array = NSArray(contentsOfFile: path!) as? [String]
//        return array ?? []
//    }()
    
    var hotArray     : [CityModel]   = Array.init() //热门
    var viewWidth    : CGFloat  = ScreenWidth
    var blockTapHomeCity : TapHomeHotItemBlock?
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //回调
    func BlockTapHomeHotItemFunc(block: @escaping TapHomeHotItemBlock) {
        blockTapHomeCity = block
    }
    
    func setupUI() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        self.backgroundColor = cellColor
        
        let btnWidth:CGFloat = (viewWidth - 90) / 3
        
        // 动态创建城市btn
        for i in 0..<hotArray.count {
            
            let city: CityModel = hotArray[i]
            // 列
            let column = i % 3
            // 行
            let row = i / 3
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnHeight + btnMargin), width: btnWidth, height: btnHeight))
            btn.setTitle(city.city_name!, for: .normal)
            btn.setTitleColor(mainColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
//            btn.layer.borderColor = mainColor.cgColor
//            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.tag = i
            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        print(btn.titleLabel?.text!)
        
        let city: CityModel = hotArray[btn.tag]
        weak var weakSelf = self
        if weakSelf?.blockTapHomeCity != nil {
            weakSelf?.blockTapHomeCity!(city)
        }
    }

}
