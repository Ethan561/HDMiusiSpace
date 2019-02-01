//
//  HDItemBaseWebVC.swift
//  HDMiusiSpace
//
//  Created by liuyi on 2018/11/22.
//  Copyright © 2018 hengdawb. All rights reserved.
//

import UIKit
import WebKit


class HDItemBaseWebVC: HDItemBaseVC, WKNavigationDelegate, WKUIDelegate {
    
    public var urlPath: String?
    public var titleName: String?
    //默认蓝色加载进度条
    public var progressTintColor = UIColor.blue {
        didSet {
            self.progressView.progressTintColor = progressTintColor
        }
    }
    
    var webView: WKWebView! = WKWebView()
    var progressView: UIProgressView! = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleName
        //
        self.webView.addSubview(self.progressView)
        self.view.addSubview(webView)
        
        setupProgressView()
        setupWkWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.webView.frame = self.view.bounds
        self.progressView.frame = CGRect(x: 0, y:0 , width: ScreenWidth, height: 5.0)
        
    }
    
    @objc func refreshAction() {
        if urlPath != nil {
            loadingURL(urltring: urlPath!)
        }
    }
    
    //MARK: ---------- 初始化 webView ----------
    func setupWkWebView() {
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
  
        
        weak var weakSelf = self
        //空数据界面
        let emptyV:HDEmptyView = HDEmptyView.emptyActionViewWithImageStr(imageStr: "net_error", titleStr: "暂无数据", detailStr: "请检查网络连接或稍后再试", btnTitleStr: "重新加载") {
            LOG("点击刷新")
            weakSelf!.refreshAction()
        }
        
        emptyV.contentViewY = -100
        emptyV.actionBtnBackGroundColor = .lightGray
        self.webView.scrollView.ly_emptyView = emptyV
        
        self.webView.scrollView.ly_emptyView?.tapContentViewBlock = {
            //weakSelf!.loadingURL(urltring: "http://news.baidu.com/")
        }
        
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        //监听进度
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        if urlPath != nil {
            loadingURL(urltring: urlPath!)
            webView.scrollView.ly_emptyView = EmptyConfigView.NoNetworkEmptyWithTarget(target: self, action: #selector(refreshAction))
        }else {
            webView.scrollView.ly_emptyView = EmptyConfigView.NoDataEmptyView()
            webView.scrollView.ly_showEmptyView()
        }
    }
    
    //MARK: ---------- 初始化progressView ----------
    func setupProgressView() {
        self.progressView.isHidden = true
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.progressTintColor = progressTintColor
    }
    
    func loadingURL(urltring: String) {
        let urlstr = URL(string: urltring)
        if urlstr == nil {
            return
        }
        self.webView!.load(URLRequest(url: urlstr!))
    }
    
    //MARK: ----  observeValue ---
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if object as? NSObject == self.webView {
                LOG(self.webView.estimatedProgress)
                if self.webView.estimatedProgress > 0.2 {
                    self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
                }
            }
            if self.webView.estimatedProgress >= 1.0 {
                self.progressView.setProgress(0.99999, animated: true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                    self.progressView.isHidden = true
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: ---- WKNavigationDelegate ----
    //开始加载
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        self.progressView.isHidden = false
        self.progressView.setProgress(0.2, animated: true)
        LOG("_____开始加载_____")
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        LOG("_____完成加载_____")
        self.progressView.setProgress(0.99999, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.progressView.isHidden = true
        }
        self.webView.scrollView.ly_hideEmptyView()
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        LOG("_____加载失败_____")
        self.webView.scrollView.ly_showEmptyView()
        self.progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(message)
        if message.contains("http") {
            open(scheme: message)
        } else {
            open(scheme: "tel:\(message)")
        }
        completionHandler()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        let scheme = url?.scheme
        guard let schemeStr = scheme else { return  }
        if schemeStr == "tel" {
            open(scheme: schemeStr)
        }
        decisionHandler(.allow)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}



