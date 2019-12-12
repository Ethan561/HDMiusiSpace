//
//  HDSSL_Sec0_Cell1.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_Sec0_Cell0: UITableViewCell {

    @IBOutlet weak var cell_titleL: UILabel!
    @IBOutlet weak var cell_starNumL: UILabel!
    @IBOutlet weak var cell_star1: UIImageView!
    @IBOutlet weak var cell_star2: UIImageView!
    @IBOutlet weak var cell_star3: UIImageView!
    @IBOutlet weak var cell_star4: UIImageView!
    @IBOutlet weak var cell_star5: UIImageView!
    @IBOutlet weak var noStarL: UILabel!
    
    var starNum: Double = 0.0 {
        didSet{
            loadStar()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec0_Cell0! {
        var cell: HDSSL_Sec0_Cell0? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec0_Cell0.className) as? HDSSL_Sec0_Cell0
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec0_Cell0.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec0_Cell0.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec0_Cell0.className, owner: nil, options: nil)?.first as? HDSSL_Sec0_Cell0
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    func loadStar() {
        if starNum == 0.0 {
            noStarL.isHidden = false
        }else{
            noStarL.isHidden = true
        }
        let starArray = [cell_star1,cell_star2,cell_star3,cell_star4,cell_star5]
        
        let maxNum:Int = Int(floor(self.starNum / 2))//向下取整
        
        if maxNum == 0 {
            return
        }else {
            //red
            for i in 0..<maxNum {
                let imgV = starArray[i]
                imgV!.image = UIImage.init(named: "zl_icon_star_red")
            }
            //half
            if floor(self.starNum / 2) != self.starNum / 2  {
                let imgV = starArray[maxNum]
                imgV!.image = UIImage.init(named: "zl_icon_star_half")
            }
        }
    }
}
