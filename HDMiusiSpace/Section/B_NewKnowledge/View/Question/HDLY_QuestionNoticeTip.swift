//
//  HDLY_QuestionNoticeTip.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/12/24.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit

class HDLY_QuestionNoticeTip: UIView {

    @IBOutlet weak var tipBgView: UIView!
    @IBOutlet weak var contentView: UIView!
    lazy var webview: WKWebView = {
            let webConfiguration = WKWebViewConfiguration()
            //初始化偏好设置属性：preferences
            webConfiguration.preferences = WKPreferences()
            //是否支持JavaScripta
            webConfiguration.preferences.javaScriptEnabled = true
            //不通过用户交互，是否可以打开窗口
            webConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
//            webConfiguration.userContentController.add(self, name: "Fold")
            let webFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 0)
            let webView = WKWebView(frame: webFrame, configuration: webConfiguration)
            webView.backgroundColor = UIColor.white
    //        webView.navigationDelegate = self
    //        webView.uiDelegate = self
            
            webView.scrollView.isScrollEnabled = true
            webView.scrollView.bounces = false
            webView.scrollView.showsVerticalScrollIndicator = true
            webView.scrollView.showsHorizontalScrollIndicator = false
            
            return webView
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipBgView.layer.cornerRadius = 6
        tipBgView.layer.masksToBounds = true
        self.contentView.addSubview(self.webview)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.webview.frame = self.contentView.bounds
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
     
    
    @IBAction func closeAction(_ sender: Any) {
        self.removeFromSuperview()
    }
    
     

}
