//
//  HDLY_MuseumInfoType5Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


protocol HDLY_MuseumInfoType5Cell_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:DMuseumListenList, _ cell: HDLY_FreeListenItem)
}

class HDLY_MuseumInfoType5Cell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var listArray: Array<DMuseumListenList>? {
        didSet{
            myCollectionView.reloadData()
        }
    }
    weak var delegate: HDLY_MuseumInfoType5Cell_Delegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
        
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        //cell width
        let itemW: Float = 140
        let itemH = 140
        layout.itemSize = CGSize.init(width: CGFloat(itemW), height: CGFloat(itemH))
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 20
        self.myCollectionView.setCollectionViewLayout(layout, animated: true)
        //
        self.myCollectionView.scrollsToTop = false
        self.myCollectionView.showsVerticalScrollIndicator = false
        self.myCollectionView.showsHorizontalScrollIndicator = false
        self.myCollectionView.register(UINib.init(nibName: HDLY_FreeListenItem.className, bundle: nil), forCellWithReuseIdentifier: HDLY_FreeListenItem.className)
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
        let cell:HDLY_FreeListenItem = HDLY_FreeListenItem.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
                var model = listArray![indexPath.row]
                if  model.img != nil  {
                    cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell.titleL.text = model.title
                cell.nameL.text = model.exhibitName
                if model.isPlaying == true {
                    cell.playBtn.isSelected = true
                }else {
                    cell.playBtn.isSelected = false
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listArray![indexPath.row]
        let item:HDLY_FreeListenItem = collectionView.cellForItem(at: indexPath) as! HDLY_FreeListenItem
        delegate?.didSelectItemAt(model, item)
        
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat   = (ScreenWidth - 20 * 3)/2.0
        let height:CGFloat  = width + 10
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoType5Cell! {
        var cell: HDLY_MuseumInfoType5Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoType5Cell.className) as? HDLY_MuseumInfoType5Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoType5Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoType5Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoType5Cell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoType5Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}


