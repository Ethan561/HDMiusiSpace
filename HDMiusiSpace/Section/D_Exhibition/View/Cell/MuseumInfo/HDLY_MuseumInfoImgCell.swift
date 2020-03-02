//
//  HDLY_MuseumInfoImgCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumInfoImgCell: UITableViewCell {

    @IBOutlet weak var webView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.webView.scrollView.isScrollEnabled = false
        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumInfoImgCell! {
        var cell: HDLY_MuseumInfoImgCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumInfoImgCell.className) as? HDLY_MuseumInfoImgCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumInfoImgCell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumInfoImgCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumInfoImgCell.className, owner: nil, options: nil)?.first as? HDLY_MuseumInfoImgCell
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
