//
//  HDLY_NumGuideVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_NumGuideVC: HDItemBaseVC {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var slide: UISlider!
    @IBOutlet weak var cleanBtn: UIButton!
    @IBOutlet weak var numL: UILabel!
    
    var numStr = ""
    var exhibit_num = 0
    
    var isFolder = false
    var tagsSelectIndex = 0
    var listArr = [ListenList]()
    var tagsArr = [ListenTags]()
    var dataArr = ["1","2","3","4","5","6","7","8","9","","0",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "古蜀华章——四川古代文物展"
        let layout = UICollectionViewFlowLayout()
        let itemW = 90
        let itemH = 60
        
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: HDLY_Listen_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Listen_CollectionCell.className)
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        dataRequest(cate_id: "-1")
    }
    
    @IBAction func cleanAction(_ sender: Any) {
        numStr = ""
    }
    
    @IBAction func sliderValueChangeAction(_ sender: UISlider) {
        
    }
    
    @objc func pageTitleViewToTop() {
        self.collectionView.contentOffset = CGPoint.zero
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func dataRequest(cate_id: String) {
        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListen(skip: "0", take: "10", cate_id: cate_id), showHud: false, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseListen = try! jsonDecoder.decode(CourseListen.self, from: result)
            self.tagsArr = model.data.cates
            self.listArr = model.data.list
            if cate_id == "-1" {
                self.collectionView.reloadData()
            }else {
                self.collectionView.reloadSections(IndexSet.init(integer: 1))
            }
            
        }) { (errorCode, msg) in
            self.collectionView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action:#selector(self.refreshAction))
            self.collectionView.ly_showEmptyView()
        }
    }
    
    @objc func refreshAction() {
        dataRequest(cate_id: "-1")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func folderBtnAction(_ sender: UIButton)  {
        sender.isSelected = !sender.isSelected
        isFolder = sender.isSelected
        collectionView.reloadData()
    }
    
}

private let reuseIdentifier = "Cell"

extension HDLY_NumGuideVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: ----- UICollectionView ---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            let reuseIdentifier = HDLY_NumCollectionCell.className+"\(indexPath.section)"+"\(indexPath.row)"
            
            collectionView.register(UINib.init(nibName: HDLY_NumCollectionCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            
            let cell:HDLY_NumCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HDLY_NumCollectionCell

            cell.titleL.text = dataArr[indexPath.row]
            if indexPath.row < 9 {
                cell.tagBtn.isHidden = true
            }
            if indexPath.row == 9{
                cell.tagBtn.setImage(UIImage.init(named: "dl_icon_sc"), for: UIControlState.normal)
            }
            
            if indexPath.row == 11{
                cell.tagBtn.setImage(UIImage.init(named: "dl_icon_paly_red"), for: UIControlState.normal)
            }
            
            
            return cell
        }
        
//        let cell:HDLY_Listen_CollectionCell = HDLY_Listen_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
//        if self.listArr.count > 0 {
//            let model = self.listArr[indexPath.row]
//            cell.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
//            cell.titleL.text = model.title
//            cell.countL.text = "\(model.listening)人听过"
//        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < 9 {
            numStr.append("\(indexPath.row+1)")
        }
        if indexPath.row == 10 {
            numStr.append("0")
        }
        if indexPath.row == 9 && numStr.count > 0{
            numStr.removeLast()
        }
        if numStr.count > 4 {
            numStr =  String(numStr.prefix(4))
        }
        numL.text = numStr
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = (ScreenWidth-20*3)/2.0
        let itemH = itemW*60/90.0
        if indexPath.section == 0 {
            return CGSize.init(width: 90, height: 60)
        }
        return CGSize.init(width: itemW, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width:CGFloat   = 90
        let space = (ScreenWidth-3*width)/4.0
        let spaceH:CGFloat = 20.0
        
        return UIEdgeInsets.init(top: spaceH, left: space, bottom: spaceH, right: space)
    }
    
    
}



