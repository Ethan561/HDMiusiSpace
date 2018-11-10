//
//  WorldHotCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class WorldHotCell: UITableViewCell {

    var hotArray  : [CityModel]   = Array.init() //热门
    var viewWidth    : CGFloat  = ScreenWidth
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        
        self.backgroundColor = cellColor
        
        let btnWidth:CGFloat = (viewWidth - 50) / 2
        
        // 动态创建城市btn
        for i in 0..<hotArray.count {
            
            let city: CityModel = hotArray[i]
            // 列
            let column = i % 2
            // 行
            let row = i / 2
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnWidth*62/112 + btnMargin), width: btnWidth, height: btnWidth*62/112))
            
            btn.backgroundColor = UIColor.lightGray
            btn.layer.borderColor = mainColor.cgColor
            btn.tag = i
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
            let titleL = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: btn.width, height: btn.height/2-5))
            titleL.text = "英国"
            titleL.backgroundColor = UIColor.clear
            titleL.textColor = UIColor.white
            titleL.textAlignment = .center
            
            btn.addSubview(titleL)
            
            let subTitleL = UILabel.init(frame: CGRect.init(x: 0, y: btn.height/2, width: btn.width, height: btn.height/2-5))
            subTitleL.text = "大英博物馆"
            subTitleL.backgroundColor = UIColor.clear
            subTitleL.font = UIFont.systemFont(ofSize: 12)
            subTitleL.textColor = UIColor.white
            subTitleL.textAlignment = .center
            
            btn.addSubview(subTitleL)
            
        }
        
    }
    
    @objc private func btnClick(btn: UIButton) {
        print(btn.tag)
    }

}
