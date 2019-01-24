//
//  QRCode_View.swift
//  QRCodeDemo
//
//  Created by HDHaoShaoPeng on 2018/9/26.
//  Copyright © 2018年 HDHaoShaoPeng. All rights reserved.
//   权限提示、image size、timer问题

import UIKit
import AVFoundation

typealias stringBackBlock = (_ backStr:String) -> ()



class QRCode_View: UIView,AVCaptureMetadataOutputObjectsDelegate {
    
    let lineImgName = ""
    let bgImgName = "dl_img_sys"
    
    var ownerVC: UIViewController?
    var cameraAuthorizationStatus: AVAuthorizationStatus = .notDetermined
    
    private lazy var session:AVCaptureSession = {
        
        //获取摄像设备
        let device:AVCaptureDevice =  AVCaptureDevice.default(for: .video)!
        //创建输入流
        
        var input:AVCaptureDeviceInput?
        
        do {
            
            let myinput:AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
            
            input = myinput
            
        }catch let error as NSError{
            
            print(error)
            
        }
        
        //创建输出流
        
        let output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        
        
        output.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
        
        let session1 = AVCaptureSession()
        
        //高质量采集率
        
        session1.canSetSessionPreset(AVCaptureSession.Preset.high)
        
        session1.addInput(input!)
        
        session1.addOutput(output)
        
        
        //设置扫码支持的编码格式(这里设置条形码和二维码兼容)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
        
        return session1
        
        
        
    }()
    
    lazy var lineImgView:UIImageView = {
        let curr = UIImageView()
        let image:UIImage = UIImage.init(named: lineImgName)!
        curr.image = image
        
        return curr
    }()
    
    lazy var bgImgView:UIImageView = {
        let curr = UIImageView()
        let image:UIImage = UIImage.init(named: bgImgName)!
        curr.image = image
        
        return curr
    }()
    
    var myBlock:stringBackBlock?
    
    var lineDown:Bool = true
    
    lazy var myTimer:Timer = {
        let curr = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(lineMoveMethod), userInfo: nil, repeats: true)
        return curr
    }()
    
    
    
    
    //MARK: -公有方法
    public func setupQRCode(_ vc:UIViewController) {
        ownerVC = vc
        adjustCameraAuth()
    }
    
    public func rerunning (){
        self.session.startRunning()
        myTimer.fireDate = NSDate.distantPast
    }
    
    public func stopRunning (){
        self.session.stopRunning()
        myTimer.fireDate = NSDate.distantFuture
    }
    
    public func tellMeString(backBlock:@escaping stringBackBlock){
        myBlock = backBlock
    }
    
    public func releaseMethod() {
        myTimer.invalidate()
    }
    
    //MARK: -类方法生成二维码图片
    //MARK: ---传进去字符串,生成二维码图片
    class func setupQRCodeImage(_ text: String, image: UIImage?, size:CGFloat) -> UIImage {
        //创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        //将url加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        //取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            //生成清晰度更好的二维码
            let qrCodeImage = setupHighDefinitionUIImage(outputImage, size: size)
            //如果有一个头像的话，将头像加入二维码中心
            if var image = image {
                //给头像加一个白色圆边（如果没有这个需求直接忽略）
                image = circleImageWithImage(image, borderWidth: 50, borderColor: UIColor.white)
                //合成图片
                let newImage = syntheticImage(qrCodeImage, iconImage: image, width: size/3.0)
                
                return newImage
            }
            
            return qrCodeImage
        }
        
        return UIImage()
    }
    
    //image: 二维码 iconImage:头像图片 width: 头像的宽 height: 头像的宽
    class func syntheticImage(_ image: UIImage, iconImage:UIImage, width: CGFloat) -> UIImage{
        //开启图片上下文
        UIGraphicsBeginImageContext(image.size)
        //绘制背景图片
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let imgHeight = width*iconImage.size.height/iconImage.size.width
        
        let x = (image.size.width - width) * 0.5
        let y = (image.size.height - imgHeight) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: imgHeight))
        //取出绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回合成好的图片
        if let newImage = newImage {
            return newImage
        }
        return UIImage()
    }
    
    //MARK: ---生成高清的UIImage
    class func setupHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size/integral.width, size/integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion);
        bitmapRef.draw(bitmapImage, in: integral);
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    //生成边框
    class func circleImageWithImage(_ sourceImage: UIImage, borderWidth: CGFloat, borderColor: UIColor) -> UIImage {
        let imageWidth = sourceImage.size.width + 2 * borderWidth
        let imageHeight = sourceImage.size.height + 2 * borderWidth
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageWidth, height: imageHeight), false, 0.0)
        UIGraphicsGetCurrentContext()
        
        let radius = (sourceImage.size.width < sourceImage.size.height ? sourceImage.size.width:sourceImage.size.height) * 0.5
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: imageWidth * 0.5, y: imageHeight * 0.5), radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        bezierPath.lineWidth = borderWidth
        borderColor.setStroke()
        bezierPath.stroke()
        bezierPath.addClip()
        sourceImage.draw(in: CGRect(x: borderWidth, y: borderWidth, width: sourceImage.size.width, height: sourceImage.size.height))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    //MARK: -私有方法
    @objc func lineMoveMethod(){
        
//        if lineImgView.center.y > (bgImgView.frame.size.height - 1) {
//            lineDown = false
//        }
//
//        if lineImgView.center.y < 1 {
//            lineDown = true
//        }
//
//        if lineDown {
//            lineImgView.center.y = lineImgView.center.y + 2
//        }
//        else
//        {
//            lineImgView.center.y = lineImgView.center.y - 2
//        }
    }
    
    func loadCamera()  {
        let layer:AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session:session)
        
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width,height:  self.frame.size.height)
        
        session.startRunning()
        
        self.layer.addSublayer(layer)
        
        bgImgView.frame = CGRect(x: self.frame.size.width*0.125, y: (self.frame.size.height - self.frame.size.width*0.75)/3.0, width: self.frame.size.width*0.75,height:  self.frame.size.width*0.75)
        self.addSubview(bgImgView)
        
