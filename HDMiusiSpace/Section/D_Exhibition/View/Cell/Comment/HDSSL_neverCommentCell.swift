//
//  HDSSL_neverCommentCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/20.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

typealias BlockTapBtn = (_ Index: Int) -> Void //去评论

class HDSSL_neverCommentCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_time: UILabel!
    @IBOutlet weak var cell_btn: UIButton!
    
    var model: HDSSL_uncommentModel? {
        didSet{
            loadCellDatas()
        }
    }
    
    var blockTapBtn: BlockTapBtn?
    
    
    func loadCellDatas() {
        //
        cell_img.kf.setImage(with: URL.init(string: String.init(format: "%@", (model?.img)!)), placeholder: UIImage.init(named: ""), options: nil, progressBlock: nil, completionHandler: nil)
        cell_title.text = String.init(format: "%@", (model?.title)!)
        cell_time.text = String.init(format: "%@猜你去过", (model?.look_time)!)
    }
    
    
    func BlockTapBtnFunc(block :@escaping BlockTapBtn) {
        blockTapBtn = block
    }
    
    @IBAction func action_goToComment(_ sender: Any) {
        weak var weakself = self
        if weakself?.blockTapBtn != nil {
            weakself?.blockTapBtn!(self.tag)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_img.layer.cornerRadius = 5.0
        cell_img.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_neverCommentCell! {
        var cell: HDSSL_neverCommentCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_neverCommentCell.className) as? HDSSL_neverCommentCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_neverCommentCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_neverCommentCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_neverCommentCell.className, owner: nil, options: nil)?.first as? HDSSL_neverCommentCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
