//
//  HDSSL_dHeaderNormal.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
//block
typealias BloclkShowMore = (_ index: Int) -> Void //
class HDSSL_dHeaderNormal: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerMore: UIButton!
    
    var blockShowMore: BloclkShowMore?

    
    func BlockShowmore(block: @escaping BloclkShowMore){
        blockShowMore = block
    }
    
    
    @IBAction func action_showMore(_ sender: UIButton) {
        weak var weakself = self
        
        if weakself?.blockShowMore != nil {
            weakself?.blockShowMore!(self.tag)
        }
        
    }
    //使用代码构造此自定义视图时调用
    override init(frame: CGRect) {       //每一步都必须
        super.init(frame: frame)         //实现父初始化
        contentView = self.loadViewFromNib()  //从xib中加载视图
        contentView.frame = bounds       //设置约束或者布局
        addSubview(contentView)          //将其添加到自身中
        
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
        let nib = UINib(nibName:String(describing: HDSSL_dHeaderNormal.self), bundle: Bundle(for:HDSSL_dHeaderNormal.self))//【？？？？】怎么将类名变为字符串：String(describing: MyView.self) Bundle的参数为type(of: self)也可以。
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

}
