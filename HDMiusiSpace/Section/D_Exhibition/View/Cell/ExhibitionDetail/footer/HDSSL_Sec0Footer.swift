//
//  HDSSL_Sec0Footer.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/23.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_Sec0Footer: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_address: UILabel!
    @IBOutlet weak var cell_bg: UIView!
    
    //使用代码构造此自定义视图时调用
    override init(frame: CGRect) {       //每一步都必须
        super.init(frame: frame)         //实现父初始化
        contentView = self.loadViewFromNib()  //从xib中加载视图
        contentView.frame = bounds       //设置约束或者布局
        addSubview(contentView)          //将其添加到自身中
        
        cell_img.layer.cornerRadius = 5.0
        cell_img.layer.masksToBounds = true
        cell_bg.configShadow(cornerRadius: 5.0, shadowColor: UIColor.HexColor(0xF5F5F4), shadowOpacity: 0.8, shadowRadius: 15, shadowOffset: CGSize.zero)
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
        //重点注意，否则使用的时候不会同步显示在IB中，只会在运行中才显示。
        //注意下面的nib加载方式直接影响是否可视化，如果bundle不确切（为nil或者为main）则看不到实时可视化
        let nib = UINib(nibName:String(describing: HDSSL_Sec0Footer.self), bundle: Bundle(for:HDSSL_Sec0Footer.self))//【？？？？】怎么将类名变为字符串：String(describing: MyView.self) Bundle的参数为type(of: self)也可以。
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
