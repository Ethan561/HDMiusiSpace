//
//  HDLY_WKWebVC.swift
//  HDDongBeiLieShi
//
//  Created by liuyi on 2018/9/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit


class HDLY_WKWebVC: HDItemBaseWebVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: ---- WKNavigationDelegate ----
    //开始加载
    override func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressView.isHidden = false
        self.progressView.setProgress(0.2, animated: true)
        LOG("开始加载_____")
    }
    
    //完成加载
    override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.isHidden = true
        
        LOG("完成加载_____")
    }
    
    //加载失败
    override func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LOG("加载失败_____")
    }
    
    
}


