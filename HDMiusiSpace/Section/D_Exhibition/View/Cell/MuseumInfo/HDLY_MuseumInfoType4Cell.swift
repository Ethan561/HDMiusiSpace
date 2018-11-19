//
//  HDLY_MuseumInfoType4Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit


protocol HDLY_MuseumInfoType4Cell_Delegate:NSObjectProtocol {
    func didSelectItemAt(_ model:DMuseumFeaturedList, _ cell: HDLY_MuseumInfoType4Cell)
}

class HDLY_MuseumInfoType4Cell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var listArray: Array<DMuseumFeaturedList>? {
        didSet{
            myCollectionView.reloadData()
        }
    }
    weak var delegate: HDLY_Topic_Cell_Delegate?
    
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
        layout.minimumLineSpacing = 10
        self.myCollectionView.setCollectionViewLayout(layout, animated: true)
        //
        self.myCollectionView.scrollsToTop = false
        self.myCollectionView.showsVerticalScrollIndicator = false
        self.myCollectionView.showsHorizontalScrollIndicator = false
        self.myCollectionView.register(UINib.init(nibName: HDLY_MuseumRecmdItem.className, bundle: nil), forCellWithReuseIdentifier: HDLY_MuseumRecmdItem.className)
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
        let cell:HDLY_MuseumRecmdItem = HDLY_MuseumRecmdItem.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
                let model = listArray![indexPath.row]
                if  model.img != nil  {
                    cell.imgV.kf.setImage(with: URL.init(string: model.img!), placeholder: UIImage.grayImage(sourceImageV: cell.imgV), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell.titleL.text = model.title
                cell.authorL.text = model.teacherName! + " " + model.teacherTitle!
                cell.countL.text = "\(model.purchases ?? 0)人在学"
                cell.countL.text = "\(model.classNum ?? 0)课时"
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
        let height:CGFloat  = 188 * ScreenWidth/375.0
        let width:CGFloat   = height * 335 / 188.0
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoType4Cell! {
        var cell: HDLY_MuseumInfoType4Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoType4Cell.className) as? HDLY_MuseumInfoType4Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoType4Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoType4Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoType4Cell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoType4Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}





