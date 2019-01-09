//
//  HDGIFImageView.swift
//  HDNanHaiMuseum
//
//  Created by HD-XXZQ-iMac on 2018/6/19.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit

protocol GIFImageViewClickDelegate:NSObjectProtocol
{
    func gifImageViewClickAction()
}

class HDGIFImageView: UIImageView {

    weak var delegate:GIFImageViewClickDelegate?
    
    init(frame: CGRect,path:String) {
        super.init(frame: frame)
        setGifImageView(path: path)
        self.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer.init(target: self, action: #selector(pushToDetail))
        self.addGestureRecognizer(ges)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pushToDetail() {
        if delegate != nil {
            delegate?.gifImageViewClickAction()
        }
    }
    
    func setGifImageView(path:String) -> Void {
        let data = NSData.init(contentsOfFile: path)
        let options: NSDictionary = [kCGImageSourceShouldCache as String: NSNumber(value: true), kCGImageSourceTypeIdentifierHint as String: "kUTTypeGIF"]
        guard let imageSource = CGImageSourceCreateWithData(data!, options) else { return  }
        
        let frameCount = CGImageSourceGetCount(imageSource)
        var images = [UIImage]()
        
        var gifDuration = 0.0
        
        for i in 0 ..< frameCount {
            // 获取对应帧的 CGImage
            guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, options) else {
                return
            }
            if frameCount == 1 {
                // 单帧
                gifDuration = Double.infinity
            } else{
                // gif 动画
                // 获取到 gif每帧时间间隔
                guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                    let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else
                {
                    return
                }
                //                print(frameDuration)
                gifDuration += frameDuration.doubleValue
                // 获取帧的img
                let image = UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
                // 添加到数组
                images.append(image)
            }
        }
        self.contentMode = .scaleAspectFit
        self.animationImages = images
        self.animationDuration = gifDuration
        self.animationRepeatCount = 0 // 无限循环
    }

}
