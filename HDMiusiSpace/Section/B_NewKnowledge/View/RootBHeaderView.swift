//
//  RootBHeaderView.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/7.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class RootBHeaderView: UIView {
    
    @IBOutlet weak var searchBgView: UIView!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = .zero
            self.pagerView.automaticSlidingInterval = 2
            self.pagerView.transformer = FSPagerViewTransformer(type:.linear)
            let transform = CGAffineTransform(scaleX: 0.85, y: 0.8)
            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        }
    }
    
    @IBOutlet weak var pageControl: FSPageControl! {
        didSet {
            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchBgView.layer.cornerRadius = 10
        searchBgView.layer.masksToBounds = true
        
    }
}












