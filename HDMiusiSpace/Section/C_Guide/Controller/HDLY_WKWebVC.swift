//
//  HDLY_WKWebVC.swift
//  HDDongBeiLieShi
//
//  Created by liuyi on 2018/9/28.
//  Copyright © 2018年 hengdawb. All rights reserved.
//

import UIKit
import WebKit
//let kTopHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height + 44
class HDLY_WKWebVC: UIViewController,WKNavigationDelegate,WKUIDelegate {
    
    public var urlPath: String?
    public var titleName: String?
    
    fileprivate var webView: WKWebView!
    fileprivate var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.titleName
        initWkWebView()
        initProgressView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func refreshAction() {
        if urlPath != nil {
            loadingURL(urltring: urlPath!)
        }
    }
    
    //MARK: ---------- 初始化 webView ----------
    func initWkWebView() {
        
        self.webView = WKWebView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight-kTopHeight))
        self.view.addSubview(self.webView!)
        
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        //监听进度
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
        weak var weakSelf = self
        
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //MARK: ---------- 初始化progressView ----------
    func initProgressView() {
        
        self.progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        self.progressView.frame = CGRect(x: 0, y:0 , width: ScreenWidth, height: 5.0)
        self.webView.addSubview(self.progressView)
        self.progressView.isHidden = true
        self.progressView.trackTintColor = UIColor.clear
        self.progressView.progressTintColor = UIColor.red
    }
    
    func loadingURL(urltring: String) {
        let urlstr = URL(string: urltring)
        self.webView!.load(URLRequest(url: urlstr!))
    }
    
    //MARK: ----  observeValue ---
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if object as? NSObject == self.webView {
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
        
    }
    
    //完成加载
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
    }
    
    //加载失败
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        
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
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


