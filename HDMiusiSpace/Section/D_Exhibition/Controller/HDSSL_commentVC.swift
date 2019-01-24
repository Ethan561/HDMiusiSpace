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
    @IBOutlet weak var deleteImgBtn: UIButton!
    
    //传递参数
    var exhibition_id: Int?  //展览id
    var exdataModel: ExhibitionDetailDataModel?//展览详情数据
    
    var starNumber : Int?  //评分
    var commentContent: String? //评论文字内容
    //图片选择器
    lazy var imagePickerView = SSL_PickerView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 430))
    var commentPhotos: [UIImage] = Array.init() //选择照片数组
    
    var pickerImgCell:HDSSL_commentImgCell?
    
    var ImagePathArray: Array<String> = Array.init() //上传图片地址数组
    
    //mvvm
    var exViewModel  : HDSSL_ExDetailVM = HDSSL_ExDetailVM()  //获取展览详情
    var viewModel    : HDSSL_commentVM = HDSSL_commentVM()      //发布评论
    var commentId    : Int? //发布成功，返回评论id
    var htmlShareUrl :String? //发布成功，返回分享地址
    var isHideDropimg: Bool = false //拖拽删除提示信息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        loadMyViews()
        loadTableView()
        bindViewModel()
        //Data
        loadMyDatas()
        
        self.starNumber = 9
        
        deleteImgBtn.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
    }
    //MARK: 加载数据
    func loadMyDatas() {
        //请求数据
        guard let exID = exhibition_id else {
            return
        }
        exViewModel.request_getExhibitionDetail(exhibitionId: exID, vc: self)
    }
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        
        //展览data
        exViewModel.exhibitionData.bind { (data) in
            
            weakSelf?.showViewData(data)
            
        }
        //发布成功
        viewModel.backDic.bind { (dic) in

            let model: HDSSL_commentResultModel = dic
            
            self.commentId = model.comment_id   //评论id
            self.htmlShareUrl = model.html_url  //分享地址

            //跳到发布成功页面
            weakSelf?.jumpSuccessVC()
            //发送通知刷新展览详情页面评论数据
            NotificationCenter.default.post(name: NSNotification.Name.init("KNoti_Refresh_Comments"), object: nil)
        }
        
        
    }
    //处理返回数据
    func showViewData(_ data:ExhibitionDetailDataModel) {
        self.exdataModel = data
        
        self.dTableView.reloadData()
    }
    func jumpSuccessVC()  {
        //上传图片，得到图片地址，开始发布
        let commentSvc = self.storyboard?.instantiateViewController(withIdentifier: "HDSSL_commentSucVC") as! HDSSL_commentSucVC
        commentSvc.commentId = self.commentId
        commentSvc.htmlShareUrl = self.htmlShareUrl
        self.navigationController?.pushViewController(commentSvc, animated: true)
    }
    // UI
    func loadMyViews() {
        //标题
        self.title = "评论"
        //发布按钮
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("发布", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        publishBtn.setTitleColor(UIColor.HexColor(0xE8593E), for: .normal)
        publishBtn.addTarget(self, action: #selector(action_publish), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
    }
    
    //actions
    @objc func action_publish(){
        print("发布")
        if HDDeclare.shared.loginStatus != .kLogin_Status_Login {
            self.pushToLoginVC(vc: self)
            return
        }
        
        if self.commentContent?.count == 0 || self.commentContent == nil {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入评论内容")
            return
        }
        
        if self.commentPhotos.count == 0 {
            //无图评论
            //正式发布
            self.viewModel.request_PublishCommentWith(exhibitId: self.exhibition_id!, star: self.starNumber!, content: self.commentContent
                ?? "", uploadImags: self.ImagePathArray, self)
        } else {
            //有图评论，先上传评论
            uploadImage()
        }
        
    }

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
//MARK: 上传图片
extension HDSSL_commentVC {
    func uploadImage() {
        //
        if commentPhotos.count > 0 {
            
            guard HDDeclare.shared.api_token != nil else{
                return
            }
            self.ImagePathArray.removeAll()
            //子线程循环上传
            DispatchQueue.main.async {
                
                let  loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
                loadingView?.frame = self.view.bounds
                self.view.addSubview(loadingView!)
                
                
                for i in 0..<self.commentPhotos.count {
                    
                    let image: UIImage = self.commentPhotos[i] as! UIImage
                    
                    var imgData = UIImagePNGRepresentation(image)
                    
                    //超过5M压缩
                    if (Double(imgData!.count)/1024.0/1204.0) > 5 {
                        
//                        imgData = HDDeclare.resetImgSize(sourceImage: image, maxImageLenght: image.size.width*0.5, maxSizeKB: 1024*5)//最大1M
                        imgData = UIImage.resetImgSize(sourceImage: image, maxImageLenght: image.size.width*0.5, maxSizeKB: 1024*5)//最大1M
                    }
                    
                    //
                    HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .uploadImg(api_token: HDDeclare.shared.api_token!, uoload_img: imgData!), success: { (result) in
                        
                        let dic = HD_LY_NetHelper.dataToDictionary(data: result)
                        LOG("\(String(describing: dic))")
                        let imgPath:String? = dic!["data"] as? String
                        let imgUrl: String =  (imgPath != nil ? imgPath! : "")
                        
                        self.ImagePathArray.append(imgUrl)
                        
                        if self.ImagePathArray.count == self.commentPhotos.count {
                            
                            loadingView?.removeFromSuperview()
                            
                            //正式发布
                            self.viewModel.request_PublishCommentWith(exhibitId: self.exhibition_id!, star: self.starNumber!, content: self.commentContent
                                ?? "", uploadImags: self.ImagePathArray, self)
                            
                        }
                    }) { (errorCode, msg) in
                        
                        loadingView?.removeFromSuperview()
                        HDAlert.showAlertTipWith(type: HDAlertType.error, text: "上传失败!")
                    }
                    
                    
                    //
                    
                }
                
            }
            
        }
    }
}
//MARK: TableView
extension HDSSL_commentVC: UITableViewDataSource,UITableViewDelegate {
    func loadTableView() {
        dTableView.delegate = self
        dTableView.dataSource = self
        if #available(iOS 11.0, *){
            self.dTableView.estimatedRowHeight = 0
            self.dTableView.estimatedSectionFooterHeight = 0
            self.dTableView.estimatedSectionHeaderHeight = 0
        }
    }
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
             return 410
        }
        if commentPhotos.count >= 0 && commentPhotos.count < 3{
            return 80 + 58 + 80
        }else if commentPhotos.count >= 3  && commentPhotos.count < 6 {
            return 80 * 2 + 96 + 80
        }else {
            return 80 * 3 + 130 + 80
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = HDSSL_commentTextCell.getMyTableCell(tableV: tableView) as HDSSL_commentTextCell
            //图片
            cell.cell_img.kf.setImage(with: URL.init(string: String.init(format: "%@", (self.exdataModel?.data?.imgList?[0]) ?? "")), placeholder: UIImage.grayImage(sourceImageV: cell.cell_img), options: nil, progressBlock: nil, completionHandler: nil)
            //标题
            cell.cell_titleT.text = String.init(format: "%@", self.exdataModel?.data?.title ?? "")
            
            cell.BlockBackStarNumber { (number) in
                print("评分%d",number)
                self.starNumber = number //保存评分
            }
            cell.BlockBackCommentText { (text) in
                self.commentContent = text //保存文字内容
            }
            
            
            return cell
        }else {
            pickerImgCell = HDSSL_commentImgCell.getMyTableCell(tableV: tableView) as HDSSL_commentImgCell
            //加载图片选择器
            imagePickerView.superVC = self
            imagePickerView.delegate = self
            pickerImgCell?.cell_collectBg.addSubview(imagePickerView)
            pickerImgCell?.BlockHideDropImgFunc(block: { (index) in
                self.isHideDropimg = true;
            })
            if self.commentPhotos.count > 0 {
                pickerImgCell?.img_tip.isHidden = true
                if isHideDropimg == true {
                    pickerImgCell?.img_drop.isHidden = true
                }else {
                    pickerImgCell?.img_drop.isHidden = false
                }
                
            }else{
                pickerImgCell?.img_tip.isHidden = false
                pickerImgCell?.img_drop.isHidden = true
            }
            return pickerImgCell!
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //知识点：ios11以下，重置高度，防止页面刷新时发生抖动
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 410
        }
        if commentPhotos.count >= 0 && commentPhotos.count < 3{
            return 80 + 58 + 80
        }else if commentPhotos.count >= 3  && commentPhotos.count < 6 {
            return 80 * 2 + 96 + 80
        }else {
            return 80 * 3 + 130 + 80
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension HDSSL_commentVC:SSL_PickerViewDelegate {
    //MARK:返回图片数组
    func getBackSelectedPhotos(_ images: [Any]!) {
        print(images)
        self.commentPhotos = images as! [UIImage]
        
        //
//        if self.commentPhotos.count == 0 {
//            deleteImgBtn.isHidden = true
//        }else{
//            deleteImgBtn.isHidden = false
//        }
        
        //知识点：-- ios11系统后tableView刷新时，会自动估算cell、header、footer的高度，导致视图抖动
        self.dTableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with: .none) //刷新某个row
//        self.dTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .none) //刷新某个section
    }
    
    func didSelectedItem(at itemIndex: Int) {
        print(itemIndex)
        let vc = HD_SSL_BigImageVC.init()
        vc.imageArray = commentPhotos
        vc.atIndex = itemIndex
        self.present(vc, animated: true, completion: nil)
    }
    func beginDragingItem() {
        deleteImgBtn.isHidden = false
    }
    func endDragingItem() {
        deleteImgBtn.isHidden = true
    }
}
