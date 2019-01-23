//
//  HDSSL_noCommentCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2019/1/14.
//  Copyright © 2019 hengdawb. All rights reserved.
//  没有评论时

import UIKit

class HDSSL_noCommentCell: UITableViewCell {

    @IBOutlet weak var bottomLineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_noCommentCell! {
        var cell: HDSSL_noCommentCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_noCommentCell.className) as? HDSSL_noCommentCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_noCommentCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_noCommentCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_noCommentCell.className, owner: nil, options: nil)?.first as? HDSSL_noCommentCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
