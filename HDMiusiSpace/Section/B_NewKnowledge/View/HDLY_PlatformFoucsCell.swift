//
//  HDLY_PlatformFoucsCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_PlatformFoucsCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var vipImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var focusBtn: UIButton!
    @IBOutlet weak var fromL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        focusBtn.layer.cornerRadius = 15
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_PlatformFoucsCell! {
        var cell: HDLY_PlatformFoucsCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_PlatformFoucsCell.className) as? HDLY_PlatformFoucsCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_PlatformFoucsCell.className, bundle: nil), forCellReuseIdentifier: HDLY_PlatformFoucsCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_PlatformFoucsCell.className, owner: nil, options: nil)?.first as? HDLY_PlatformFoucsCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
