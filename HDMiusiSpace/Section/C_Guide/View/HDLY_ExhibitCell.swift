//
//  HDLY_ExhibitCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/6.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

 class HDLY_ExhibitCell: UITableViewCell,HDLY_AudioPlayer_Delegate {
    
    @IBOutlet weak var tipImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    var model: HDLY_ExhibitListM? {
        didSet {
            showCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func showCellData() {
        if let listModel = model {
            nameL.text = listModel.title
            timeL.text = listModel.longTime
            
//            tipImgV.image = UIImage.init(named: "dl_icon_default")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected == true {
            
            //                    tipImgV.image = UIImage.init(named: "dl_icon_pause")
            //                    nameL.textColor = UIColor.HexColor(0xE8593E)
            //                    self.delegate?.didselectedCell(listModel, cell: self)
        } else {
            tipImgV.image = UIImage.init(named: "dl_icon_default")
            nameL.textColor = UIColor.HexColor(0x4A4A4A)
            timeL.text = model?.longTime
        }
    }
    
    class  func getMyTableCell(tableV: UITableView, indexP: IndexPath) -> HDLY_ExhibitCell! {
        
        let reuseIdentifier = HDLY_ExhibitCell.className+"\(indexP.section)"+"\(indexP.row)"
        var cell: HDLY_ExhibitCell? = tableV.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HDLY_ExhibitCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_ExhibitCell.className, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            cell = Bundle.main.loadNibNamed(HDLY_ExhibitCell.className, owner: nil, options: nil)?.first as? HDLY_ExhibitCell
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
