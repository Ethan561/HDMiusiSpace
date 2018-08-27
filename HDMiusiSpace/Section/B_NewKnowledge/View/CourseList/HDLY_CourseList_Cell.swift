//
//  HDLY_CourseList_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/17.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit

class HDLY_CourseList_Cell: UITableViewCell {

    @IBOutlet weak var tipImgV: UIImageView!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var tagL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var nameWidthCons: NSLayoutConstraint!
    
    var model: ChapterList? {
        didSet {
            showCellData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagL.layer.cornerRadius = 4
        tagL.layer.masksToBounds = true

    }

    func showCellData() {
        if let listModel = model {
            nameL.text = listModel.title
            timeL.text = listModel.timeLong
            let width = listModel.title.getContentWidth(font: UIFont.systemFont(ofSize: 14), height: 21)
            if width > ScreenWidth - 190 {
                nameWidthCons.constant = ScreenWidth - 190
            }
            if listModel.isNeedBuy == true {
                //0收费 1免费 2vip免费
                if listModel.freeType == 0 {
                    tagL.isHidden = true
                    tipImgV.image = UIImage.init(named: "xz_icon_suo")
                }
                else if listModel.freeType == 1 {
                    tagL.isHidden = false
                    tagL.text = "试听"
                    tagL.textColor = UIColor.HexColor(0xC1B6AE)
                    tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                }
                else if listModel.freeType == 2 {
                    tagL.isHidden = false
                    tagL.textColor = UIColor.HexColor(0xD8B98D)
                    tagL.text = "VIP"
                    tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                }
                
            }else {
                tagL.isHidden = true
                tipImgV.image = UIImage.init(named: "xz_daoxue_play")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if let listModel = model {
            
            if listModel.isNeedBuy == true {
                //0收费 1免费 2vip免费
                if listModel.freeType == 0 {
                    tagL.isHidden = true
                    tipImgV.image = UIImage.init(named: "xz_icon_suo")
                }
                else if listModel.freeType == 1 {
                    if selected == true {
                        tipImgV.image = UIImage.init(named: "icon_pause_white")
                        nameL.textColor = UIColor.HexColor(0xE8593E)
                        timeL.textColor = UIColor.HexColor(0xE8593E)
                    } else {
                        tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                        nameL.textColor = UIColor.HexColor(0x4A4A4A)
                        timeL.textColor = UIColor.HexColor(0x9B9B9B)
                    }
                }
                else if listModel.freeType == 2 {
                    if selected == true {
                        tipImgV.image = UIImage.init(named: "icon_pause_white")
                        nameL.textColor = UIColor.HexColor(0xE8593E)
                        timeL.textColor = UIColor.HexColor(0xE8593E)
                        
                    } else {
                        tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                        nameL.textColor = UIColor.HexColor(0x4A4A4A)
                        timeL.textColor = UIColor.HexColor(0x9B9B9B)
                    }
                }
            }else {//免费或已购买
                if selected == true {
                    tipImgV.image = UIImage.init(named: "icon_pause_white")
                    nameL.textColor = UIColor.HexColor(0xE8593E)
                    timeL.textColor = UIColor.HexColor(0xE8593E)
                    
                } else {
                    tipImgV.image = UIImage.init(named: "xz_daoxue_play")
                    nameL.textColor = UIColor.HexColor(0x4A4A4A)
                    timeL.textColor = UIColor.HexColor(0x9B9B9B)
                }
            }
        }
    }
    
    class  func getMyTableCell(tableV: UITableView, indexP: IndexPath) -> HDLY_CourseList_Cell! {
       
        let reuseIdentifier = HDLY_CourseList_Cell.className+"\(indexP.section)"+"\(indexP.row)"

        var cell: HDLY_CourseList_Cell? = tableV.dequeueReusableCell(withIdentifier: reuseIdentifier) as? HDLY_CourseList_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseList_Cell.className, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
            cell = Bundle.main.loadNibNamed(HDLY_CourseList_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseList_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
