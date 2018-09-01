//
//  HDLY_Listen_SubVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/8.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class HDLY_Listen_SubVC:                                                                               UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    lazy var collectionView: UICollectionView = {
        let myCollectionV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        
        return myCollectionV
    }()
    
    var isFolder = false
    var tagsSelectIndex = 0
    var listArr = [ListenList]()
    var tagsArr = [ListenTags]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let itemW = (ScreenWidth-20*3)/2.0
        let itemH = itemW*232/155.0
        
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout

        collectionView.backgroundColor = UIColor.white
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(self.collectionView)
        
        collectionView.register(UINib.init(nibName: HDLY_Listen_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Listen_CollectionCell.className)

        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        dataRequest(cate_id: "-1")
    }
    
    @objc func pageTitleViewToTop() {
        self.collectionView.contentOffset = CGPoint.zero
    }
    
    //监听子视图滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SubTableViewDidScroll"), object: scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //
        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-CGFloat(PageMenuH)-CGFloat(kTabBarHeight)-CGFloat(kTopHeight)-10)
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
    
    //MARK: ----- UICollectionView ---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if isFolder == true {
                return self.tagsArr.count+1
            }
            return 5
        }
        return self.listArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            let reuseIdentifier = HDLY_ListenTags_CollectionCell.className+"\(indexPath.section)"+"\(indexPath.row)"
    
            collectionView.register(UINib.init(nibName: HDLY_ListenTags_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            
            let cell:HDLY_ListenTags_CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HDLY_ListenTags_CollectionCell
            
            cell.tagBtn.isHidden = true
            if indexPath.row == tagsSelectIndex {
                cell.isSelected = true
            }
            if self.tagsArr.count > 0 && indexPath.row < 4 {
                let model = self.tagsArr[indexPath.row]
                cell.titleL.text = model.title
            }
            if indexPath.row == 4 {
                cell.isFolder = true
                cell.tagBtn.setImage(UIImage.init(named: "xinzhi_qingtingsuikan_icon_Arrow_default"), for: UIControlState.normal)
                cell.tagBtn.setTitle("", for: UIControlState.normal)
                cell.tagBtn.isHidden = false
                cell.tagBtn.addTarget(self, action: #selector(folderBtnAction(_:)), for: UIControlEvents.touchUpInside)
                cell.titleL.text = ""
            }
            if self.tagsArr.count > 0 &&  indexPath.row > 4 {
                let model = self.tagsArr[indexPath.row-1]
                cell.titleL.text = model.title
            }
            
            return cell
        }
        
        let cell:HDLY_Listen_CollectionCell = HDLY_Listen_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArr.count > 0 {
            let model = self.listArr[indexPath.row]
            cell.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            cell.titleL.text = model.title
            cell.countL.text = "\(model.listening)人听过"
        }
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row != 4 {
                tagsSelectIndex = indexPath.row
                collectionView.reloadData()
                if self.tagsArr.count > 0 && indexPath.row < 4 {
                    let model = self.tagsArr[indexPath.row]
                    dataRequest(cate_id: "\(model.cateID)")
                }
                if self.tagsArr.count > 0 &&  indexPath.row > 4 {
                    let model = self.tagsArr[indexPath.row-1]
                    dataRequest(cate_id: "\(model.cateID)")
                }
            }
        }
        if indexPath.section == 1 {
            let model = self.listArr[indexPath.row]
            let vc = UIStoryboard(name: "RootB", bundle: nil).instantiateViewController(withIdentifier: "HDLY_ListenDetail_VC") as! HDLY_ListenDetail_VC
            vc.listen_id = "\(model.listenID)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = (ScreenWidth-20*3)/2.0
        let itemH = itemW*232/155.0+60
        if indexPath.section == 0 {
            return CGSize.init(width: 54, height: 30)
        }
        return CGSize.init(width: itemW, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            let width:CGFloat   = 54
            let space = (ScreenWidth-5*width)/6
            return UIEdgeInsets.init(top: 10, left: space, bottom: 10, right: space)
        }
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




