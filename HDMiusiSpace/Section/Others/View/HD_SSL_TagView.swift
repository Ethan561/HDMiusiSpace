//
//  HD_SSL_TagView.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/8/31.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

enum TagViewType: Int {
    case TagViewTypeSingleSelection = 0            //单选返回数据
    case TagViewTypeMultipleSelection = 1          //多选返回数据
}

typealias TapTagBlock = (_ itemArray: Array<Any>) -> Void

class HD_SSL_TagView: UIView {

    public var titleArray : [String] = Array.init()
    public var selctedArray : [String] = Array.init()
    
    var lastTagOrigin : CGPoint?
    var lastTagSize: CGSize?
    var recordBtn: UIButton? = UIButton.init(type: .custom)
    
    var tagViewType : TagViewType?
    var blockTapTag : TapTagBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //回调
    func BlockFunc(block: @escaping TapTagBlock) {
        blockTapTag = block
    }
    
    //点击标签，筛选
    @objc func action_tapTagBy(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            sender.backgroundColor = UIColor.RGBColor(215, 99, 72)
        }else {
            sender.backgroundColor = UIColor.white
        }
        
        self.reloadSelectedArray(String(sender.tag))
        
        
        if tagViewType!.rawValue == 0 {
            getBackSelectedTags()
        }
        
    }
    
    //返回数据
    public func getBackSelectedTags() {
        
        weak var weakSelf = self
        
        if weakSelf?.blockTapTag != nil {
            weakSelf?.blockTapTag!(selctedArray)
        }
        
    }
    //刷新选择数组
    func reloadSelectedArray(_ indexStr: String) -> Void {
        //
        var array = selctedArray
        
        if array.contains(indexStr) {
            let inde = array.index(of: indexStr)
            array.remove(at: inde!)
        }else {
            array.append(indexStr)
        }
        
        selctedArray = array
        
    }
    
    //MARK: -- 创建tags
    func loadTagsView() {
        
        if titleArray.count > 0 {
            for i: Int in 0..<titleArray.count {
                
                let tagTitle = titleArray[i] as NSString
                
                //记录上一个按钮位置、大小
                
                
                let btn = UIButton.init(type: .custom)
                btn.backgroundColor = UIColor.white
                
                btn.setTitleColor(UIColor.lightGray, for: .normal)
                btn.setTitleColor(UIColor.white, for: .selected)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                btn.titleLabel?.lineBreakMode = .byTruncatingTail
                let rect = tagTitle.boundingRect(with: CGSize.init(width: self.frame.size.width-20, height: 30), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), attributes: [NSAttributedStringKey.font : btn.titleLabel?.font], context: nil)
                
                let BtnW = rect.size.width + 20
                let BtnH = rect.size.height + 10
                
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = (rect.size.height + 10) / 2
                btn.layer.borderWidth = 0.5
                
                //布局
                if i == 0 {
                    btn.frame = CGRect.init(x: 10, y: 10, width: BtnW, height: BtnH)
                } else {
                    let yuWidth = self.frame.size.width - 20 - (lastTagOrigin?.x == 0.0 ? 0.0 : (lastTagOrigin?.x)!) - (lastTagSize?.width == 0.0 ? 0.0 : (lastTagSize?.width)!) //计算剩余宽度
                    if yuWidth >= rect.size.width {
                        btn.frame = CGRect.init(x: (lastTagOrigin?.x)! + (lastTagSize?.width)! + 5, y: (lastTagOrigin?.y)!, width: BtnW, height: BtnH) //拼在上一个Tag末尾
                    }else {
                        btn.frame = CGRect.init(x: 10, y: (lastTagOrigin?.y)! + (lastTagSize?.height)! + 10, width: BtnW, height: BtnH) //另起一行
                    }
                    
                }
                
                //title
                btn.setTitle(String.init(format: "%@", tagTitle), for: .normal)
                
                self.addSubview(btn)
                
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: btn.frame.maxY)
                
                recordBtn = btn
                
                lastTagOrigin = CGPoint.init(x: (recordBtn?.frame.origin.x)!, y: (recordBtn?.frame.origin.y)!)
                lastTagSize = CGSize.init(width: (recordBtn?.frame.size.width)!, height: (recordBtn?.frame.size.height)!)
                
                btn.tag = i
                
                btn.addTarget(self, action: #selector(action_tapTagBy(_:)), for: .touchUpInside)
                
            }
        }
    }
    
}
