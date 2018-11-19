//
//  HDSSL_commentVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentVC: HDItemBaseVC {

    @IBOutlet weak var dTableView: UITableView!
    var exdataModel: ExhibitionDetailDataModel?
    var starNumber : CGFloat?  //评分
    
    //图片选择器
//    var imagePickerVc: UIImagePickerController?
    var collectionView: UICollectionView?
    var layout: LxGridViewFlowLayout?
    var location: CLLocation?
    var selectedPhotos : NSMutableArray = NSMutableArray.init()
    var selectedAssets : NSMutableArray = NSMutableArray.init()
    var isSelectOriginalPhoto: Bool?
    var itemWH: CGFloat?
    var margin: CGFloat?
    var maxPic: Int? //做多图片数量
    
    lazy var imagePickerVc = UIImagePickerController.init()
    
    var pickerImgCell:HDSSL_commentImgCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        maxPic = 9
        
        //UI
        loadMyViews()
        loadTableView()
        
        //Data
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        margin = 20
        
        itemWH = (ScreenWidth - 4 * margin!) / 3
        layout?.itemSize = CGSize.init(width: itemWH!, height: itemWH!)
        layout?.minimumLineSpacing = margin!
        layout?.minimumInteritemSpacing = margin!
        self.collectionView?.setCollectionViewLayout(layout!, animated: true)
        
        dTableView.reloadData()
        self.collectionView?.reloadData()
    }
    // UI
    func loadMyViews() {
        self.title = "评论"
        
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        publishBtn.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
        publishBtn.addTarget(self, action: #selector(action_publish), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        //
        imagePickerVc.delegate = self
        imagePickerVc.navigationBar.barTintColor = self.navigationController?.navigationBar.barTintColor
        imagePickerVc.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor
//        let tzBarItem: UIBarButtonItem?
//        let BarItem: UIBarButtonItem?
//
//        if #available(iOS 9, *) {
//            //
//            tzBarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [TZImagePickerController.self])
//            BarItem = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIImagePickerController.self])
//        }
//        let attribiteDic = [tzBarItem?.titleTextAttributes(for: .normal)] as! [NSAttributedString.Key : Any]
//
//        BarItem?.setTitleTextAttributes(attribiteDic, for: .normal)
        
    }
    //MARK: --collectionView
    func configCollectionView() -> UICollectionView {
        if collectionView == nil {
            layout = LxGridViewFlowLayout.init()
            itemWH = (ScreenWidth - 4 * margin!) / 3
            layout?.itemSize = CGSize.init(width: itemWH!, height: itemWH!)
            layout?.minimumLineSpacing = 10
            layout?.minimumInteritemSpacing = 10
            
            collectionView  = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 350), collectionViewLayout: layout!)
//            collectionView?.isScrollEnabled = false
            collectionView?.alwaysBounceVertical = true
            collectionView?.backgroundColor = UIColor.white
            collectionView?.contentInset = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
            collectionView?.register(TZTestCell.self, forCellWithReuseIdentifier: "TZTestCell")
        }
        return collectionView!
    }
    
    //actions
    @objc func action_publish(){
        print("发布")
    }
    

}
extension HDSSL_commentVC: UITableViewDataSource,UITableViewDelegate {
    func loadTableView() {
        dTableView.delegate = self
        dTableView.dataSource = self
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
             return 410
        }
        if selectedPhotos.count >= 0 && selectedPhotos.count < 3{
            return 100 + 40
        }else if selectedPhotos.count >= 3  && selectedPhotos.count < 6 {
            return 80 * 2 + 30 + 80
        }else {
            return 80 * 3 + 40 + 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = HDSSL_commentTextCell.getMyTableCell(tableV: tableView) as HDSSL_commentTextCell
            cell.BlockBackStarNumber { (number) in
                print("评分%.1f",number)
                self.starNumber = number  //保存评分
            }
            return cell
        }else {
            pickerImgCell = HDSSL_commentImgCell.getMyTableCell(tableV: tableView) as HDSSL_commentImgCell
            
            pickerImgCell!.cell_collectBg.addSubview(self.configCollectionView())
            
            return pickerImgCell!
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

extension HDSSL_commentVC: TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate {
    //进入相册
    func pushTZImagePickerController(){
        let imagePickerVc = TZImagePickerController.init(maxImagesCount: maxPic!, columnNumber: 4, delegate: self, pushPhotoPickerVc: true)
        
        // 1.设置目前已经选中的图片数组
        imagePickerVc!.selectedAssets = selectedAssets; // 目前已经选中的图片数组
        imagePickerVc!.allowTakePicture = true
        imagePickerVc!.allowTakeVideo = false
        
        // 你可以通过block或者代理，来得到用户选择的照片.
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//
//            }];
        
        self.present(imagePickerVc!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //
        picker.dismiss(animated: true, completion: nil)
        
        //
        let type = info[UIImagePickerControllerMediaType] as! String
        
        let tzImagePickerVc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        
        tzImagePickerVc?.sortAscendingByModificationDate = true
        
        tzImagePickerVc?.showProgressHUD()
        
        if type == "public.image" {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            TZImageManager.default()?.savePhoto(with: image, location: self.location, completion: { (asset, error) in
                //
                tzImagePickerVc?.hideProgressHUD()
                
                //
                if error != nil{
                    print("保存图片失败")
                }else {
                    let assetModel = TZImageManager.default()?.createModel(with: asset)
                    
                    self.refreshCollectionViewWithAddedAsset((assetModel?.asset)!, image)
                }
            })
            
        }
        
    }
    //取消
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.isKind(of: UIImagePickerController.self) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        print("用户点击取消")
    }
 
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        //
        selectedPhotos = NSMutableArray.init(array: photos)
        selectedAssets = NSMutableArray.init(array: assets)
        
        self.isSelectOriginalPhoto = isSelectOriginalPhoto
        
        collectionView?.reloadData()
        dTableView.reloadData()
    }
    
    // 决定相册显示与否
    func isAlbumCanSelect(_ albumName: String!, result: PHFetchResult<AnyObject>!) -> Bool {
        return true
    }
    
    //刷新
    func refreshCollectionViewWithAddedAsset(_ asset: PHAsset,_ image: UIImage) -> Void {
        //
        selectedAssets.add(asset)
        selectedPhotos.add(image)
        collectionView?.reloadData()
        dTableView.reloadData()
    }
    
    
    
}
extension HDSSL_commentVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPhotos.count >= maxPic! {
            return selectedPhotos.count
        }
        return selectedPhotos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TZTestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TZTestCell", for: indexPath) as! TZTestCell
        cell.videoImageView.isHidden = true
        if indexPath.item == selectedPhotos.count {
            cell.imageView.image = UIImage.init(named: "AlbumAddBtn.png")
            cell.deleteBtn.isHidden = true
            cell.gifLable.isHidden = true
        }else {
            cell.imageView.image = selectedPhotos[indexPath.item] as! UIImage
            cell.asset = selectedAssets[indexPath.item]
            cell.deleteBtn.isHidden = false
            cell.gifLable.isHidden = true
        }
        
