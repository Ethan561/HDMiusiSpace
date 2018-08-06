//
//  HDTabBarItem.swift
//  ShanXiMuseum
//
//  Created by liuyi on 2018/2/9.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

enum HDTabBarItemType: Int {
    case HDTabBarItemNormal = 0
    case HDTabBarItemRise = 1
}

//标题
let kTabBarItemTitle = "HDTabBarItemAttributeTitle"
//普通状态图片
let kTabBarNormalImgName = "TabBarItemAttributeNormalImageName"
//选中状态下图片
let kTabBarSelectedImgName = "TabBarItemAttributeSelectedImageName"
//AttributeType
let kTabBarItemType = "HDTabBarItemAttributeType"


class HDTabBarItem: UIButton {
    
    public var itemType: String = "0" //0：Normal ，1：Rise
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupItem()
    }
    
    func setupItem() {
        self.adjustsImageWhenHighlighted = false
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel?.sizeToFit()
        let titleSize: CGSize = (self.titleLabel?.size)!
//        let imageSize = self.image(for: UIControlState.normal)?.size
//        //image
        if Int(itemType) == 1 {
            
            var imageViewCenter = self.imageView?.center
            imageViewCenter?.x = self.width / 2
            imageViewCenter?.y = self.height / 2 - 15
            self.imageView?.center = imageViewCenter!
        }
        else {
            var imageViewCenter = self.imageView?.center
            imageViewCenter?.x = self.width / 2
            imageViewCenter?.y = self.height / 2 - 5
            self.imageView?.center = imageViewCenter!
        }
        
        //label
        let labelCenter = CGPoint.init(x: self.width / 2, y: self.height - 3 - titleSize.height / 2)
        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: titleSize.width, height: 18)
        self.titleLabel?.center = labelCenter
        
    }
}







