//
//  HDSSL_MyWalletVC.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/27.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_MyWalletVC: HDItemBaseVC {

    @IBOutlet weak var btn_openVIP: UIButton!
    @IBOutlet weak var goldNumberL: UILabel!
    @IBOutlet weak var menuBg1: UIView!  //余额背景
    @IBOutlet weak var menuBg2: UIView!  //开通VIP背景
    @IBOutlet weak var goodBgView: UIView!
    @IBOutlet weak var collectionview: UICollectionView!
    //mvvm
    private var viewModel = HDZQ_MyViewModel()
    var loadingView: HDLoadingView?

    var goodsData: GoodsData?
    var chooseProduct: GoodsList?
    
    var goodArray: [UIView] = Array.init() //商品
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMyViews()
        bindViewModel()
        dataRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(dataRequest), name: NSNotification.Name.init(rawValue: "HDLY_IAPStore_verifyPruchaseSuccess_Noti"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeLodingNoti(noti:)), name: NSNotification.Name.init(rawValue: "HDLY_IAPStore_MyWalletCloseLoading_Noti"), object: nil)
        
    }
    
    //MVVM
    func bindViewModel() {
        weak var weakSelf = self
        
        //标签数组
        viewModel.goodsData.bind { (gooddata) in
            weakSelf?.reloadUI(gooddata)
        }
        
        
    }
    
    @objc func dataRequest() {
        chooseProduct = nil
        viewModel.requestMyWalletData(apiToken: HDDeclare.shared.api_token!, vc: self)
    }
    
    func loadMyViews() {
        
        title = "我的钱包"
        
        //右侧按钮
        let publishBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        publishBtn.setTitle("交易记录", for: .normal)
        publishBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        publishBtn.setTitleColor(UIColor.black, for: .normal)
        publishBtn.addTarget(self, action: #selector(action_goToTransactionRecord), for: .touchUpInside)
        
        let item = UIBarButtonItem.init(customView: publishBtn)
        self.navigationItem.rightBarButtonItem = item
        
        menuBg1.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        menuBg2.configShadow(cornerRadius: 10, shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, shadowOffset: CGSize.zero)
        
        btn_openVIP.addRoundedCorners(corners: [UIRectCorner.topRight, UIRectCorner.bottomRight], radii: CGSize.init(width: 10, height: 10))
        
        //collectionView
        let layout = UICollectionViewFlowLayout()
        let itemW = 160
        let itemH = 90
        
        layout.itemSize = CGSize(width: itemW, height: itemH)
        layout.scrollDirection = .vertical
        
        collectionview.delegate = self
        collectionview.dataSource = self
        
        collectionview.collectionViewLayout = layout
        collectionview.register(UINib.init(nibName: HD_goodsCell.className, bundle: nil), forCellWithReuseIdentifier: HD_goodsCell.className)
        
        if #available(iOS 11.0, *) {
            collectionview.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        collectionview.reloadData()
        //MARK: 暂时隐藏VIP充值入口
        menuBg2.isHidden = true
    }
    
    func reloadUI(_ goodd: GoodsData) {
        //
        self.goodsData = goodd
        //刷新界面
        goldNumberL.text = self.goodsData?.spaceMoney
        //
        var productIDArr:Array<String> = Array.init()
        if (self.goodsData?.goodsList?.count)! > 0 {
            for model in goodsData!.goodsList! {
                if model.product_id != nil {
                    productIDArr.append(model.product_id!)
                }
            }
            if productIDArr.count > 0 {
                HDLY_IAPStore.shared.getList(productIDArr)
            }
             collectionview.reloadData()
        }
       
    }
    
    //MARK:-- 交易记录
    @objc func action_goToTransactionRecord() {
        //
        print("交易记录")
        self.performSegue(withIdentifier: "PushToTransactionRecordVC", sender: nil)
    }

    //开通会员
    @IBAction func action_openVIP(_ sender: UIButton) {
        print("开通会员")
    }
    //充值
    @IBAction func action_recharge(_ sender: UIButton) {
        print("充值")
        if chooseProduct != nil {
            loadingView = HDLoadingView.createViewFromNib() as? HDLoadingView
            loadingView?.frame = self.view.bounds
            view.addSubview(loadingView!)
            
            HDLY_IAPStore.shared.buyProduceWithProdectID(chooseProduct!.product_id!)
        } else {
            HDAlert.showAlertTipWith(type: .onlyText, text: "请先选择充值金额")
        }
        HDLY_IAPStore.shared.requestProducts(nil)
    }
    
    @objc func closeLodingNoti(noti: Notification) {
        self.loadingView?.removeFromSuperview()
    }
    
}

//private let reuseIdentifier = "Cell"

extension HDSSL_MyWalletVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK: ----- UICollectionView ---
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.goodsData == nil {
            return 0
        }
        return (self.goodsData?.goodsList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            
            let reuseIdentifier = HD_goodsCell.className+"\(indexPath.section)"+"\(indexPath.row)"
            
            collectionView.register(UINib.init(nibName: HD_goodsCell.className, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            
            let cell:HD_goodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HD_goodsCell
            
            cell.cellData = self.goodsData?.goodsList![indexPath.row]
            
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if goodsData?.goodsList != nil {
            let model = goodsData!.goodsList![indexPath.row]
            chooseProduct = model
        }
        
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemW = (ScreenWidth-20*3)/2.0
        let itemH = itemW*90/160.0
        
        return CGSize.init(width: itemW, height: itemH)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {


        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}
