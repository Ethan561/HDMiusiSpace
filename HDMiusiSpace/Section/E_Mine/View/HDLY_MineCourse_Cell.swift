//
//  HDLY_MineCourse_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/5.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit


protocol HDLY_MineCourse_Cell_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:MyCollectCourseModel, _ cell: HDLY_MineCourse_Cell)
}

class HDLY_MineCourse_Cell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var listArray: Array<MyCollectCourseModel>? {
        didSet{
            myCollectionView.reloadData()
        }
    }
    weak var delegate: HDLY_MineCourse_Cell_Delegate?
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MineCourse_Cell! {
        var cell: HDLY_MineCourse_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MineCourse_Cell.className) as? HDLY_MineCourse_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MineCourse_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MineCourse_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MineCourse_Cell.className, owner: nil, options: nil)?.first as? HDLY_MineCourse_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        //cell width
        let itemW: Float = 200
        let itemH = 140
        layout.itemSize = CGSize.init(width: CGFloat(itemW), height: CGFloat(itemH))
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 5
        self.myCollectionView.setCollectionViewLayout(layout, animated: true)
        //
        self.myCollectionView.scrollsToTop = false
        self.myCollectionView.showsVerticalScrollIndicator = false
        self.myCollectionView.showsHorizontalScrollIndicator = false
        self.myCollectionView.register(UINib.init(nibName: HDLY_MineCourse_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_MineCourse_CollectionCell.className)
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.myCollectionView.reloadData()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: ---
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listArray != nil {
            return listArray!.count > 5 ? 5 : listArray!.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HDLY_MineCourse_CollectionCell = HDLY_MineCourse_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
                let model = listArray![indexPath.row]
                cell.imgV.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                cell.nameL.text = model.title
                cell.learnProgressLabel.text = "已学\(model.percentage)%"
                cell.progressView.progress = Float(Double(model.percentage)/100.0)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listArray![indexPath.row]
        delegate?.didSelectItemAt(model, self)
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat  = 140
        let width:CGFloat   = 140
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

