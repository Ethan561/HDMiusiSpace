//
//  HDSSL_commentImgCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias BlockHideDropImg = (_ Index: Int) -> Void //

class HDSSL_commentImgCell: UITableViewCell {

    @IBOutlet weak var cell_collectBg: UIView!
    @IBOutlet weak var img_tip: UIImageView!
    @IBOutlet weak var img_drop: UIButton!
    
    
    var blockHideDropImg: BlockHideDropImg?
    func BlockHideDropImgFunc(block :@escaping BlockHideDropImg) {
        blockHideDropImg = block
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img_tip.frame.origin.x = (ScreenWidth-30)/6 + 15-40 //计算提示位置
    }
    @IBAction func action_dropimgTap(_ sender: UIButton) {
        
        img_drop.isHidden = true
        
        weak var weakself = self
        if weakself?.blockHideDropImg != nil {
            weakself?.blockHideDropImg!(self.tag)
        }
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
