//
//  HDLY_MuseumTagsCell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/17.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_MuseumTagsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var imgArr: Array<String>? {
        didSet {
            showCellData()
        }
    }
    
    
    func showCellData() {

        if self.contentView.subviews.count > 1 {
            return
        }
        if self.imgArr != nil {
            var x:CGFloat = 20
            var imgWArr = [CGFloat]()
            
            for (i,imgStr) in self.imgArr!.enumerated() {
                let imgV = UIImageView()
                imgV.contentMode = .scaleAspectFit
                imgV.kf.setImage(with: URL.init(string: imgStr), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
                    
                    let imgSize = img!.size
                    let imgH: CGFloat = 55
                    let imgW: CGFloat = 45
                    imgWArr.append(imgW)
                    if i > 0 {
                        let w = imgW + 10
                        x = x + w
                    }
                    imgV.frame = CGRect.init(x: x, y: 15, width: imgW, height: imgH)
                    self.contentView.addSubview(imgV)
                }
            }
        }
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_MuseumTagsCell! {
        var cell: HDLY_MuseumTagsCell? = tableV.dequeueReusableCell(withIdentifier: HDLY_MuseumTagsCell.className) as? HDLY_MuseumTagsCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_MuseumTagsCell.className, bundle: nil), forCellReuseIdentifier: HDLY_MuseumTagsCell.className)
            cell = Bundle.main.loadNibNamed(HDLY_MuseumTagsCell.className, owner: nil, options: nil)?.first as? HDLY_MuseumTagsCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}
