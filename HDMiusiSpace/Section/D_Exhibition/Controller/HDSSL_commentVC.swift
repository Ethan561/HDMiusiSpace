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
    //传递参数
    var exhibition_id: Int?  //展览id
    var exdataModel: ExhibitionDetailDataModel?//展览详情数据
    
    var starNumber : Int?  //评分
    var commentContent: String? //评论文字内容
    //图片选择器
    lazy var imagePickerView = SSL_PickerView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 350))
    var commentPhotos: [UIImage] = Array.init() //选择照片数组
    
    var pickerImgCell:HDSSL_commentImgCell?
    
    var ImagePathArray: Array<String> = Array.init() //上传图片地址数组
    
    //mvvm
    var viewModel: HDSSL_commentVM = HDSSL_commentVM()
    var commentId: Int? //发布成功，返回评论id
    var htmlShareUrl:String? //发布成功，返回分享地址
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI
        loadMyViews()
        loadTableView()
        bindViewModel()
        //Data
        
    }
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: - MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //展览data
        viewModel.backDic.bind { (dic) in

            let model: HDSSL_commentResultModel = dic
            
            self.commentId = model.comment_id   //评论id
            self.htmlShareUrl = model.html_url  //分享地址

            //跳到发布成功页面
            weakSelf?.jumpSuccessVC()
        }
        
        
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
        
        if self.commentContent?.count == 0 {
            HDAlert.showAlertTipWith(type: HDAlertType.onlyText, text: "请输入评论内容")
            return
        }
        
        if self.commentPhotos.count == 0 {
            //无图评论
            //正式发布
            self.viewModel.request_PublishCommentWith(exhibitId: self.exhibition_id!, star: self.starNumber!, content: self.commentContent
                ?? "", uploadImags: self.ImagePathArray, self)
        }else {
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
            return 100 + 40
        }else if commentPhotos.count >= 3  && commentPhotos.count < 6 {
            return 80 * 2 + 30 + 80
        }else {
            return 80 * 3 + 40 + 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = HDSSL_commentTextCell.getMyTableCell(tableV: tableView) as HDSSL_commentTextCell
            //图片
            cell.cell_img.kf.setImage(with: URL.init(string: String.init(format: "%@", (self.exdataModel?.data?.imgList?[0]) ?? "")), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
            //标题
            cell.cell_titleT.text = String.init(format: "%@", (self.exdataModel?.data?.title!)!)
            
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
            
//            pickerImgCell!.cell_collectBg.addSubview(self.configCollectionView())
//            imagePickerView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 350)
            imagePickerView.superVC = self
            imagePickerView.delegate = self
            pickerImgCell?.cell_collectBg.addSubview(imagePickerView)
            
            return pickerImgCell!
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

extension HDSSL_commentVC:SSL_PickerViewDelegate {
    //MARK:返回图片数组
    func getBackSelectedPhotos(_ images: [Any]!) {
        print(images)
        self.commentPhotos = images as! [UIImage]
        self.dTableView.reloadData()
    }
    
    func didSelectedItem(at itemIndex: Int) {
        print(itemIndex)
        let vc = HD_SSL_BigImageVC.init()
        vc.imageArray = commentPhotos
        vc.atIndex = itemIndex
        self.present(vc, animated: true, completion: nil)
    }
    
}
