//
//  HDSSL_dMuseumCell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/7.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDSSL_dMuseumCell: UITableViewCell {

    @IBOutlet weak var cell_img: UIImageView!
    @IBOutlet weak var cell_collectImg: UIImageView!
    @IBOutlet weak var cell_title: UILabel!
    @IBOutlet weak var cell_ticketPrice: UILabel!
    @IBOutlet weak var cell_address: UILabel!
    @IBOutlet weak var cell_away: UILabel!
    @IBOutlet weak var cell_tagBg: UIView!
    
    @IBOutlet weak var notiView: UIView!
    @IBOutlet weak var notiTypeL: UILabel!
    @IBOutlet weak var cell_liveContent: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell_img.layer.cornerRadius = 4
        cell_img.layer.masksToBounds = true
        notiTypeL.layer.cornerRadius = 1
        notiTypeL.layer.masksToBounds = true
        
    }
    
    var model: HDLY_dMuseumListD? {
        didSet {
            showCellData()
        }
    }
    func showCellData() {
        if self.model != nil {
            if  model?.img != nil  {
                cell_img.kf.setImage(with: URL.init(string: (model!.img!)), placeholder: UIImage.grayImage(sourceImageV: cell_img), options: nil, progressBlock: nil, completionHandler: nil)
            }else {
                return
            }
            if model!.isFavorite == 0 {
                cell_collectImg.isHidden = true
            } else {
                cell_collectImg.isHidden = false
            }
            if model!.isGg == 1 {
                notiView.isHidden = false
                notiTypeL.text = "公告"
                notiTypeL.backgroundColor = UIColor.HexColor(0xEEEEEE)
                notiTypeL.textColor = UIColor.HexColor(0x9B9B9B)
                cell_liveContent.text = model?.ggTitle
            }else {
                if model?.isLive == 1 {
                    notiView.isHidden = false
                    notiTypeL.text = "live"
                    notiTypeL.backgroundColor = UIColor.HexColor(0xD8B98D)
                    notiTypeL.textColor = UIColor.white
                    cell_liveContent.text = model?.ggTitle
                }else {
                    notiView.isHidden = true
                    lineView.isHidden = true
                }
            }
            if model!.isFree == 0 {
                cell_ticketPrice.text = "￥" + String(model!.price)
            }else {
                cell_ticketPrice.text = ""
            }
            cell_title.text = model?.title
            cell_address.text = model?.address
            cell_away.text = model?.distance
            cell_liveContent.text = model?.liveTitle
            var x:CGFloat = 0
            var imgWArr = [CGFloat]()
            cell_tagBg.backgroundColor = UIColor.white
            for (i,imgStr) in model!.iconList!.enumerated() {
                let imgV = UIImageView()
                imgV.contentMode = .scaleAspectFit
                imgV.kf.setImage(with: URL.init(string: imgStr), placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, url) in
                    
                    let imgSize = img!.size
                    let imgH: CGFloat = 15
                    let imgW: CGFloat = 15*imgSize.width/imgSize.height
                    imgWArr.append(imgW)
                    if i > 0 {
                        let w = imgWArr[i-1]
                        x = x + w
                    }
                    imgV.frame = CGRect.init(x: x, y: 0, width: imgW, height: imgH)
                    self.cell_tagBg.addSubview(imgV)
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_dMuseumCell! {
        var cell: HDSSL_dMuseumCell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_dMuseumCell.className) as? HDSSL_dMuseumCell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_dMuseumCell.className, bundle: nil), forCellReuseIdentifier: HDSSL_dMuseumCell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_dMuseumCell.className, owner: nil, options: nil)?.first as? HDSSL_dMuseumCell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
}
