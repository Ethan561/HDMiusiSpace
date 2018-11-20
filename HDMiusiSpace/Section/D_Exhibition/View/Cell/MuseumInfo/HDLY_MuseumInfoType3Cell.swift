//
//  HDLY_MuseumInfoType3Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumInfoType3Cell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var museumL: UILabel!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var teacherL: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    
    var model: DMuseumRaiders? {
        didSet {
            showCellData()
        }
    }
    func showCellData() {
        if self.model != nil {
            if  model?.img != nil  {
                imgV.kf.setImage(with: URL.init(string: (model!.img!)), placeholder: UIImage.grayImage(sourceImageV: imgV), options: nil, progressBlock: nil, completionHandler: nil)
            }
            titleL.text = model?.title
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoType3Cell! {
        var cell: HDLY_MuseumInfoType3Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoType3Cell.className) as? HDLY_MuseumInfoType3Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoType3Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoType3Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoType3Cell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoType3Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
