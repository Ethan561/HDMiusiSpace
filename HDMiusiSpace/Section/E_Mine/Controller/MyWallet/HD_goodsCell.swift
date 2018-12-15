//
//  HD_goodsCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/12/4.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HD_goodsCell: UICollectionViewCell {
    @IBOutlet weak var goldNumberLab: UILabel!
    @IBOutlet weak var itemContentLab: UILabel!
    @IBOutlet weak var seleBtn: UIButton!
    
    var cellData: GoodsList? {
        didSet{
            reloadDatas()
        }
    }
    //单选判断，通过indexPathsForSelectedItems获取旋转数组，allowsMultipleSelection控制多选
    override var isSelected: Bool{
        didSet{
            print(isSelected)
            seleBtn.isSelected = isSelected
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reloadDatas(){
        goldNumberLab.text = String.init(format: "%d", (cellData?.spaceMoney)!)
        itemContentLab.text = String.init(format: "会员%d币（多送%d币）", (cellData?.vipSpaceMoney)!,((cellData?.vipSpaceMoney)! - (cellData?.spaceMoney)!))
    
    }

}
