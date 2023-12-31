//
//  HDLY_MuseumInfoType2Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumInfoType2Cell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var tagL: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    
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
            tagL.text = model?.author
            
            commentBtn.setTitle(String(model?.commentNum ?? 0), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        likeBtn.setImage(UIImage.init(named: "zl_icon_star_gray"), for: .normal)
        likeBtn.setImage(UIImage.init(named: "zl_icon_star_red"), for: .selected)
        likeBtn.isHidden = true
        self.imgV.layer.cornerRadius = 8.0
        self.imgV.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoType2Cell! {
        var cell: HDLY_MuseumInfoType2Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoType2Cell.className) as? HDLY_MuseumInfoType2Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoType2Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoType2Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoType2Cell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoType2Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
