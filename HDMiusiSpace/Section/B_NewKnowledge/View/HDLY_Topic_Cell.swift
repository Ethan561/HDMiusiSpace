//
//  HDLY_Topic_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/11.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Topic_Cell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var listArray: NSArray? {
        didSet{
            myCollectionView.reloadData()
        }
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Topic_Cell! {
        var cell: HDLY_Topic_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_Topic_Cell.className) as? HDLY_Topic_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Topic_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_Topic_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_Topic_Cell.className, owner: nil, options: nil)?.first as? HDLY_Topic_Cell
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
        self.myCollectionView.register(UINib.init(nibName: HDLY_Topic_CollectionCell.className, bundle: nil), forCellWithReuseIdentifier: HDLY_Topic_CollectionCell.className)
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
//        if listArray != nil {
//            return listArray!.count
//        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HDLY_Topic_CollectionCell = HDLY_Topic_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
//                let model:HD_RootA_Exhibit = listArray?[indexPath.row] as! HD_RootA_Exhibit
//                cell.imgV.kf.setImage(with: URL.init(string: kNet_Ip_Address + model.list_img!), placeholder: UIImage.init(named: "互动课堂视频"), options: nil, progressBlock: nil, completionHandler: nil)
//                cell.nameL.text = model.title
//                cell.zanLabel.text = model.like_num?.string
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat  = 140 * ScreenWidth/375.0
        let width:CGFloat   = height * 10 / 7.0
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

