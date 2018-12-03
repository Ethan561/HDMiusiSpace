//
//  HDZQ_DayCardBrowserVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/12/3.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_DayCardBrowserVC: HDItemBaseVC {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shareBtn: UIButton!
    public var index = 0
    public var dayList = [DayCardModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(index + 1)/\(dayList.count)"
        isShowNavShadowLayer = false
        shareBtn.layer.cornerRadius = 22.0
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        layout.itemSize = CGSize(width: ScreenWidth - 40, height: (ScreenWidth - 40)*10/7)
        collectionView.collectionViewLayout = layout
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLeftBar()
        setNavBar()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath.init(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }

    func setLeftBar() {
        let leftBarBtn = UIButton.init(type: UIButtonType.custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 45, height: 45)
        leftBarBtn.setImage(UIImage.init(named: "nav_back_white"), for: UIControlState.normal)
        leftBarBtn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
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
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBar.layer.shadowColor = UIColor.black.cgColor
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
    }
    
}


class HDZQ_DayCardBrowserCell:UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
