//
//  WorldRecentCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias TapRecentItemBlock = (_ city: CityModel) -> Void //

class WorldRecentCell: UITableViewCell {

    var recentArray  : [CityModel]   = Array.init() //最近
    var viewWidth    : CGFloat  = ScreenWidth
    
    var blockTapRecentItem :TapRecentItemBlock? //回调
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //回调
    func BlockTapItemFunc(block: @escaping TapRecentItemBlock) {
        blockTapRecentItem = block
    }
    
    func setupUI() {
        
        self.backgroundColor = cellColor
        
        let btnWidth:CGFloat = (viewWidth - 50) / 2
        
        // 动态创建城市btn
        for i in 0..<recentArray.count {
            
            let city: CityModel = recentArray[i]
            // 列
            let column = i % 2
            // 行
            let row = i / 2
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnHeight + btnMargin), width: btnWidth, height: btnHeight))
            
            btn.tag = i
            btn.setTitle(city.city_name!, for: .normal)
            btn.setTitleColor(mainColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
            btn.layer.borderColor = mainColor.cgColor
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }
        
    }
    
    @objc private func btnClick(btn: UIButton) {
        print(btn.titleLabel?.text!)
        
        let model = recentArray[btn.tag]
        
        weak var weakSelf = self
        if weakSelf?.blockTapRecentItem != nil {
            weakSelf?.blockTapRecentItem!(model)
        }
    }

}
