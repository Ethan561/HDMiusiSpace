//
//  HDLY_QuestionNumTitle_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/25.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_QuestionNumTitle_Cell: UITableViewCell {

    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var noticeL: UILabel!
    @IBOutlet weak var noticeImgV: UIImageView!
    @IBOutlet weak var noticeBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_QuestionNumTitle_Cell! {
        var cell: HDLY_QuestionNumTitle_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_QuestionNumTitle_Cell.className) as? HDLY_QuestionNumTitle_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_QuestionNumTitle_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_QuestionNumTitle_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_QuestionNumTitle_Cell.className, owner: nil, options: nil)?.first as? HDLY_QuestionNumTitle_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    
}
