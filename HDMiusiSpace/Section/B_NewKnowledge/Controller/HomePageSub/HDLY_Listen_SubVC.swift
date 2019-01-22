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
    var player = HDLY_AudioPlayer.shared
    
    lazy var emptyView: UIView = {
        let emptyV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 260))
        emptyV.backgroundColor = UIColor.clear
        
        let imgV = UIImageView.init(image: UIImage.init(named: "img_nothing"))
        var imgViewWidth = imgV.image!.size.width
        var imgViewHeight = imgV.image!.size.height
        imgV.frame = CGRect.init(x: 0, y: 0, width: imgViewWidth, height: imgViewHeight)
        imgV.center = CGPoint.init(x: emptyV.ly_centerX, y: emptyV.ly_centerY-imgViewHeight*0.5)
        emptyV.addSubview(imgV)
        
        let titleL = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: emptyV.ly_width, height: 20))
        titleL.text = "还没有内容呢～"
        titleL.textAlignment = .center
        titleL.font = UIFont.systemFont(ofSize: 14)
        titleL.textColor = UIColor.lightGray
        titleL.center = CGPoint.init(x: emptyV.ly_centerX, y: imgV.ly_maxY+15)
        emptyV.addSubview(titleL)
        
        return emptyV
    }()

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
        
        
        self.emptyView.center = CGPoint.init(x: collectionView.ly_centerX, y: collectionView.ly_centerY-50)
        collectionView.addSubview(self.emptyView)
        self.emptyView.isHidden = true
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pageTitleViewToTop), name: NSNotification.Name.init(rawValue: "headerViewToTop"), object: nil)
        dataRequest(cate_id: "-1")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player.showFloatingBtn = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.showFloatingBtn = false

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

        HD_LY_NetHelper.loadData(API: HD_LY_API.self, target: .courseListen(skip: "0", take: "100", cate_id: cate_id), showHud: true, loadingVC: self, success: { (result) in
            let dic = HD_LY_NetHelper.dataToDictionary(data: result)
            LOG("\(String(describing: dic))")
            
            let jsonDecoder = JSONDecoder()
            let model:CourseListen = try! jsonDecoder.decode(CourseListen.self, from: result)
            self.tagsArr = model.data.cates
            self.listArr = model.data.list
            if self.listArr.count == 0 {
                self.emptyView.isHidden = false
            } else {
                self.emptyView.isHidden = true
            }
            if cate_id == "-1" {
                self.collectionView.reloadData()
            }else {
                self.collectionView.reloadSections(IndexSet.init(integer: 1))
            }
            
        }) { (errorCode, msg) in
            
            self.collectionView.ly_endLoading()
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
            if model.img != nil {
                cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.titleL.text = model.title
            cell.countL.text = "\(model.listening!)人听过"
            if model.is_voice == 0 {
                cell.voiceBtn.isHidden = true
            }else {
                cell.voiceBtn.isHidden = false
                cell.voiceBtn.addTouchUpInSideBtnAction { [weak self] (btn) in
                    if model.voice?.contains("http://") == true {
                        self?.playingAction(model)
                    }
                }
            }
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
            vc.listen_id = "\(model.listenID!)"
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
            var space = (ScreenWidth-5*width)/6
            if ScreenWidth == 320 {
                space = 5
            }
            return UIEdgeInsets.init(top: 10, left: space, bottom: 10, right: space)
        }
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func playingAction(_ model: ListenList) {
        guard let url = model.voice else {
            return
        }
        if player.state == .playing && player.url == url {
            return
        }
        var voicePath = model.voice!
        if voicePath.contains("m4a") {
            voicePath = model.voice!.replacingOccurrences(of: "m4a", with: "wav")
        }
        player.play(file: Music.init(name: "", url:URL.init(string: voicePath)!))
        player.url = url
        HDFloatingButtonManager.manager.floatingBtnView.show = true
        HDFloatingButtonManager.manager.listenID = "\(model.listenID!)"
        HDFloatingButtonManager.manager.iconUrl =  model.icon
        
    }
}




