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
    case TagViewTypeNormal = 2                     //普通标签，没有选中状态，可频繁点击
}

enum UserTagType: Int {
    case UserTagTypeDefault = 0          //默认
    case UserTagTypeCareer  = 1          //职业
    case UserTagTypeState   = 2          //状态
    case UserTagTypeFunny   = 3          //爱好
}

typealias TapTagBlock = (_ itemArray: Array<Any>) -> Void //返回事件

class HD_SSL_TagView: UIView {

    public var titleArray       : [String] = Array.init() //标签标题数组
    public var selctedArray     : [String] = Array.init() //已选数组
    public var restArray     : [String] = Array.init()    //已选需要重置数组
    public var titleColorNormal : UIColor = .lightGray    //标题颜色，默认灰色
    public var titleColorSelect : UIColor = .white        //选中标题颜色，默认灰色
    public var borderColor      : UIColor = .black        //边框颜色，默认黑色
    
    var lastTagOrigin : CGPoint?  //上一个标签起点
    var lastTagSize   : CGSize?   //上一个标签尺寸
    var recordBtn     : UIButton? = UIButton.init(type: .custom) //暂存上一个标签
    
    var tagViewType : TagViewType? //标签类型
    var userTagType : UserTagType? //用户标签类别
    var blockTapTag : TapTagBlock? //点击事件
    
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
            sender.layer.borderColor = UIColor.white.cgColor
        }else {
            sender.backgroundColor = UIColor.white
            sender.layer.borderColor = borderColor.cgColor
        }
        
        self.reloadSelectedArray(String(sender.tag-10))
        
        //单选并且是选中状态
        if tagViewType! == TagViewType.TagViewTypeSingleSelection && sender.isSelected == true{
            dealResetTags()
            getBackSelectedTags()
        }
        
    }
    //点击标签，筛选
    @objc func action_tapNormalTagBy(_ sender: UIButton) {
        
        self.reloadSelectedArray(String(sender.tag))
        
        getBackSelectedTags()
        
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
        
        if tagViewType!.rawValue == 0 {
            
            array.removeAll()
            array.append(indexStr)
            
        } else {
            
            if array.contains(indexStr) {
                let inde = array.index(of: indexStr)
                array.remove(at: inde!)
            }else {
                array.append(indexStr)
            }
            
        }
        
        selctedArray = array
        
    }
    //MARK: -- 刷新页面，删除选中标签
    func reloadMySelectedTags(_ tags:[String]) -> Void {
        //
        print(tags)
        restArray = tags
        
    }
    func dealResetTags(){
        
        if restArray.count == 0 {
            return
        }
        let str1 = restArray[0]
        let str2 = selctedArray[0]
        if str1 != str2 {
            let view = self.viewWithTag(Int(str1)!+10)
            if (view?.isKind(of: UIButton.self))! {
                let btn = view as! UIButton
                btn.isSelected = false
                btn.backgroundColor = UIColor.white
                btn.layer.borderColor = borderColor.cgColor
            }
        }
        
    }
    //加载服务器返回状态
    func loadSelectedTags(_ tags:[String]) -> Void {
        if tags.count == 0 {
            return
        }
        for i in 0..<tags.count {
            let str1 = tags[i]
            
            let view = self.viewWithTag(Int(str1)!+10)
            if (view?.isKind(of: UIButton.self))! {
                let btn = view as! UIButton
                btn.isSelected = true
                btn.backgroundColor = UIColor.RGBColor(215, 99, 72)
                btn.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        
    }
    
    //返回多选
    func getBackMultiSelectedTags(){
        
        selctedArray.removeAll()
        
        for i in 0..<titleArray.count {
            let view = self.viewWithTag(i+10)
            
            if (view?.isKind(of: UIButton.self))!{
                let btn = view as! UIButton
                if btn.isSelected == true
                {
                    selctedArray.append(String(i))
                }
            }
        }
        
        weak var weakSelf = self
        
        if weakSelf?.blockTapTag != nil {
            weakSelf?.blockTapTag!(selctedArray)
        }
    }
    
    //MARK: -- 创建标签引导页的tags
    func loadTagsView() {
        
        if titleArray.count > 0 {
            for i: Int in 0..<titleArray.count {
                
                let tagTitle = titleArray[i] as NSString
                
                //记录上一个按钮位置、大小
                
                let btn = UIButton.init(type: .custom)
                btn.backgroundColor = UIColor.white
                
                btn.setTitleColor(titleColorNormal, for: .normal)
                btn.setTitleColor(titleColorSelect, for: .selected)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                btn.titleLabel?.lineBreakMode = .byTruncatingTail
                
                var space = 15.0
                var kkWith = self.frame.size.width
                if Device_Is_iPhoneSE == true {
                    space = 10.0
                    kkWith = 320
                }
                    
                let rect = tagTitle.boundingRect(with: CGSize.init(width: kkWith - CGFloat(space * 2), height: 30), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), attributes: [NSAttributedString.Key.font : btn.titleLabel?.font ?? 11], context: nil)
                
                let BtnW = rect.size.width + CGFloat(space * 2)
                let BtnH = rect.size.height + CGFloat(space)
                
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = (rect.size.height + CGFloat(space)) / 2
                btn.layer.borderWidth = 0.5
                btn.layer.borderColor = borderColor.cgColor
                
                //布局
                if i == 0 {
                    btn.frame = CGRect.init(x: CGFloat(space), y: CGFloat(space), width: BtnW, height: BtnH)
                } else {
                    let yuWidth = kkWith - CGFloat(space * 2) - (lastTagOrigin?.x == 0.0 ? 0.0 : (lastTagOrigin?.x)!) - (lastTagSize?.width == 0.0 ? 0.0 : (lastTagSize?.width)!) //计算剩余宽度
                    if yuWidth >= (BtnW + CGFloat(space)) {
                        btn.frame = CGRect.init(x: (lastTagOrigin?.x)! + (lastTagSize?.width)! + CGFloat(space), y: (lastTagOrigin?.y)!, width: BtnW, height: BtnH) //拼在上一个Tag末尾
                    }else {
                        btn.frame = CGRect.init(x: CGFloat(space), y: (lastTagOrigin?.y)! + (lastTagSize?.height)! + CGFloat(space), width: BtnW, height: BtnH) //另起一行
                    }
                    
                }
                
                //title
                btn.setTitle(String.init(format: "%@", tagTitle), for: .normal)
                
                self.addSubview(btn)
                
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: kkWith, height: btn.frame.maxY)
                
                recordBtn = btn
                
                lastTagOrigin = CGPoint.init(x: (recordBtn?.frame.origin.x)!, y: (recordBtn?.frame.origin.y)!)
                lastTagSize = CGSize.init(width: (recordBtn?.frame.size.width)!, height: (recordBtn?.frame.size.height)!)
                
                btn.tag = i+10
                
                btn.addTarget(self, action: #selector(action_tapTagBy(_:)), for: .touchUpInside)
                
            }
        }
    }
    
    //MARK: -- 创建普通标签
    func loadNormalTagsView() {
        if titleArray.count > 0 {
            for i: Int in 0..<titleArray.count {
                
                let tagTitle = titleArray[i] as NSString
                
                //记录上一个按钮位置、大小
                
                
                let btn = UIButton.init(type: .custom)
                btn.backgroundColor = UIColor.white
                
                btn.setTitleColor(titleColorNormal, for: .normal)
                
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                btn.titleLabel?.lineBreakMode = .byTruncatingTail
                var space = 12.0
                var kkWith = self.frame.size.width
                if Device_Is_iPhoneSE == true {
                    space = 8.0
                    kkWith = 320
                }
                let rect = tagTitle.boundingRect(with: CGSize.init(width: kkWith-CGFloat(space * 2), height: 30), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue))), attributes: [NSAttributedString.Key.font : btn.titleLabel?.font ?? 11], context: nil)
                
                let BtnW = rect.size.width + CGFloat(space * 2)
                let BtnH = rect.size.height + CGFloat(space)
                
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = (rect.size.height + CGFloat(space)) / 2
                btn.layer.borderWidth = 0.5
                btn.layer.borderColor = borderColor.cgColor
                
                //布局
                if i == 0 {
                    btn.frame = CGRect.init(x: CGFloat(space), y: CGFloat(space), width: BtnW, height: BtnH)
                } else {
                    let yuWidth = kkWith - CGFloat(space * 2) - (lastTagOrigin?.x == 0.0 ? 0.0 : (lastTagOrigin?.x)!) - (lastTagSize?.width == 0.0 ? 0.0 : (lastTagSize?.width)!) //计算剩余宽度
                    if yuWidth >= (BtnW + CGFloat(space)) {
                        btn.frame = CGRect.init(x: (lastTagOrigin?.x)! + (lastTagSize?.width)! + CGFloat(space), y: (lastTagOrigin?.y)!, width: BtnW, height: BtnH) //拼在上一个Tag末尾
                    }else {
                        btn.frame = CGRect.init(x: CGFloat(space), y: (lastTagOrigin?.y)! + (lastTagSize?.height)! + CGFloat(space), width: BtnW, height: BtnH) //另起一行
                    }
                    
                }
                
                //title
                btn.setTitle(String.init(format: "%@", tagTitle), for: .normal)
                
                self.addSubview(btn)
                
                self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: kkWith, height: btn.frame.maxY)
                
                recordBtn = btn
                
                lastTagOrigin = CGPoint.init(x: (recordBtn?.frame.origin.x)!, y: (recordBtn?.frame.origin.y)!)
                lastTagSize = CGSize.init(width: (recordBtn?.frame.size.width)!, height: (recordBtn?.frame.size.height)!)
                
                btn.tag = i
                
                btn.addTarget(self, action: #selector(action_tapNormalTagBy(_:)), for: .touchUpInside)
                
            }
        }
    }
}
