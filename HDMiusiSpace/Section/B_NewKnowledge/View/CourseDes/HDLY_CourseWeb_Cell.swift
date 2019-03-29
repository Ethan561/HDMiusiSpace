//
//  HDLY_CourseWeb_Cell.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/8/16.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit

typealias CourseWebTapBloclk = (_ type: Int, _ articleId: Int) -> Void //
typealias FoldOrUnfoldBlock = (_ type: Int, _ height: Double) -> Void //

class HDLY_CourseWeb_Cell: UITableViewCell {
    
    var tapBloclk: CourseWebTapBloclk?
    var foldBlock: FoldOrUnfoldBlock?
    // MARK: - 懒加载
    lazy var webview: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        //初始化偏好设置属性：preferences
        webConfiguration.preferences = WKPreferences()
        //是否支持JavaScripta
        webConfiguration.preferences.javaScriptEnabled = true
        //不通过用户交互，是否可以打开窗口
        webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webConfiguration.userContentController.add(self, name: "Fold")
        let webFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
        let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
        webView.backgroundColor = UIColor.blue
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        
        return webView
    }()
    
    //block
    func tapBloclkFunc(block: @escaping CourseWebTapBloclk) {
        tapBloclk = block
    }
    
    func blockHeightFunc(block: @escaping FoldOrUnfoldBlock) {
        foldBlock = block
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(self.webview)
    }

    func loadWebView(_ path: String?) {
        //
        if path == "" || path?.count == 0 {
            return
        }
        
        if let webUrlString = path {
            if let encodedStr = webUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if let myUrl = URL(string: encodedStr) {
                    let myRequest = URLRequest(url: myUrl)
                    self.webview.load(myRequest)                    
                }
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class  func getMyTableCell(tableV: UITableView) -> HDLY_CourseWeb_Cell! {
        var cell: HDLY_CourseWeb_Cell? = tableV.dequeueReusableCell(withIdentifier: HDLY_CourseWeb_Cell.className) as? HDLY_CourseWeb_Cell
        if cell == nil {
            //注册cell
            tableV.register(UINib.init(nibName: HDLY_CourseWeb_Cell.className, bundle: nil), forCellReuseIdentifier: HDLY_CourseWeb_Cell.className)
            cell = Bundle.main.loadNibNamed(HDLY_CourseWeb_Cell.className, owner: nil, options: nil)?.first as? HDLY_CourseWeb_Cell
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}

extension HDLY_CourseWeb_Cell: WKNavigationDelegate ,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var webheight = 0.0
        
        // 获取内容实际高度
        self.webview.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            
            if let tempHeight: Double = result as? Double {
                webheight = tempHeight
                //print("webheight: \(webheight)")
            }
            
            DispatchQueue.main.async { [unowned self] in
                var tempFrame: CGRect = self.webview.frame
                tempFrame.size.height = CGFloat(webheight)
                self.webview.frame = tempFrame
                //返回高度，刷新cell
            }
        }
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let arr = message.components(separatedBy: "#")
        print(message,arr)//
        if arr.count == 2 {
            if tapBloclk != nil {
                let type = arr.first
                let articleId = arr.last
                self.tapBloclk?(Int(type!) ?? 0,Int(articleId!) ?? 0)
            }
        }
        completionHandler()
    }
    
}

extension HDLY_CourseWeb_Cell :WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        guard let arr = message.body as? NSArray else { return }
        guard let floder = arr[0] as? String else { return }
        guard let height = arr[1] as? String else { return }
        if self.foldBlock != nil {
            let type = Int(floder)
            let h = Double(height)
            self.foldBlock!(type!,h!)
            
        }
    }
}
