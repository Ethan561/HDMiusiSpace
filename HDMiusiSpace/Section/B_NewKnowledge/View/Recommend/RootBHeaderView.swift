//
//  RootBHeaderView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/7.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class RootBHeaderView: UIView {
    
    @IBOutlet weak var placeholderLab: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
//            self.pagerView.register(HDPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.register(UINib.init(nibName: "HDPagerViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
            self.pagerView.automaticSlidingInterval = 2
            self.pagerView.transformer = FSPagerViewTransformer(type:.linear)
//            let transform = CGAffineTransform(scaleX: 0.85, y: 0.8)
//            let size = self.pagerView.frame.size.applying(transform)
////            self.pagerView.itemSize = size
            self.pagerView.itemSize = CGSize.init(width: ScreenWidth - 40, height: (ScreenWidth - 40) * 190 / 335 )
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.setImage(UIImage(named:"banner_icon_default"), for: .normal)
            self.pageControl.setImage(UIImage(named:"banner_icon_pressed"), for: .selected)
            self.pageControl.itemSpacing = 12
            self.pageControl.interitemSpacing = 15

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBgView.layer.cornerRadius = 10
        searchBgView.layer.masksToBounds = true
        
    }
}