        cell.deleteBtn.tag = indexPath.item
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnClik(_ :)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedPhotos.count {
            self.pushTZImagePickerController()
        }else {
            
        }
    }
    
    //MARK: LxGridViewDataSource
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if indexPath.isEmpty == true {
            return false
        }
        return indexPath.item < selectedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, itemAt sourceIndexPath: IndexPath,canMoveTo destinationIndexPath: IndexPath) -> Bool {
        //
        return (sourceIndexPath.item < selectedPhotos.count && destinationIndexPath.item < selectedPhotos.count)
    }
    func collectionView(_ collectionView: UICollectionView, itemAt sourceIndexPath: IndexPath, didMoveTo destinationIndexPath: IndexPath) {
        let image = selectedPhotos[sourceIndexPath.item] as! UIImage
        
        selectedPhotos.removeObject(at: sourceIndexPath.item)
        selectedPhotos.insert(image, at: destinationIndexPath.item)
        
        let asset = selectedAssets[sourceIndexPath.item]
        selectedAssets.removeObject(at: sourceIndexPath.item)
        selectedAssets.insert(asset, at: destinationIndexPath.item)
        
        collectionView.reloadData()
    }
    
    //删除图片
    @objc func deleteBtnClik(_ sender: UIButton) {
        //
        if self.collectionView(collectionView!, numberOfItemsInSection: 0) <= selectedPhotos.count {
            selectedPhotos.removeObject(at: sender.tag)
            selectedAssets.removeObject(at: sender.tag)
            collectionView?.reloadData()
            return
        }
        
        selectedPhotos.removeObject(at: sender.tag)
        selectedAssets.removeObject(at: sender.tag)
        collectionView?.performBatchUpdates({
            
            let indexp = IndexPath.init(item: sender.tag, section: 0)
            self.collectionView?.deleteItems(at: [indexp])
            
        }, completion: { (finished) in
            self.collectionView?.reloadData()
        })
        
    }
}
