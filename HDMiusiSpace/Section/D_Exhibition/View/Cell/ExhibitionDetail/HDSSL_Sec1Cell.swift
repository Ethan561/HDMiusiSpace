//
//  HDSSL_Sec1Cell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import WebKit

class HDSSL_Sec1Cell: UITableViewCell {

    lazy var webview:WKWebView  = WKWebView.init(frame: CGRect.init(x: 16, y: 0, width: ScreenWidth - 16*2, height: self.bounds.size.height))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.addSubview(webview)
    }

    func loadWebView(_ path: String) {
        //
        webview.frame = CGRect.init(x: 16, y: 0, width: ScreenWidth - 16*2, height: self.bounds.size.height)
        webview.load(URLRequest.init(url: URL.init(string: path)!))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class  func getMyTableCell(tableV: UITableView) -> HDSSL_Sec1Cell! {
        var cell: HDSSL_Sec1Cell? = tableV.dequeueReusableCell(withIdentifier: HDSSL_Sec1Cell.className) as? HDSSL_Sec1Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDSSL_Sec1Cell.className, bundle: nil), forCellReuseIdentifier: HDSSL_Sec1Cell.className)
            cell = Bundle.main.loadNibNamed(HDSSL_Sec1Cell.className, owner: nil, options: nil)?.first as? HDSSL_Sec1Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
}
