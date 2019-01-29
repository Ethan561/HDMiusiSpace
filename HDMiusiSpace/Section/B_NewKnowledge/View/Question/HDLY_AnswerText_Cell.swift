//
//  HDLY_AnswerText_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/25.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_AnswerText_Cell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var avaImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var contentL: UILabel!    
    @IBOutlet weak var timeL: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImgV.layer.cornerRadius = 15
        bgView.layer.cornerRadius = 4
        moreBtn.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_AnswerText_Cell! {
        var cell: HDLY_AnswerText_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_AnswerText_Cell.className) as? HDLY_AnswerText_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_AnswerText_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_AnswerText_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_AnswerText_Cell.className, owner: nil, options: nil)?.first as? HDLY_AnswerText_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
