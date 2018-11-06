//
//  HDLY_ExhibitionCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_ExhibitionCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var vipPriceL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var typeL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_ExhibitionCell! {
        var cell: HDLY_ExhibitionCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_ExhibitionCell.className) as? HDLY_ExhibitionCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_ExhibitionCell.className, bundle: nil), forCellReuseIdentifier: HDLY_ExhibitionCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_ExhibitionCell.className, owner: nil, options: nil)?.first as? HDLY_ExhibitionCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