//        let image:UIImage = UIImage.init(named: lineImgName)!
//        lineImgView.frame = CGRect.init(x: 0, y: 0, width: bgImgView.frame.size.width, height: bgImgView.frame.size.width*image.size.height/image.size.width)
//        bgImgView.addSubview(lineImgView)
        
        let alertLabel:UILabel = UILabel.init(frame: CGRect(x: 0, y: bgImgView.frame.size.height + bgImgView.frame.origin.y + 10, width: self.frame.size.width, height: 30))
        alertLabel.font = UIFont.systemFont(ofSize: 12.0)
        alertLabel.textColor = .white
        alertLabel.text = "将二维码放入框内，即可自动扫描"
        alertLabel.textAlignment = .center
        self.addSubview(alertLabel)
        
        myTimer.fireDate = NSDate.distantPast
    }
    
    func adjustCameraAuth(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        self.cameraAuthorizationStatus = authStatus
        
        switch authStatus {
        case .authorized:
            loadCamera()
            //print("")
        case .denied:
            //print("被拒绝再次提问")
            let alert = UIAlertController.init(title: "需要获取相机权限才能正常使用该功能", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let confirm = UIAlertAction.init(title: "去获取", style: .default) { (alert) in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if UIApplication.shared.canOpenURL(url!){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url!)
                    }
                }
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            if ownerVC != nil{
                ownerVC?.present(alert, animated: true, completion: nil)
            }
            
        case .notDetermined:
            //print("首次询问")
            weak var weakSelf = self
            AVCaptureDevice.requestAccess(for: .video) { (succ) in
                DispatchQueue.main.async {
                    if succ{
                        weakSelf?.loadCamera()
                    }
                    else
                    {
                        //weakSelf?.session.stopRunning()
                    }
                }
            }
            
        default:
            print("cameraAuth error")
        }
    }
    
    //MARK: -AVCaptureMetadataOutputObjectsDelegate
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            
            
            
            
            let metadataObject:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            guard metadataObject.stringValue != nil else {
                return
            }
            
            guard myBlock != nil else {
                return
            }
            
            print("%@",metadataObject.stringValue!)
            myBlock!(metadataObject.stringValue!)
            
            self.session.stopRunning()
            myTimer.fireDate = NSDate.distantFuture
        }
    }
}
