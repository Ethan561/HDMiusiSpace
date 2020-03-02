//
//  HDLY_MuseumInfoType1Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

protocol HDLY_MuseumInfoType1Cell_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:DExhibitionList, _ cell: HDLY_MuseumInfoType1Cell)
}


class HDLY_MuseumInfoType1Cell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoType1Cell! {
        var cell: HDLY_MuseumInfoType1Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoType1Cell.className) as? HDLY_MuseumInfoType1Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoType1Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoType1Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoType1Cell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoType1Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var listArray: Array<DExhibitionList>? {
        didSet{
            myCollectionView.reloadData()
        }
    }
    weak var delegate: HDLY_Topic_Cell_Delegate?
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Topic_Cell! {
        var cell: HDLY_Topic_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_Topic_Cell.className) as? HDLY_Topic_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Topic_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_Topic_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_Topic_Cell.className, owner: nil, options: nil)?.first as? HDLY_Topic_Cell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
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
        
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
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
        if listArray != nil {
            return listArray!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HDLY_Topic_CollectionCell = HDLY_Topic_CollectionCell.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
                let model = listArray![indexPath.row]
                if  model.img != nil  {
                    cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell.titleL.text = model.title
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listArray![indexPath.row]
//        delegate?.didSelectItemAt(model, self)
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat  = 230
        let width:CGFloat   = 160
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

