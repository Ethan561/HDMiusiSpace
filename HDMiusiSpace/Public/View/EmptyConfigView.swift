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
    public class func NoDataEmptyView() -> EmptyConfigView {
        
        let emptyView:EmptyConfigView = EmptyConfigView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        emptyView.creatEmptyViewWithImageStr(imageStr: "img_sjjzsb", titleStr: "暂时没有数据", detailStr: "")
        emptyView.contentViewY = -50
        emptyView.titleLabTextColor = UIColor.lightGray
        
        return emptyView
    }
    
    //无网络界面
    public class func NoNetworkEmptyWithTarget(target:AnyObject, action: Selector) -> EmptyConfigView {
        
        let emptyView:EmptyConfigView = EmptyConfigView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        emptyView.creatEmptyViewWithImageStr(imageStr: "img_sjjzsb", titleStr: "数据获取失败，试试重新加载吧～", detailStr: "", btnTitleStr: "重新加载", target: target, action: action)
        emptyView.backgroundColor = UIColor.clear
        emptyView.contentView.backgroundColor = UIColor.clear
        emptyView.contentViewY = 0
        emptyView.titleLabTextColor = UIColor.HexColor(0x9B9B9B)
        emptyView.actionBtnWidth = 60
        emptyView.actionBtnCornerRadius = 15
        emptyView.actionBtnTitleColor = UIColor.white
        emptyView.actionBtnBackGroundColor = UIColor.HexColor(0xE8593E)
        
        return emptyView
    }
    
    
    
}
