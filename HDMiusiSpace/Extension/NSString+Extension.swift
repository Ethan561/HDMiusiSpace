//
//  NSString+Extension.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/11.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit


// 计算文字高度或者宽度与weight参数无关
extension String {
    func getContentWidth(font: UIFont, height: CGFloat = 15) -> CGFloat {
        let fontName:UIFont = font
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineBreakMode = .byCharWrapping
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontName,  NSAttributedStringKey.paragraphStyle: paragraphStyle], context: nil)
        return ceil(rect.width)
    }
    
    func getContentHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let fontName:UIFont = font
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontName], context: nil)
        return ceil(rect.height)
    }
    
    
    
    func getContentForMaxHeight(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    func getLabSize(font:UIFont,width:CGFloat) -> CGSize {
        let fontName:UIFont = font
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: fontName], context: nil)
        return rect.size
    }
}

extension NSAttributedString {
    func getAttributeContentHeight(width: CGFloat) -> CGFloat {
        let rect = NSAttributedString.init(attributedString: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        return rect.height
    }
}
