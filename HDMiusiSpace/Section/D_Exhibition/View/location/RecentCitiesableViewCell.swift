//
//  RecentCityTableViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/10.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

typealias TapHomeRecentItemBlock = (_ county: CityModel) -> Void //

class RecentCitiesTableViewCell: UITableViewCell {
    
    var recentArray  : [CityModel]   = Array.init() //最近
    var viewWidth    : CGFloat  = ScreenWidth
    var blockTapHomeRecentCity : TapHomeRecentItemBlock?
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //回调
    func BlockTapHomeRecentItemFunc(block: @escaping TapHomeRecentItemBlock) {
        blockTapHomeRecentCity = block
    }
    
    func setupUI() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        self.backgroundColor = cellColor
        
        let btnWidth:CGFloat = (viewWidth - 90) / 3
        
        // 动态创建城市btn
        for i in 0..<recentArray.count {
            
            let city: CityModel = recentArray[i]
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
        print(btn.titleLabel?.text! as Any)
        let city: CityModel = recentArray[btn.tag]
        weak var weakSelf = self
        if weakSelf?.blockTapHomeRecentCity != nil {
            weakSelf?.blockTapHomeRecentCity!(city)
        }
    }

}
