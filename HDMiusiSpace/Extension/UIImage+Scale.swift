//
//  UIImage+Scale.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics
import Accelerate

// MARK: - UIImage扩展,等比例缩小图片到指定的宽度

extension UIImage {
    /**
     等比例缩小图片到指定的宽度
     - parameter newWidth: 缩放后的宽度
     */
    func scaleImage(newWidth: CGFloat = 300) -> UIImage {
        // 如果图片宽度小于 newWidth, 直接返回
        if size.width < newWidth {
            return self
        }
        
        // 计算缩放好后的高度
        // newHeight / newWidth = height / width
        let newHeight = newWidth * size.height / size.width
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        // 将图片等比例缩放到 newSize
        
        // 开启图片上下文
        UIGraphicsBeginImageContext(newSize)
        
        // 绘图
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        
        // 获取绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭绘图上下文
        UIGraphicsEndImageContext()
        
        // 返回绘制好的新图
        return newImage!
    }
    
    
    
    //图片压缩方法
    class func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        
        var maxImageSize = maxImageLenght
        
        
        
        if (maxSize <= 0.0) {
            
            maxSize = 1024.0;
            
        }
        
        if (maxImageSize <= 0.0)  {
            
            maxImageSize = 1024.0;
            
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
            
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        
        return imageData!
        
    }
    
    //生成灰色占位图
    class func grayImage(sourceImageV: UIImageView) -> UIImage? {
        let width = sourceImageV.size.width
        let height = sourceImageV.size.height
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.HexColor(0xEEEEEE).cgColor)
        context?.fill(rect)
        
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage.init(named: "img_nothing")
        }
        UIGraphicsEndImageContext()
        
        return UIImage.init(cgImage: img.cgImage!)
    }
    /// 获取网络图片尺寸
    
    ///
    
    /// - Parameter url: 网络图片链接
    
    /// - Returns: 图片尺寸size
    
    class func getImageSize(_ url: String?) -> CGSize {
        
        
        
        guard let urlStr = url else {
            
            return CGSize.zero
            
        }
        
        let tempUrl = URL(string: urlStr)
        
        
        
        let imageSourceRef = CGImageSourceCreateWithURL(tempUrl! as CFURL, nil)
        
        var width: CGFloat = 0
        
        var height: CGFloat = 0
        
        if let imageSRef = imageSourceRef {
            
            let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSRef, 0, nil)
            
            
            
            if let imageP = imageProperties {
                
                let imageDict = imageP as Dictionary
                
                width = imageDict[kCGImagePropertyPixelWidth] as! CGFloat
                
                height = imageDict[kCGImagePropertyPixelHeight] as! CGFloat
                
            }
            
        }
        
        
        
        return CGSize(width: width, height: height)
        
    }
    
}


