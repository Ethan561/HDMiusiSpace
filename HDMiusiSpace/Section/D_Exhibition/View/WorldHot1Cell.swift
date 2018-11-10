//
//  WorldHot1Cell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/10.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias TapHot1ItemBlock = (_ county: CountyListModel) -> Void //


class WorldHot1Cell: UITableViewCell {
    
    var hotArray  : [CountyListModel]   = Array.init() //热门
    var viewWidth    : CGFloat  = ScreenWidth
    var blockTapHot1item : TapHot1ItemBlock?
    
    
    // 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //回调
    func BlockTapHot1ItemFunc(block: @escaping TapHot1ItemBlock) {
        blockTapHot1item = block
    }
    
    func setupUI() {
        
        
        self.backgroundColor = cellColor
        
        let btnWidth:CGFloat = (viewWidth - 50) / 2
        
        // 动态创建城市btn
        for i in 0..<hotArray.count {
            
            let city: CountyListModel = hotArray[i]
            // 列
            let column = i % 2
            // 行
            let row = i / 2
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnWidth*62/112 + btnMargin), width: btnWidth, height: btnWidth*62/112))
            btn.isUserInteractionEnabled = true
            btn.backgroundColor = UIColor.lightGray
            btn.layer.borderColor = mainColor.cgColor
            btn.tag = i
            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            
            //            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn.kf.setImage(with: URL.init(string: city.img!), for: .normal, placeholder: UIImage.init(named: "img_nothing"), options: nil, progressBlock: nil, completionHandler: nil)
            
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
            let titleL = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: btn.width, height: btn.height/2-5))
            titleL.text = String.init(format: "%@", city.city_name!)
            titleL.backgroundColor = UIColor.clear
            titleL.textColor = UIColor.white
            titleL.textAlignment = .center
            
            btn.addSubview(titleL)
            
            let subTitleL = UILabel.init(frame: CGRect.init(x: 0, y: btn.height/2, width: btn.width, height: btn.height/2-5))
            subTitleL.text = String.init(format: "%@", city.museum_name!)
            subTitleL.backgroundColor = UIColor.clear
            subTitleL.font = UIFont.systemFont(ofSize: 12)
            subTitleL.textColor = UIColor.white
            subTitleL.textAlignment = .center
            
            btn.addSubview(subTitleL)
            
        }
        
    }
    
    @objc private func btnClick(btn: UIButton) {
        print(btn.tag)
        let city: CountyListModel = hotArray[btn.tag]
        weak var weakSelf = self
        if weakSelf?.blockTapHot1item != nil {
            weakSelf?.blockTapHot1item!(city)
        }
    }

}
