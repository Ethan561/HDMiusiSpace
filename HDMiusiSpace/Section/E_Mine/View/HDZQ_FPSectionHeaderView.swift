//
//  HDZQ_FPSectionHeaderView.swift
//  HDMiusiSpace
//
//  Created by HD-XXZQ-iMac on 2018/11/26.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDZQ_FPSectionHeaderView: UITableViewHeaderFooterView {
    
    //    @IBOutlet weak var dateLabel: UILabel!
    //    @IBOutlet weak var topLineView: UIView!
    
    public var dateLabel = UILabel()
    public var topLineView = UIView()
    public var img = UIImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        img.frame = CGRect.init(x: 20, y: 10, width: 25, height: 25)
        
        topLineView.frame = CGRect.init(x: 32.5, y: 0, width: 1, height: 15)
        topLineView.backgroundColor = UIColor.HexColor(0xE8593E)
        dateLabel.frame = CGRect.init(x: topLineView.ly_right + 25, y: 10, width: ScreenWidth - 65, height: 25)
        dateLabel.font = UIFont.systemFont(ofSize: 18.0)
        let bottom = UIView.init(frame: CGRect.init(x: 32.5, y: 20, width: 1, height: 25))
        bottom.backgroundColor = UIColor.HexColor(0xE8593E)
        self.addSubview(dateLabel)
        self.addSubview(topLineView)
        self.addSubview(bottom)
        self.addSubview(img)
        self.contentView.backgroundColor = .white
    }
    
    public func setDateData(date:String) {
        img.image = UIImage.init(named: "wd_icon_dl_red")
        dateLabel.text = date
    }
    
}
