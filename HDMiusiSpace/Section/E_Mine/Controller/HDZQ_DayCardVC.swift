//
//  HDZQ_DayCardVC.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_DayCardVC: HDItemBaseVC {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "收藏的日卡"
        tableView.rowHeight = ScreenWidth * 1.25 + 60
        requestDayCardData()
    }
}

extension HDZQ_DayCardVC {
    private func requestDayCardData() {
        HD_LY_NetHelper.loadData(API: HD_ZQ_Person_API.self, target: .getMyDayCards(api_token: HDDeclare.shared.api_token ?? "", skip: 0, take: 10), success: { (result) in
            
        }) { (error, msg) in
            
        }
    }
}

extension HDZQ_DayCardVC:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HDZQ_DayCardTableViewCell") as? HDZQ_DayCardTableViewCell
        return cell!
    }
    
    
}

extension HDZQ_DayCardVC:UITableViewDelegate {
    
}


class HDZQ_DayCardTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let layout = HDetailItemColletionViewLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: ScreenWidth - 60, height: (ScreenWidth)*1.25)
        collectionView.collectionViewLayout = layout
    }
}

extension HDZQ_DayCardTableViewCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HDZQ_DayCardCollectionViewCell", for: indexPath) as? HDZQ_DayCardCollectionViewCell
        return cell!
    }
    
    
}

extension HDZQ_DayCardTableViewCell:UICollectionViewDelegate {
    
}

class HDZQ_DayCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var darCardImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        darCardImageView.layer.cornerRadius = 15
        darCardImageView.clipsToBounds = true
    }
}


class HDetailItemColletionViewLayout: UICollectionViewFlowLayout {
    
    /**
     * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
     * 刷新的话，会调用下面的方法
     * 1.prepareLayout
     * 2.layoutAttributesForElementsInRect:
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 用来布局的初始化操作，不建议在init方法中进行布局的初始化操作
    override func prepare() {
        super.prepare()
        
        // 设置水平滚动
        scrollDirection = .horizontal
        
        // 设置内边距
        let inset = (collectionView!.frame.width - itemSize.width) * 0.5
        sectionInset = UIEdgeInsetsMake(0, 30, 0, 30)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        // 1.获取super已经计算好的布局属性
        let originalArr = super.layoutAttributesForElements(in: rect)
        let array = NSArray.init(array: originalArr!) as! [UICollectionViewLayoutAttributes]

        // 2.计算collectionView最中心点的x值
        let centerX = collectionView!.contentOffset.x + (collectionView!.frame.width * 0.5)

        // 3.在原有布局属性的基础上，进行微调
        for attrs in array {

            // 3.1 cell的中心点，和collectionView最中心点的x值的间距
            let delta = abs(attrs.center.x - centerX)

            var scale = 1 - (delta / collectionView!.frame.width * 0.3)

            if scale < 0.9 {
                scale = 0.9
            }
            // 3.2 设置缩放比例
            attrs.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        return array
    }
//
    /// 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
//    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height)
        
        // 获取super已经计算好的属性
        let array = super.layoutAttributesForElements(in: rect)
        
        // 计算collectionView最中心点的x值
        let centerX = proposedContentOffset.x + collectionView!.frame.width * 0.5
        var minDelta = CGFloat(MAXFLOAT)
        
        for attrs in array! {
            if abs(minDelta) > abs(attrs.center.x - centerX) {
                minDelta = attrs.center.x - centerX;
            }
        }
        // 修改原有的偏移量
        let offsetX =  proposedContentOffset.x + minDelta
        
        return CGPoint(x: offsetX, y: proposedContentOffset.y)
        
        
    }
}

