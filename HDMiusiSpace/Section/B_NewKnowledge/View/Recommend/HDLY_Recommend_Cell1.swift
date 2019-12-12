//
//  HDLY_Recommend_Cell1.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/10.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_Recommend_Cell1: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var authorL: UILabel!
    @IBOutlet weak var countL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var courseL: UILabel!
    @IBOutlet weak var typeImgV: UIImageView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var newTipL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        imgV.layer.cornerRadius = 8
//        imgV.layer.masksToBounds = true
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        newTipL.backgroundColor = BaseColor.mainRedColor
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //类方法生成cell
    class  func getMyTableCell(tableV: UITableView) -> HDLY_Recommend_Cell1! {
        var cell: HDLY_Recommend_Cell1? = tableV.dequeueReusableCell(withIdentifier: HDLY_Recommend_Cell1.className) as? HDLY_Recommend_Cell1
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_Recommend_Cell1.className, bundle: nil), forCellReuseIdentifier: HDLY_Recommend_Cell1.className)
            cell = Bundle.main.loadNibNamed(HDLY_Recommend_Cell1.className, owner: nil, options: nil)?.first as? HDLY_Recommend_Cell1
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
}
