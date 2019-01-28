//
//  EmptyConfigView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/7.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

class EmptyConfigView: HDEmptyView {

    //空数据界面
    public class func NoDataEmptyView() -> HDEmptyView {
        
        let emptyView:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_nothing", titleStr: "还没有内容呢～", detailStr: "", btnTitleStr: "") {
            
        }
        emptyView.contentViewY = -50
        emptyView.titleLabTextColor = UIColor.lightGray
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        
        return emptyView
    }
    
    public class func NoNetworkEmptyWithBlock(btnClickBlock:@escaping HDTapBlock) -> HDEmptyView {
        let emptyView:HDEmptyView =  HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_sjjzsb", titleStr: "网络无法连接，请重试～", detailStr: "", btnTitleStr: "重新加载", btnClickBlock: btnClickBlock)
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        emptyView.contentViewY = 0
        emptyView.titleLabTextColor = UIColor.HexColor(0x9B9B9B)
        emptyView.actionBtnWidth = 60
        emptyView.actionBtnCornerRadius = 15
        emptyView.actionBtnTitleColor = UIColor.white
        emptyView.actionBtnBackGroundColor = UIColor.HexColor(0xE8593E)
        
        return emptyView
    }
    
    public class func NoNetworkEmptyView() -> HDEmptyView {
        
        let emptyView:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_wlsb", titleStr: "网络无法连接，请重试～", detailStr: "", btnTitleStr: "") {
            
        }
        emptyView.contentViewY = -10
        emptyView.titleLabTextColor = UIColor.HexColor(0x9B9B9B)
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        
        return emptyView
    }

    //无网络界面
    public class func NoNetworkEmptyWithTarget(target:AnyObject, action: Selector) -> HDEmptyView {
        
        let emptyView:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_sjjzsb", titleStr: "数据获取失败，试试重新加载吧～", detailStr: "", btnTitleStr: "重新加载", target: target, action: action) as! HDEmptyView
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        emptyView.contentViewY = 0
        emptyView.titleLabTextColor = UIColor.HexColor(0x9B9B9B)
        emptyView.actionBtnWidth = 60
        emptyView.actionBtnCornerRadius = 15
        emptyView.actionBtnTitleColor = UIColor.white
        emptyView.actionBtnBackGroundColor = UIColor.HexColor(0xE8593E)
        
        return emptyView
    }
    
    //未搜到结果
    public class func NoSearchDataEmptyView() -> HDEmptyView {
        
        let emptyView:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "img_wujieguo", titleStr: "未搜到结果～", detailStr: "", btnTitleStr: "") {
            
        }
        
        emptyView.contentViewY = -50
        emptyView.titleLabTextColor = UIColor.lightGray
        emptyView.backgroundColor = UIColor.white
        emptyView.contentView.backgroundColor = UIColor.clear
        
        return emptyView
    }
    
    
}
