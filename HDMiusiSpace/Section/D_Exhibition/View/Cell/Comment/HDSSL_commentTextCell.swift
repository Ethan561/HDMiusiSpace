//
//  HDSSL_commentTextCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/18.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias BlockBackStarNumber = (_ number: CGFloat) -> Void   //返回分数

class HDSSL_commentTextCell: UITableViewCell {

    @IBOutlet weak var cell_img       : UIImageView! //图片
    @IBOutlet weak var cell_titleT    : UITextView!  //标题
    @IBOutlet weak var cell_starBg    : UIView!      //星
    @IBOutlet weak var cell_starNumL  : UILabel!     //评分
    @IBOutlet weak var cell_inputText : UITextView!  //输入
    @IBOutlet weak var cell_inputBg   : UIView!      //输入背景
    @IBOutlet weak var cell_textCountL: UILabel!     //字数统计
    var starSlider : XHStarRateView! //评星View
    
    var blockBackStarNum: BlockBackStarNumber?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_img.layer.cornerRadius = 5.0
        cell_img.layer.masksToBounds = true
        
        cell_inputBg.layer.cornerRadius = 5.0
        cell_inputBg.layer.masksToBounds = true
        cell_inputBg.layer.borderWidth = 0.5
        cell_inputBg.layer.borderColor = UIColor.lightGray.cgColor
        //
        starSlider = XHStarRateView.init(frame: cell_starBg.bounds, numberOfStars: 5, rateStyle: .HalfStar, isAnination: true,andForegroundImg:"zlpl_star_red" , finish: { (index) in
            
            weak var weakself = self
            let starNum = 5.0 + index
            
            weakself?.cell_starNumL.text = String.init(format: "%.1f", starNum)
            if weakself?.blockBackStarNum != nil {
                weakself?.blockBackStarNum!(starNum)
            }
        })
        cell_starBg.addSubview(starSlider)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_commentTextCell! {
        var cell: HDSSL_commentTextCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_commentTextCell.className) as? HDSSL_commentTextCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_commentTextCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_commentTextCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_commentTextCell.className, owner: nil, options: nil)?.first as? HDSSL_commentTextCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    func BlockBackStarNumber(block: @escaping BlockBackStarNumber) {
        blockBackStarNum = block
    }
}