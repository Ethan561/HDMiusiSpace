//
//  HDSSL_sameMuseumCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

//block
typealias BlockTapItem = (_ model: ExhibitionList) -> Void //返回点击cell

class HDSSL_sameMuseumCell: UITableViewCell {

    @IBOutlet weak var collectView: UICollectionView!
    var blockTapItem: BlockTapItem?
    
    var listArray: Array<ExhibitionList>? {
        didSet{
            collectView.reloadData()
        }
    }
    
    func BlockTapItemFunc(block: @escaping BlockTapItem) {
        blockTapItem = block
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_sameMuseumCell! {
        var cell: HDSSL_sameMuseumCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_sameMuseumCell.className) as? HDSSL_sameMuseumCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_sameMuseumCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_sameMuseumCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_sameMuseumCell.className, owner: nil, options: nil)?.first as? HDSSL_sameMuseumCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    //
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        //cell width
        let itemW: Float = 160
        let itemH = 230
        layout.itemSize = CGSize.init(width: CGFloat(itemW), height: CGFloat(itemH))
        
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumLineSpacing = 20
        self.collectView.setCollectionViewLayout(layout, animated: true)
        //
        self.collectView.scrollsToTop = false
        self.collectView.showsVerticalScrollIndicator = false
        self.collectView.showsHorizontalScrollIndicator = false
        self.collectView.register(UINib.init(nibName: HDSSL_sameMuseumItem.className, bundle: nil), forCellWithReuseIdentifier: HDSSL_sameMuseumItem.className)
        self.collectView.delegate = self
        self.collectView.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.collectView.reloadData()
        }
    }
}
extension HDSSL_sameMuseumCell :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK: ---
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listArray != nil {
            return listArray!.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HDSSL_sameMuseumItem = HDSSL_sameMuseumItem.getMyCollectionCell(collectionView: collectionView, indexPath: indexPath)
        if self.listArray != nil {
            if self.listArray!.count > 0 {
                let model :ExhibitionList = listArray![indexPath.row]
                
                if  model.img != nil  {
                    cell.item_img.kf.setImage(with: URL.init(string: model.img), placeholder: UIImage.grayImage(sourceImageV: cell.item_img), options: nil, progressBlock: nil, completionHandler: nil)
                }
                cell.item_title.text = String.init(format: "%@", model.title)
                cell.item_loc.text = String.init(format: "%@", model.address)
                cell.item_starNum.text = String.init(format: "%.1f", model.star)
                cell.item_iconBg.addSubview(self.getImagesWith(arr: model.iconList!, frame: cell.item_iconBg.bounds)) //icon list
                cell.item_star.image = UIImage.init(named: self.getStarImgName(model.star))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = listArray![indexPath.row]
//        delegate?.didSelectItemAt(model, self)
        weak var weakSelf = self
        if weakSelf?.blockTapItem != nil {
            weakSelf?.blockTapItem!(model)
        }
    }
    
    //MARK ----- UICollectionViewDelegateFlowLayout ------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height:CGFloat  = 240 * (ScreenWidth - 60)/340.0
        let width:CGFloat   = (ScreenWidth - 60) * 0.5
        
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    //返回icon list 试图
    func getImagesWith(arr: [String],frame: CGRect) -> UIView {
        //
        let bgView = UIView.init(frame: frame)
        for i in 0..<arr.count {
            //
            var size1 = CGSize.zero
            
            if i > 0 {
                size1 = UIImage.getImageSize(arr[i-1])
            }
            let size = UIImage.getImageSize(arr[i])
            
            let imgView = UIImageView.init(frame: CGRect.init(x: CGFloat(Int(size1.width/2 + 2) * i), y: 0, width: size.width/2, height: size.height/2))
            imgView.kf.setImage(with: URL.init(string: arr[i]))
            imgView.centerY = bgView.centerY
            bgView.addSubview(imgView)
        }
        
        return bgView
    }
    //返回星级图片
    func getStarImgName(_ star: Double) -> String {
        if star >= 0 && star <= 1.9 {
            return "exhibitionCmt_1_5"
        }else if star >= 2 && star <= 3.9 {
            return "exhibitionCmt_2_5"
        }else if star >= 4 && star <= 5.9 {
            return "exhibitionCmt_3_5"
        }
        else if star >= 6 && star <= 7.9 {
            return "exhibitionCmt_4_5"
        }else {
            //8~10
            return "exhibitionCmt_5_5"
        }
    }
}
