//
//  BannerCell.swift
//  ScrollBannerView
//
//  Created by liuyi on 2017/10/30.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    //轮播图片
    public var imgView = UIImageView.init()
    //标题
    public var titleLabel = UILabel()
    //属性是否已配置
    public var isConfigured = false
    //label高度
    public var titleLabelHeight: CGFloat = 35
    //标题文字
    public var title = String() {
        didSet {
            titleLabel.text = String.init(format: "+#$ %@", title)
            if title == "" {
                titleLabel.isHidden = true
            }else {
                titleLabel.isHidden = false
            }
        }
    }
    //标题字体颜色
    public var titleLabelTextColor = UIColor.white {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    //标题字体大小
    public var titleLabelTextFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            titleLabel.font = titleLabelTextFont
        }
    }
    //标题label的背景颜色
    public var titleLabelBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5) {
        didSet {
            titleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }
    //轮播文字的对齐方式
    public var titleLabelTextAlignment: NSTextAlignment = NSTextAlignment.left {
        didSet {
            titleLabel.textAlignment = titleLabelTextAlignment
        }
    }
    
    //MARK: 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgView.contentMode = .scaleAspectFit
//        imgView.layer.masksToBounds = true
        imgView.image = UIImage.init(named: "展览详情图")
        self.contentView.addSubview(imgView)
        titleLabel.isHidden = true
        titleLabel.numberOfLines = 0
        self.contentView.addSubview(titleLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imgView.frame = self.bounds
        titleLabel.frame = CGRect.init(x: 0, y: self.bounds.height - titleLabelHeight, width: self.bounds.width, height: titleLabelHeight)
        
    }
    
    
    
    
    
    
}











