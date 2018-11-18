//
//  HDSSL_commentImgCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_commentImgCell: UITableViewCell {

    @IBOutlet weak var cell_collectBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_commentImgCell! {
        var cell: HDSSL_commentImgCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_commentImgCell.className) as? HDSSL_commentImgCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_commentImgCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_commentImgCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_commentImgCell.className, owner: nil, options: nil)?.first as? HDSSL_commentImgCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
