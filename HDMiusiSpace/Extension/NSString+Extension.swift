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
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: fontName,  NSAttributedString.Key.paragraphStyle: paragraphStyle], context: nil)
        return ceil(rect.width)
    }
    
    func getContentHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let fontName:UIFont = font
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [kCTFontAttributeName as NSAttributedString.Key: fontName], context: nil)
        return ceil(rect.height)
    }
    
    
    
    func getContentForMaxHeight(fontSize: CGFloat, width: CGFloat, maxHeight: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil)
        return ceil(rect.height)>maxHeight ? maxHeight : ceil(rect.height)
    }
    
    func getLabSize(font:UIFont,width:CGFloat) -> CGSize {
        let fontName:UIFont = font
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: fontName], context: nil)
        return rect.size
    }
}

extension NSAttributedString {
    func getAttributeContentHeight(width: CGFloat) -> CGFloat {
        let rect = NSAttributedString.init(attributedString: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin,.usesFontLeading], context: nil)
        return rect.height
    }
}


extension String {
    /// 字符串的匹配范围 方法二(推荐)
    ///
    /// - Parameters:
    ///     - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func hw_exMatchStrRange(_ matchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (matchStr as NSString).length).joined(separator: "") //辅助字符串
        if matchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: matchStr).location != NSNotFound {
            let range = selfStr.range(of: matchStr)
            allRange.append(NSRange(location: range.location,length: range.length))
            selfStr = selfStr.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
        }
        return allRange
    }
}
