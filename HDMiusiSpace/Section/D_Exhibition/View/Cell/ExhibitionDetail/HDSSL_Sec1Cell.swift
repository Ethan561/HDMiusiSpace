//
//  HDSSL_Sec1Cell.swift
//  HDMiusiSpace
//
//  Created by SSLong on 2018/11/14.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import WebKit
//block
typealias BloclkCellHeight = (_ height: Double) -> Void //返回高度
class HDSSL_Sec1Cell: UITableViewCell {

    var blockHeight: BloclkCellHeight?
    
    lazy var webview:WKWebView  = WKWebView.init(frame: CGRect.init(x: 16, y: 0, width: ScreenWidth - 16*2, height: self.bounds.size.height))
    
    //点击图片，放大
    func blockHeightFunc(block: @escaping BloclkCellHeight) {
        blockHeight = block
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.addSubview(webview)
    }

    func loadWebView(_ path: String) {
        //
        if path == "" || path.count == 0 {
            return
        }
        webview.frame = CGRect.init(x: 16, y: 0, width: ScreenWidth - 16*2, height: self.bounds.size.height)
        webview.navigationDelegate = self
        webview.scrollView.isScrollEnabled = false
        webview.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue)
        webview.load(URLRequest.init(url: URL.init(string: path)!))
//        webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
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
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize" {
//            //
//            var webheight = 0.0
//
//            // 获取内容实际高度
//            self.webview.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
//
//                if let tempHeight: Double = result as? Double {
//                    webheight = tempHeight
//                    print("webheight: \(webheight)")
//                }
//
//                DispatchQueue.main.async {
//
//                    var tempFrame: CGRect = self.webview.frame
//                    tempFrame.size.height = CGFloat(webheight)
//                    self.webview.frame = tempFrame
//
//                    //返回高度，刷新cell
//                    weak var weakSelf = self
//                    if weakSelf?.blockHeight != nil {
//                        weakSelf?.blockHeight!(webheight)
//                    }
//                }
//            }
//        }
//    }
//
//    func dealloc()
//    {
//        webview.scrollView.removeObserver(self, forKeyPath: "contentSize")
//    }
}
extension HDSSL_Sec1Cell:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        
        // 获取内容实际高度
        self.webview.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                print("webheight: \(webheight)")
            }
            
            DispatchQueue.main.async { [unowned self] in
                
//                var tempFrame: CGRect = self.webview.frame
//                tempFrame.size.height = CGFloat(webheight)
//                self.webview.frame = tempFrame
                
                //返回高度，刷新cell
                weak var weakSelf = self
                if weakSelf?.blockHeight != nil {
                    weakSelf?.blockHeight!(webheight)
                }
            }
        }
    }
    
}
