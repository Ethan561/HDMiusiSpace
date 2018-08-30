//
//  HDLY_PhotoSelectorView.swift
//  HDNanHaiMuseum
//
//  Created by liuyi on 2018/6/13.
//  Copyright © 2018年 liuyi. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

let imgWidth :CGFloat  = 90 //高宽相等
let kSpace :CGFloat   = 10

class HDLY_PhotoSelectorView: UICollectionView {

    /// 最大照片数量
    var maxCount = 9
    /// 照片数组
    var photos = [UIImage]()
    var originalPhotos = [UIImage]()
    var addBtnImg:UIImage = UIImage.init(named: "icon_addphoto_kuang")!
    
    /// 外部 NavigationController 用于弹出 UIImagePickerController
    var nav: UINavigationController?
    var currentVC : HDItemBaseVC?

    init(_ nav: UINavigationController?) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: imgWidth, height: imgWidth)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        backgroundColor = UIColor.white
        delegate = self
        dataSource = self
        register(HDLY_PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        translatesAutoresizingMaskIntoConstraints = false
        
        self.nav = nav
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HDLY_PhotoSelectorView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count < maxCount ? photos.count + 1 : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HDLY_PhotoCell
        cell.delegate = self
        cell.addBtnImg = addBtnImg
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.row]
        } else {
            cell.setupAddButton()
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        LOG(indexPath)
        openPhotoBrowserWithLocalImage(index: indexPath.row)
        
    }
}

// MARK: - PhotoSelectorCellDelegate
extension HDLY_PhotoSelectorView: PhotoSelectorCellDelegate,MTImagePickerControllerDelegate {
    
    func photoSelectorCellDidClickAddButton(cell: HDLY_PhotoCell) {
//        let pickerVC = UIImagePickerController()
//        // 设置代理
//        pickerVC.delegate = self
//
//        nav?.present(pickerVC, animated: true, completion: nil)
        eventAddImage()
        
    }
    
    func photoSelectorCellDidClickDeleteButton(cell: HDLY_PhotoCell) {
        // 先获取点击的是哪个位置的删除按钮
        let indexPath = self.indexPath(for: cell)
        
        photos.remove(at: indexPath!.item)
        originalPhotos.remove(at: indexPath!.item)
        
        reloadSections(IndexSet(integer: 0))
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PhotoSelectorViewReloadNoti"), object: nil)

    }
    
    //
    // 页面底部 stylesheet
    func eventAddImage() {
        let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // change the style sheet text color
        alert.view.tintColor = UIColor.black
        
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
            
            let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if authStatus == .denied || authStatus == .restricted {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "尚未打开相机权限，请去设置中打开")
                
                return
            }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) == false {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "相机不可用")
                
                return
            }
            if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear) == false {
                HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "相机已损坏，无法使用拍照功能")
                
                return
            }
            self.choosePickerType(type: UIImagePickerControllerSourceType.camera)
        }
        
        let actionPhoto = UIAlertAction.init(title: "从手机相册中选择", style: .default) { (UIAlertAction) -> Void in
            self.choosePickerType(type: UIImagePickerControllerSourceType.photoLibrary)
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        
       nav?.present(alert, animated: true, completion: nil)
    }
    
    func choosePickerType(type: UIImagePickerControllerSourceType) {
        if type == .camera {
            let pickController:UIImagePickerController = UIImagePickerController.init()
            pickController.delegate = self
            pickController.sourceType = type
            pickController.allowsEditing = true
            nav?.present(pickController, animated: true, completion: nil)
        }else {
            // 使用示例
            let vc = MTImagePickerController.instance
            vc.mediaTypes = [MTImagePickerMediaType.Photo]
            vc.source = MTImagePickerSource.Photos
            vc.imagePickerDelegate = self
            let maxCount = 9
            vc.maxCount = maxCount - originalPhotos.count
            vc.defaultShowCameraRoll = true
            currentVC?.present(vc, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker:MTImagePickerController, didFinishPickingWithPhotosModels models:[MTImagePickerPhotosModel]) {
        if models.count > 0 {
            for photosModel in models {
//                guard  else {
//                    return
//                }
                 photosModel.getImageAsync { (img) in
                    self.originalPhotos.append(img!)
                    let newImage = img?.scaleImage()
                    // 将选中的图片添加到图片数组
                    self.photos.append(newImage!)
                    self.reloadSections(IndexSet(integer: 0))

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PhotoSelectorViewReloadNoti"), object: nil)
                }
            }

        }
    }
    
    func imagePickerControllerDidCancel(picker: MTImagePickerController) {

    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension HDLY_PhotoSelectorView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        originalPhotos.append(image)
        
        let newImage = image.scaleImage()
        // 将选中的图片添加到图片数组
        photos.append(newImage)
        reloadSections(IndexSet(integer: 0))
        picker.dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PhotoSelectorViewReloadNoti"), object: nil)
        }

    }
}

extension HDLY_PhotoSelectorView {
    /// 本地图片
    private func openPhotoBrowserWithLocalImage(index: Int) {
//        var localImages: [UIImage] = []
//        (0..<9).forEach { _ in
//            localImages.append(UIImage(named: "xingkong")!)
//        }
        
        // 默认使用 .fade 转场动画，不需要实现任何协议方法
         PhotoBrowser.show(localImages: originalPhotos, originPageIndex: index)
        
        // 如果要使用 .scale，需要实现协议
//        PhotoBrowser.show
    }
}

