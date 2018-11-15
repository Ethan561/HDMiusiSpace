//
//  HDSSL_dExhibitionCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dExhibitionCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cell_locaAndPrice: UILabel!
    @IBOutlet weak var cell_number: UILabel!
    @IBOutlet weak var cell_star: UIImageView!
    @IBOutlet weak var cell_tagBg: UIView!
    
    var model: HDLY_dExhibitionListD? {
        didSet {
            showCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showCellData() {
        if self.model != nil {
            if  model?.img != nil  {
                cell_img.kf.setImage(with: URL.init(string: (model!.img!)), placeholder: UIImage.grayImage(sourceImageV: cell_img), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cellTitle.text = model?.title
            cell_locaAndPrice.text = model?.address
            cell_number.text = "\(model?.star)"
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_dExhibitionCell! {
        var cell: HDSSL_dExhibitionCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_dExhibitionCell.className) as? HDSSL_dExhibitionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_dExhibitionCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_dExhibitionCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_dExhibitionCell.className, owner: nil, options: nil)?.first as? HDSSL_dExhibitionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
