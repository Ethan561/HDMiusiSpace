//
//  HDLY_RootACard_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/9/1.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_RootACard_Cell: UITableViewCell {

    @IBOutlet weak var collectionBtn: UIButton!
    @IBOutlet weak var imgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionBtn.setImage(UIImage.init(named: "rika_coollect_default"), for: .normal)
        collectionBtn.setImage(UIImage.init(named: "rika_coollect_pressed"), for: .selected)
        collectionBtn.isHidden = true
        
        imgV.layer.cornerRadius = 10
        imgV.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_RootACard_Cell! {
        var cell: HDLY_RootACard_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_RootACard_Cell.className) as? HDLY_RootACard_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_RootACard_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_RootACard_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_RootACard_Cell.className, owner: nil, options: nil)?.first as? HDLY_RootACard_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
