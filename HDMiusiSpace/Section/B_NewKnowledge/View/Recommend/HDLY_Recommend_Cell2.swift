//
//  HDLY_Recommend_Cell2.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/10.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Recommend_Cell2: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var courseL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!

    @IBOutlet weak var bgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Recommend_Cell2! {
        var cell: HDLY_Recommend_Cell2? = tableV.dequeueReusableCell(withIdentifier: HDLY_Recommend_Cell2.className) as? HDLY_Recommend_Cell2
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Recommend_Cell2.className, bundle: nil), forCellReuseIdentifier: HDLY_Recommend_Cell2.className)
            cell = Bundle.main.loadNibNamed(HDLY_Recommend_Cell2.className, owner: nil, options: nil)?.first as? HDLY_Recommend_Cell2
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
