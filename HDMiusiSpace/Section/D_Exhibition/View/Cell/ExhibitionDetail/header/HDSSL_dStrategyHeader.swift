//
//  HDSSL_dStrategyHeader.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2019/1/18.
//  Copyright © 2019 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dStrategyHeader: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    
    //使用代码构造此自定义视图时调用
    override init(frame: CGRect) {       //每一步都必须
        super.init(frame: frame)         //实现父初始化
        contentView = self.loadViewFromNib()  //从xib中加载视图
        contentView.frame = bounds       //设置约束或者布局
        addSubview(contentView)          //将其添加到自身中
        
        imgView.layer.cornerRadius = 25
        imgView.layer.masksToBounds = true
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
        
        let nib = UINib(nibName:String(describing: HDSSL_dStrategyHeader.self), bundle: Bundle(for:HDSSL_dStrategyHeader.self))
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
