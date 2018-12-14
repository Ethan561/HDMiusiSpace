//
//  HDLY_PlatformCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/13.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_PlatformCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_PlatformCell! {
        var cell: HDLY_PlatformCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_PlatformCell.className) as? HDLY_PlatformCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_PlatformCell.className, bundle: nil), forCellReuseIdentifier: HDLY_PlatformCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_PlatformCell.className, owner: nil, options: nil)?.first as? HDLY_PlatformCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
}
