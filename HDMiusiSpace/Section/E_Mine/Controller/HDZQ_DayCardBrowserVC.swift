//
//  HDZQ_DayCardBrowserVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/3.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_DayCardBrowserVC: HDItemBaseVC {
    private var tipView = HDLY_ShareView()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shareBtn: UIButton!
    public var index = 0
    public var dayList = [DayCardModel]()
    var shareView: HDLY_ShareView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(index + 1)/\(dayList.count)"
        isShowNavShadowLayer = false
        shareBtn.layer.cornerRadius = 22.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: ScreenWidth - 40, height: (ScreenWidth - 40)*10/7)
        collectionView.collectionViewLayout = layout
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLeftBar()
        setNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.shareBtn.isHidden {
            self.navigationController?.navigationBar.isHidden = false
            self.shareBtn.isHidden = false
            self.navigationController?.navigationBar.alpha = 1.0
            self.shareBtn.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath.init(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }

    func setLeftBar() {
        let leftBarBtn = UIButton.init(type: UIButton.ButtonType.custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBarBtn.setImage(UIImage.init(named: "nav_back_white"), for: UIControl.State.normal)
        leftBarBtn.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
    }
    
    func setNavBar() {
        //设置导航条背景颜色
        let navigationBar: UINavigationBar = (self.navigationController?.navigationBar)!
        navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar.barTintColor = UIColor.black
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.layer.shadowColor = UIColor.black.cgColor
    }
    
    @IBAction func shareAction(_ sender: Any) {
        tipView = HDLY_ShareView.createViewFromNib() as! HDLY_ShareView
        tipView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        tipView.delegate = self
        if kWindow != nil {
            kWindow!.addSubview(tipView)
        }
    }
}

extension HDZQ_DayCardBrowserVC: UMShareDelegate {
    func shareDelegate(platformType: UMSocialPlatformType) {
        
        guard let url = self.dayList[index].img else { return }
        //创建分享消息对象
        let messageObject = UMSocialMessageObject()
        //创建网页内容对象
        let thumbURL = url
        let shareObject = UMShareImageObject()
        shareObject.shareImage = thumbURL
        messageObject.shareObject = shareObject
        
        weak var weakS = self
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { data, error in
            if error != nil {
                //UMSocialLog(error)
                LOG(error)
                weakS?.shareView?.alertWithShareError(error!)
            } else {
                if (data is UMSocialShareResponse) {
                    let resp = data as? UMSocialShareResponse
                    //分享结果消息
                    LOG(resp?.message)
                    //第三方原始返回的数据
                    print(resp?.originalResponse ?? 0)
                } else {
                    LOG(data)
                }
                HDAlert.showAlertTipWith(type: .onlyText, text: "分享成功")
                HDLY_ShareGrowth.shareGrowthRequest()
                weakS?.shareView?.removeFromSuperview()
            }
        }
        
        
    }
}

extension HDZQ_DayCardBrowserVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let card = dayList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HDZQ_DayCardBrowserCell", for: indexPath) as? HDZQ_DayCardBrowserCell
        cell?.imgView.kf.setImage(with: URL.init(string: card.img!))
        return cell!
    }
    
    
}
extension HDZQ_DayCardBrowserVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.shareBtn.isHidden {
            self.navigationController?.navigationBar.isHidden = false
            self.shareBtn.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.alpha = 1.0
                self.shareBtn.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.navigationController?.navigationBar.alpha = 0.1
                self.shareBtn.alpha = 0.1
            }) { (complete) in
                if complete {
                    self.navigationController?.navigationBar.isHidden = true
                    self.shareBtn.isHidden = true
                }
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let idx = Int(scrollView.contentOffset.x / ScreenWidth)
        self.title = "\(idx + 1)/\(dayList.count)"
        self.index = idx
    }
    
}


class HDZQ_DayCardBrowserCell:UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.layer.cornerRadius = 10.0
        imgView.clipsToBounds = true
    }
}
